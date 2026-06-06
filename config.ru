require "bundler"
Bundler.require

require "sinatra/base"

require_relative "app/app.rb"

use NotesController
use ScrapsController
run ApplicationController
