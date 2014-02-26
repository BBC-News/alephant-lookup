require 'crimp'
require 'alephant/lookup/lookup_location'

module Alephant
  module Lookup
    class LookupQuery < LookupLocation
      attr_reader :opts_hash
      attr_writer :location

      def initialize(component_id, opts, location = nil)
        super(component_id, opts, location)
        @opts_hash = hash_for(opts)
      end

      private

      def to_h
        {
          :component_id => @component_id,
          :opts_hash => @opts_hash
          :location => @location
        }
      end

      def hash_for(opts)
        Crimp.signature opts
      end
    end
  end
end
