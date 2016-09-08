require 'rubygems'
require 'bundler'
require 'fluent/test'
require 'fluent/log'
require 'fluent/plugin/in_top'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  exit e.status_code
end
