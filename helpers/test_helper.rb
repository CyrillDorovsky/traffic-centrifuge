ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'bunny'
require 'hashids'
require 'fileutils'
require 'json'
require 'redis'

require File.expand_path '../../app.rb', __FILE__