module CallRater
  class Connection

    attr_accessor :config

    def initialize(args={})
      self.config = args
    end

    def connect(use_database=false)
      connection_config = use_database ? config : config.reject {|k, v| k == :database}
      ::ActiveRecord::Base.establish_connection connection_config
    end

    def connection
      ::ActiveRecord::Base.connection
    end

    def create_database
      connect(false)
      connection.create_database config[:database]
      connect(true)
      CallRater::Schema.define
    end

    def drop_database
      connect(false)
      connection.drop_database config[:database]
    end

  end
end