module Ethon
  class Easy
    # This module contains the logic around adding resolve overrides to libcurl.
    #
    # @api private
    module Resolve
      # Return resolve overrides, return empty hash if none.
      #
      # @example Return the resolve overrides.
      #   easy.resolve_overrides
      #
      # @return [ Hash ] The resolve overrides.
      def resolve_overrides
        @resolve_overrides ||= {}
      end

      # Set the resolve overrides.
      #
      # @example Set the resolve overrides.
      #   easy.resolve_overrides = {'www.example.com:80' => '127.0.0.1'}
      #
      # @param [ Hash ] resolvers The resolvers.
      def resolve_overrides=(resolvers)
        resolvers ||= {}
        resolver_list = nil
        resolvers.each do |k, v|
          resolver_list = Curl.slist_append(resolver_list, compose_resolver(k,v))
        end
        Curl.set_option(:resolve, resolver_list, handle)

        @resolver_list = resolver_list && FFI::AutoPointer.new(resolver_list, Curl.method(:slist_free_all))
      end

      # Return resolver_list.
      #
      # @example Return resolver_list.
      #   easy.resolver_list
      #
      # @return [ FFI::Pointer ] The resolver list.
      def resolver_list
        @resolver_list
      end

      # Compose libcurl resolve string from key and value.
      # Also replaces null bytes, because libcurl will complain
      # otherwise.
      #
      # @example Compose resolver.
      #   easy.compose_resolver('www.example.com:80', '127.0.0.1')
      #
      # @param [ String ] key The host:port to force resolve of.
      # @param [ String ] value The address to resolve to.
      #
      # @return [ String ] The composed resolver.
      def compose_resolver(key, value)
        Util.escape_zero_byte("#{key}:#{value}")
      end
    end
  end
end
