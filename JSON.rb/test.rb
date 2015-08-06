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

  def test_boolean
    @tokenizer = JSON::Tokenizer.new("  true  ")
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:boolean, "true"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new("  false  ")
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:boolean, "false"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)
  end

  def test_null
    @tokenizer = JSON::Tokenizer.new("  null  ")
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:null, "null"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)
  end

  def test_string
    @tokenizer = JSON::Tokenizer.new('  ""  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:string, '""'), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new('  "nested \"quotes\""  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:string, '"nested \"quotes\""'), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)
  end

  def test_number
    @tokenizer = JSON::Tokenizer.new('  42  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:number, "42"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new('  -42  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:number, "-42"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new('  +42  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:number, "+42"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new('  3.14  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:number, "3.14"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new('  -0.01  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:number, "-0.01"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new('  1e8  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:number, "1e8"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer = JSON::Tokenizer.new('  1E+8  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:number, "1E+8"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)
    
    @tokenizer = JSON::Tokenizer.new('  2.0E-8  ')
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:number, "2.0E-8"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)
  end

  def test_put_back
    @tokenizer = JSON::Tokenizer.new("  null  ")
    assert_equal(true, @tokenizer.has_more_token?)
    token = @tokenizer.get_token
    assert_equal(JSON::Token.new(:null, "null"), token)
    assert_equal(false, @tokenizer.has_more_token?)

    @tokenizer.put_back(token)
    assert_equal(true, @tokenizer.has_more_token?)
    assert_equal(JSON::Token.new(:null, "null"), @tokenizer.get_token)
    assert_equal(false, @tokenizer.has_more_token?)
  end

end

class TestParser < Test::Unit::TestCase

  def test_null
    assert_nil(JSON.parse("   null  "))
  end

  def test_boolean
    assert_equal(true, JSON.parse("   true  "))
    assert_equal(false, JSON.parse("   false  "))
  end

  def test_string
    assert_equal("JSON", JSON.parse('   "JSON"  '))
  end

  def test_number
    assert_equal(42, JSON.parse("   42  "))
    assert_equal(-42, JSON.parse("   -42  "))
    assert_equal(42, JSON.parse("   +42  "))
    assert_equal(3.14, JSON.parse("   3.14  "))
    assert_equal(-0.01, JSON.parse("   -0.01  "))
    assert_equal(1e4, JSON.parse("   1e4  "))
    assert_equal(0.21, JSON.parse("   2.1e-1  "))
  end

  def test_object
    assert_equal({ "a" => 1, "b" => true}, JSON.parse('{"a":1, "b":true}'))
  end

  def test_array
    assert_equal([1, nil, false], JSON.parse('[1, null, false]'))
  end
end

