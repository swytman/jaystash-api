
require 'bundler'
Bundler.require(:default)
#require 'sass/plugin/rack'
require './app'
#Sass::Plugin.options[:style] = :compressed
#use Sass::Plugin::Rack
use Rack::Coffee, root: 'public', urls: '/js'
run App