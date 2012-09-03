# encoding: utf-8
#
require "rubygems"
require "bundler/setup"
require "sinatra/base"
require "zurb-foundation"

require "sinatra/content_for2"
require "sass/plugin/rack"
require "haml"
require "redcloth"

module Tilt
  class RedClothTemplate < Template
    def prepare
      @data.force_encoding Encoding.default_external
      @engine = RedCloth.new(data)
      @output = nil
    end
  end
end

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
    content_type "text/html", charset: "utf-8"
    haml :index
  end

  get "/favicon.ico" do
  end

  get "/docs/:name" do
    if File.exists?("views/docs/#{params[:name]}.textile")
      content_type "text/html", charset: "utf-8"
      @text = textile :"/docs/#{params[:name]}"
      textile :"/docs/#{params[:name]}", layout_engine: :haml, layout: :'/docs/layout'
    else
      raise error(404)
    end
  end

  get "/:name" do
    content_type "text/html", charset: "utf-8"
    haml params[:name].to_sym
  end

  get "/stylesheets/*.css" do |path|
    if File.exists?("views/scss/#{path}.scss")
      content_type "text/css", charset: "utf-8"
      scss "scss/#{path}".to_sym
    else
      raise error(404)
    end
  end
end
