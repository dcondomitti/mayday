require 'bundler/setup'
Bundler.require(:default)

require 'json'
require 'base64'
require 'net/http'
require './models/configuration'
require './models/graphite'
require './models/graph'
require './models/metric'

config = Mayday::Configuration.new('./config/metrics.yml')
graphite = Mayday::Graphite.new(config.graphite)

$metrics = Hash.new
$graphs = Hash.new

config.metrics.each do |name,metric|
  $metrics[name] = Mayday::Metric.new(graphite, metric)
end

config.graphs.each do |name,graph|
  $graphs[name] = Mayday::Graph.new(graphite, graph)
end

module Mayday
  class App < Sinatra::Application

    configure do
      enable :logging
    end
    
    get '/' do
      @graphs = $graphs
      @metrics = $metrics
      erb :index
    end

    get '/graphs' do
      content_type :text
      $graphs.to_yaml
    end

    get '/metrics' do
      content_type :text
      $metrics.to_yaml
    end

    get '/graph/:graph.txt' do
      content_type :text
      $graphs[params[:graph]].to_yaml
    end

    get '/graph/:graph' do
      content_type :png
      $graphs[params[:graph]].img_data
    end

    get '/metric/:metric.txt' do
      content_type :text
      $metrics[params[:metric]].to_yaml
    end

    get '/metric/:metric' do
      $metrics[params[:metric]].to_s
    end
  end
end

run Mayday::App
