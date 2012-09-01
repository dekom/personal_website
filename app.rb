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
    haml :index
  end

  get "/favicon.ico" do
  end

  get "/docs/:name" do
    if File.exists?("docs/#{params[:name]}.textile")
      textile :'/docs/params[:name]', layout_engine: :haml, layout: :'/doc/layout'
    else
      raise error(404)
    end
  end

  get "/:name" do
    haml params[:name].to_sym
  end

  get "/stylesheets/*.css" do |path|
    content_type "text/css", charset: "utf-8"
    scss "scss/#{path}".to_sym
  end
end
