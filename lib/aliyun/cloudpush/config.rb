module Aliyun
  module Cloudpush
    class << self
      attr_accessor :config

      def configure
        yield self.config ||= Config.new
      end

      def app_key
        @app_key ||= config.app_key
      end

      def app_secret
        @app_secret ||= config.app_secret
      end

      def access_key_id
        @access_key_id ||= config.access_key_id
      end

      def access_key_secret
        @access_key_secret ||= config.access_key_secret
      end
    end

    class Config
      attr_accessor :app_key, :app_secret, :access_key_id, :access_key_secret
    end
  end
end
