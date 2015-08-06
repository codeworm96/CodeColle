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
      @rules << Rule.new(:string, /\A(".*?[^\\]"|"")/)
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

end

