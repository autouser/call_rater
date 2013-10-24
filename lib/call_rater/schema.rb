module CallRater
  class Schema
    def self.define
      ActiveRecord::Schema.define do

        ActiveRecord::Migration.verbose = false

        create_table :calls do |t|
          t.datetime   :timestamp, null: false
          t.string     :caller, null: false
          t.string     :callee, null: false
          t.integer    :duration, null: false, default: 0
        end

        create_table   :destinations do |t|
          t.string     :name, null: false
          t.string     :prefix, null: false
          t.integer    :price_per_minute, null: false, default: 0
        end

        create_table :pricings do |t|
          t.references :call
          t.references :destination
          t.float      :amount, null: false, default: 0
        end

      end
    end
  end
end