module Mayday
  class Metric
    attr_accessor :target, :period

    def initialize(graphite, opts = Hash.new)
      @graphite = graphite
      @target = opts.fetch('target')
      @scale = opts.fetch('scale', 1)
      @period = opts.fetch('period', '15min')
    end

    def url
      URI::escape(@graphite.url(%{from=-#{@period}&alignToFrom=true&format=json&target=summarize(#{@target},"#{@period}", "avg")}))
    end

    def content
      begin
        # It's ugly because it looks like this:
        # [{"target": "bandwidth", "datapoints": [[555, 1360205100], [555, 1360206000]]}]
        metric = JSON.parse(self.fetch).first['datapoints'].first.first
        if @scale
          "%0.2f" % (metric * @scale)
        else
          "%i" % metric
        end
      rescue
        'n/a'
      end
    end

    def fetch
      Typhoeus.get(url, followlocation: true).response_body
    end

    def to_s
      self.content
    end

  end
end