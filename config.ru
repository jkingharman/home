# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require "rubygems"
require "bundler"
require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

Bundler.require

Dir.glob('./app/{controllers}/*.rb').each { |file| require file }

# Load app
require_relative "app/controllers/application_controller"
require_relative "app/controllers/scraps_controller"

use ScrapsController
run  ApplicationController
