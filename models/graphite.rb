module Mayday
  class Graphite
    def initialize(opts)
      @hostname = opts.fetch('hostname', ENV['GRAPHITE_HOSTNAME'])
      @ssl = opts.fetch('ssl', ENV['GRAPHITE_SECURE'] || true)
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