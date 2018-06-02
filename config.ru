require "bundler"
Bundler.require

require "rubygems"
require 'sass/plugin/rack'
require "active_record"

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

# Load app
require_relative "app/app.rb"

use Assets
use NotesController
run ApplicationController
