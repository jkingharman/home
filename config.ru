require "bundler"
Bundler.require

require "rubygems"
require 'sass/plugin/rack'
require "active_record"
require 'sinatra/base'
require 'sprockets'
require 'sass'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

# Load app
require_relative "app/app.rb"

use Assets
use NotesController
use ReadController
use CodeController
run ApplicationController
