require 'aws-sdk'
require 'thread'
require 'timeout'

module Alephant
  module Lookup
    class LookupTable
      attr_reader :table_name

      TIMEOUT = 120
      DEFAULT_CONFIG = {
        :write_units => 5,
        :read_units  => 10
      }
      SCHEMA = {
        :hash_key => {
          :component_key => :string
        },
        :range_key => {
          :batch_version => :number
        }
      }

      def initialize(table_name, config = DEFAULT_CONFIG)
        @mutex      = Mutex.new
        @dynamo_db  = AWS::DynamoDB.new
        @table_name = table_name
        @config     = config
      end

      def create
        @mutex.synchronize do
          ensure_table_exists
          ensure_table_active
        end
      end

      def table
        @table ||= @dynamo_db.tables[@table_name]
      end

      private

      def ensure_table_exists
        create_dynamodb_table unless table.exists?
      end

      def ensure_table_active
        sleep_until_table_active unless table_active?
      end

      def create_dynamodb_table
        @table = @dynamo_db.tables.create(
          @table_name,
          @config[:read_units],
          @config[:write_units],
          SCHEMA
        )
      end

      def table_active?
        table.status == :active
      end

      def sleep_until_table_active
        begin
          Timeout::timeout(TIMEOUT) do
            sleep 1 until table_active?
          end
        end
      end
    end
  end
end
