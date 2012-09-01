require "rubygems"
require "bundler/setup"
require "sinatra/base"
require "zurb-foundation"

require "sinatra/content_for2"
require "sass/plugin/rack"
require "haml"
require "redcloth"

class App < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  configure :production, :development do
    Compass.configuration do |config|
      config.project_path = File.dirname __FILE__
      config.sass_dir = File.join "views", "scss"
      config.images_dir = File.join "views", "images"
      config.http_path = "/"
      config.http_images_path = "/images"
      config.http_stylesheets_path = "/stylesheets"
    end

    set :scss, Compass.sass_engine_options
  end

  configure :production, :development do
    helpers Sinatra::ContentFor2
  end

  
  configure :production, :development do
    set :haml, format: :html5
  end

  get "/" do
    haml :index, views: 'views', layout: 'layout'
  end

  get "/favicon.ico" do
  end

  get "/docs/:name" do
    if File.exists?("docs/#{params[:name]}.textile")
      textile params[:name].to_sym, views: 'docs', layout_engine: :haml, layout: :'layout'
    end
  end

  get "/:name" do
    haml params[:name].to_sym, views: 'views', layout: :'layout'
  end

  get "/stylesheets/*.css" do |path|
    content_type "text/css", charset: "utf-8"
    scss "scss/#{path}".to_sym
  end
end
