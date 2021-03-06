require "dalli"
require "alephant/logger"

module Alephant
  module Lookup
    class LookupCache
      include Logger

      attr_reader :config

      DEFAULT_TTL  = 2

      def initialize(config={})
        @config = config

        unless config_endpoint.nil?
          @client ||= ::Dalli::Client.new(config_endpoint, { :expires_in => ttl })
        else
          logger.warn(
            method:  'Alephant::Lookup::LookupCache#initialize',
            message: 'No config endpoint, NullClient used'
          )
          logger.metric "NoConfigEndpoint"
          @client = NullClient.new
        end
      end

      def get(key, &block)
        begin
          versioned_key = versioned key
          result = @client.get versioned_key
          logger.info(
            event:  'Alephant::LookupCache#get',
            key:    versioned_key,
            result: result ? 'hit' : 'miss'
          )
          logger.metric 'GetKeyMiss' unless result
          result ? result : set(key, block.call)
        rescue StandardError => error
          logger.error(
            event:  'LookupCacheError',
            method: "#{self.class}#get",
            error:  error
          )
          block.call
        end
      end

      def set(key, value, ttl = nil)
        value.tap { |o| @client.set(versioned(key), o, ttl) }
      end

      private

      def config_endpoint
        config[:elasticache_config_endpoint] || config["elasticache_config_endpoint"]
      end

      def ttl
        config[:lookup_elasticache_ttl] || config["lookup_elasticache_ttl"] || DEFAULT_TTL
      end

      def versioned(key)
        [key, cache_version].compact.join("_")
      end

      def cache_version
        config[:elasticache_cache_version] || config["elasticache_cache_version"]
      end
    end

    class NullClient
      def get(key); end

      def set(key, value, ttl = nil)
        value
      end
    end
  end
end
