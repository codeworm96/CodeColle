module JSON

  class Token

    attr_accessor :type, :content

    def initialize(type, content)
      @type = type
      @content = content
    end

    def ==(other)
      other.type == type && other.content == content
    end

  end

  class Tokenizer

    #lexical rule
    class Rule

      attr_reader :type, :pattern

      def initialize(type, pattern)
        @type = type
        @pattern = pattern
      end
      
    end

    def initialize(input)
      load_rules
      @input = input
      remove_whitespace
      @buf = nil
    end

    def load_rules
      @rules = []
      @rules << Rule.new(:symbol, /\A[\[\]{},:]/)
      @rules << Rule.new(:null, /\A(null)/)
      @rules << Rule.new(:boolean, /\A(true|false)/)
      @rules << Rule.new(:string, /\A(""|".*?[^\\]")/)
      @rules << Rule.new(:number, /\A[+-]?\d+(.\d+)?([eE][+-]?\d+)?/)
    end

    def has_more_token?
      !@buf.nil? || !@input.empty?
    end

    def remove_whitespace
      @input.lstrip!
    end

    def put_back(token)
      @buf = token
    end

    def get_token
      if !@buf.nil?
        res = @buf
        @buf = nil
        return res
      end

      match_data = nil
      type = nil
      @rules.each do |rule|
        match_data = rule.pattern.match(@input)
        type = rule.type
        break unless match_data.nil?
      end

      raise RuntimeError if match_data.nil?

      @input = match_data.post_match
      remove_whitespace

      Token.new(type, match_data.to_s)
    end

  end

  def self.parse(s)
    parse_exp(Tokenizer.new(s))
  end

  def self.parse_exp(tokenizer)
    token = tokenizer.get_token
    if token.type == :symbol
      if token.content == "["
        tokenizer.put_back(token)
        parse_arr(tokenizer)
      elsif token.content == "{"
        tokenizer.put_back(token)
        parse_obj(tokenizer)
      end
    else
      tokenizer.put_back(token)
      parse_atom(tokenizer)
    end
  end

  def self.parse_obj(tokenizer)
    tokenizer.get_token
    res = {};
    while true
      name = parse_string(tokenizer)
      tokenizer.get_token
      value = parse_exp(tokenizer)
      res[name] = value
      token = tokenizer.get_token
      if token.type == :symbol && token.content == "}"
        break
      end
    end
    res
  end

  def self.parse_arr(tokenizer)
    tokenizer.get_token
    res = [];
    while true
      value = parse_exp(tokenizer)
      res << value
      token = tokenizer.get_token
      if token.type == :symbol && token.content == "]"
        break
      end
    end
    res
  end

  def self.parse_number(tokenizer)
    token = tokenizer.get_token
    token.content.to_f
  end

  def self.parse_null(tokenizer)
    tokenizer.get_token
    nil
  end

  def self.parse_boolean(tokenizer)
    token = tokenizer.get_token
    if token.content == "true"
      true
    elsif token.content == "false"
      false
    end
  end

  #TODO: escape
  def self.parse_string(tokenizer)
    token = tokenizer.get_token
    token.content[1..-2]
  end

  def self.parse_atom(tokenizer)
    token = tokenizer.get_token
    if token.type == :number
      tokenizer.put_back(token)
      parse_number(tokenizer)
    elsif token.type == :boolean
      tokenizer.put_back(token)
      parse_boolean(tokenizer)
    elsif token.type == :null
      tokenizer.put_back(token)
      parse_null(tokenizer)
    elsif token.type == :string
      tokenizer.put_back(token)
      parse_string(tokenizer)
    end
  end
end

