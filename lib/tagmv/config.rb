require 'yaml'

module Tagmv
  class Config
    def initialize(options = {})
      @path = options[:path] || File.expand_path("~/.tagmv.yml")
    end

    def defaults
      {top_level_tags: ["blog", "media"]}
    end

    def load
      if File.file?(@path)
        YAML.load(File.open(@path).read)
      else
        config = defaults
        save(config)
        config
      end
    end

    def save(config)
      File.open(@path, 'w') { |f| f.write(config.to_yaml) }
    end
  end
end
