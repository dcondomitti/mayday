module Mayday
  class Graph
    attr_accessor :target, :height, :width, :period

    def initialize(graphite, opts = Hash.new)
      @graphite = graphite
      @target = opts.fetch('target')
      @height = opts.fetch('height', 30)
      @width = opts.fetch('width', 150)
      @color = opts.fetch('color', 'ffffff')
      @period = opts.fetch('period', '15min')
    end

    def url
      URI::escape(@graphite.url(%{from=-#{@period}&height=#{@height}&width=#{@width}&yMin=0&lineMode=slope&thickness=2&bgcolor=\#721f19&graphOnly=true&target=color(#{@target},"#{@color}")}))
    end

    def content
      # Data URIs, what up.
      self.fetch
    end

    def fetch
      Typhoeus.get(url, followlocation: true).response_body
    end

    def img_data
      self.content
    end
    
    def to_s
      "data:image/png;base64,#{Base64.encode64(self.fetch)}"
    end
  end
end
