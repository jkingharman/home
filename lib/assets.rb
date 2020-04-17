class Assets < Sinatra::Base
  # A class to replicate Rail's asset pipeline functionality.
  # Credit to Brandur: https://mutelight.org/asset-pipeline
  configure do
    set :assets, (Sprockets::Environment.new do |env|
      path = File.expand_path('../../', __FILE__)
      env.append_path(path + '/assets/images')
      env.append_path(path + '/assets/javascripts')
      env.append_path(path + '/assets/stylesheets')

      if ENV['RACK_ENV'] == 'production'
        env.js_compressor  = :uglify
        env.css_compressor = :scss
      end
    end)
  end

  get '/assets/app.js' do
    content_type('application/javascript')
    settings.assets['app.js']
  end

  get '/assets/app.css' do
    content_type('text/css')
    settings.assets['app.css']
  end

  %w[jpg png].each do |format|
    get "/assets/:image.#{format}" do |image|
      content_type("image/#{format}")
      settings.assets["#{image}.#{format}"]
    end

    get "/assets/:folder/:image.#{format}" do |folder, image|
      content_type("image/#{format}")
      settings.assets["#{folder}/#{image}.#{format}"]
    end
  end
end
