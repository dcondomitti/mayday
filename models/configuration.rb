module Mayday
  class Configuration
    attr_accessor :metrics, :graphs, :graphite

    def initialize(config_path)
      config = YAML.load_file(config_path)
      config.each { |key, value| instance_variable_set("@#{key}", value) }
    end

  end
end