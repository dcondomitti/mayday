module Mayday
  class Graphite
    def initialize(opts)
      @hostname = ENV['GRAPHITE_HOSTNAME'] || opts.fetch('hostname')
      @ssl = !!(ENV['GRAPHITE_SECURE'] && ENV['GRAPHITE_SECURE'] == 'true') || opts.fetch('ssl', false)
    end

    def url(params)
      "#{protocol}://#{@hostname}/render/?#{params}"
    end

    def protocol
      secure? ? 'https' : 'http'
    end

    def secure?
      !!@ssl
    end
  end
end
