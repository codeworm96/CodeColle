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
      !@input.empty?
    end

    def remove_whitespace
      @input.lstrip!
    end

    def get_token
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

