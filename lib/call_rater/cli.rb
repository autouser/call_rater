require "thor"
require 'fileutils'
module CallRater
  class CLI < Thor

    desc "init", "initialize config"

    def init
      puts "Initializing..."
      source_path = File.expand_path('../../../share/crdb_config_example.yaml', __FILE__)
      # puts source_path
      target_path = File.expand_path('~/crdb_config.yaml')
      FileUtils.cp(source_path, target_path)
      puts "Config created. Please check it in #{target_path}"
    end

    desc "init_db", "initialize database layout (WARNING! Database will be deleted!)"
    def init_db
      puts "Initializing Database..."
      require 'pp'
      CallRater.resolve_config
      con = CallRater::Connection.new(CallRater.connection_config)
      con.drop_database
      con.create_database
    end

    desc "execute", "Rate unrated calls"
    def execute
      puts "Rating calls..."
      require 'pp'
      CallRater.resolve_config
      con = CallRater::Connection.new(CallRater.connection_config)
      con.connect(true)
      Call.process
    end

  end
end