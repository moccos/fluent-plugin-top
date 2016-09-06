require 'rubygems'
require 'bundler'
require 'test/unit'
require 'fluent/test'
require 'fluent/plugin/in_top'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  exit e.status_code
end
