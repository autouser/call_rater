require "call_rater/version"
require 'active_record'

module CallRater

  def self.resolve_config
    if ENV['CRDB_CONFIG']
      @@config ||= YAML.load_file( File.expand_path(ENV['CRDB_CONFIG']) )
    elsif ENV['CRDB_TEST_USERNAME']
      @@config = {
        db: {
          adapter: 'mysql2',
          database: ENV['CRDB_USERNAME'] || 'call_rater',
          username: ENV['CRDB_USERNAME'],
          password: ENV['CRDB_PASSWORD']
        }
      }
    else
      @@config ||= YAML.load_file( File.expand_path('~/crdb_config.yaml') )
    end
  end

  def self.connection_config
    @@config[:db]    
  end

  def self.config
    @@config
  end

end

require 'call_rater/connection'
require 'call_rater/schema'
require 'call_rater/models'
require 'call_rater/cli'