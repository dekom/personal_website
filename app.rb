# encoding: utf-8

require "rubygems"
require "bundler/setup"
require "sinatra/base"
require "compass"
require "compass_twitter_bootstrap"

require "sinatra/content_for2"
require "sass/plugin/rack"
require "redcarpet"

class App < Sinatra::Base
  configure :production, :development do
    enable :logging
    helpers Sinatra::ContentFor2
  end

  configure :production, :development do
    # Configure Compass
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

  get "/" do
    content_type "text/html", charset: "utf-8"
    erb :index
  end

  get "/favicon.ico" do
  end

  get "/docs/:name" do
    # Routing for single page documents written in textile
    if File.exists?("views/docs/#{params[:name]}.markdown")
      content_type "text/html", charset: "utf-8"
      markdown :"/docs/#{params[:name]}", layout_engine: :erb, layout: :'/docs/layout'
    else
      raise error(404)
    end
  end

  get "/:name" do
    content_type "text/html", charset: "utf-8"
    erb params[:name].to_sym
  end

  get "/stylesheets/:name.css" do
    if File.exists?("views/scss/#{params[:name]}.scss")
      content_type "text/css", charset: "utf-8"
      scss "scss/#{params[:name]}".to_sym
    else
      raise error(404)
    end
  end
end
