# Load path and gems/bundler
$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require "rubygems"
require "bundler"
require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

Bundler.require

Dir.glob('./app/{controllers}/*.rb').each { |file| require file }

require "find"
%w{config/initializers lib}.each do |load_path|
  Find.find(load_path) { |f| require f unless f.match(/\/\..+$/) || File.directory?(f) }
end

# Load app
require_relative "app/controllers/application_controller"
require_relative "app/controllers/scraps_controller"

use ScrapsController
run ApplicationController
