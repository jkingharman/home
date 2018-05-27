class Home < Sinatra::Base

  set :public => "public", :static => true

  get "/" do
    @version     = RUBY_VERSION
    @environment = ENV['RACK_ENV']

    haml :index
  end

  get "/reads" do
    haml :reads
  end
end
