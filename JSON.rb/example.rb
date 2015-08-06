require 'open-uri' 
require_relative 'JSON.rb'

input = open('http://freegeoip.net/json/202.120.1.1/').readlines.join

puts JSON.parse(input)
