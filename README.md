# CallRater

Simple call rater. Calculates calls prices and stores it in database.

Read the schema in CallRater::Schema class for database layout

Please check the 'share' directory for database samples and config example


## Installation

Clone and install it.

## Usage

    call_rater init

  Initializes a new config file. There you can specify your database connection settings.

    call_rater init_db

  Creates a new database depending on the config file. WARNING! Datatbase will be dropped before creating.

    call_rater execute

  Calculates all unrated calls.

## Testing

  Please add 

    ~/crdb_test_config.yaml

  Or set environment variable CRDB_TEST_CONFIG to the config path

  Or set environment variables CRDB_TEST_DATABASE, CRDB_TEST_USERNAME, CRDB_TEST_PASSWORD

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
