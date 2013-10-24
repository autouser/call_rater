$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'call_rater'
require 'yaml'

RSpec.configure do |config|

  def test_config

    if ENV['CRDB_TEST_CONFIG']
      @test_config ||= YAML.load_file( File.expand_path(ENV['CRDB_TEST_CONFIG']) )
    elsif ENV['CRDB_TEST_USERNAME']
      @test_config = {
        db: {
          adapter: 'mysql2',
          database: ENV['CRDB_TEST_DATABASE'] || 'call_rater_test',
          username: ENV['CRDB_TEST_USERNAME'],
          password: ENV['CRDB_TEST_PASSWORD']
        }
      }
    else
      @test_config ||= YAML.load_file( File.expand_path('~/crdb_test_config.yaml') )
    end
  end

  def clean_db!
    @connection_config = test_config[:db]
    con = CallRater::Connection.new(@connection_config)
    con.drop_database
    con.create_database
  end

  config.treat_symbols_as_metadata_keys_with_true_values = true

end