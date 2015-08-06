require 'test/unit'
require_relative 'JSON.rb'

class TestTokenizer < Test::Unit::TestCase

  def test_symbols
    @tokenizer = JSON::Tokenizer.new(",")
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:symbol, ","), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new(":")
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:symbol, ":"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new("{")
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:symbol, "{"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new("}")
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:symbol, "}"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new("[")
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:symbol, "["), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new("]")
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:symbol, "]"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)
  end

end


