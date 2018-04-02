require 'time'
require 'base64'
require 'openssl'
require 'json'
require 'rest-client'

module Aliyun
  module Cloudpush
    class Client
      attr_reader :app_key, :access_key_id, :access_key_secret

      def initialize(app_key, access_key_id, access_key_secret)
        @access_key_id = access_key_id
        @access_key_secret = access_key_secret
        @app_key = app_key
      end

      def push(employee_id, title, body, options = {})
        params = {
          "TargetValue": employee_id,
          "Title": title,
          "Body": body,
        }
        http_post(default_push_params.merge(params).merge(options))
      end

      private

        def default_push_params
          {
            "Action": "Push",
            "AppKey": self.app_key,
            "Target": "ACCOUNT",
            "DeviceType": "ALL",
            "PushType": "NOTICE",
            "iOSApnsEnv": "PRODUCT",
            "AndroidOpenType": "APPLICATION",
            "iOSBadge": "0"
          }
        end

        def default_params
          {
            'Format': "json",
            'RegionId': "cn-hangzhou",
            'Version': "2016-08-01",
            'AccessKeyId': self.access_key_id,
            'SignatureMethod': "HMAC-SHA1",
            'SignatureVersion': "1.0",
            'SignatureNonce': (rand * 1_000_000_000).to_s,
            'Timestamp': Time.now.utc.iso8601
          }
        end

        def params_str(action, params)
          str = params.sort.map { |k, v| [CGI.escape(k.to_s), escape(v.to_s)].join('=') }.join('&')
          "#{action}&#{CGI.escape('/')}&#{CGI.escape(str)}"
        end

        def signature(str)
          Base64.strict_encode64(
            OpenSSL::HMAC.digest('sha1', "#{self.access_key_secret}&", str)
          )
        end

        def http_post(params = {})
          p = default_params.merge(params)
          s = signature(params_str('POST', p))
          res = RestClient.post(ENDPOINT, p.merge('Signature': s))
          JSON.parse(res)
        rescue RestClient::ExceptionWithResponse =>e
          puts e.response
        end

        def escape(str)
          # https://help.aliyun.com/document_detail/48047.html?spm=a2c4g.11186623.2.4.NsNXUo
          # convert space " " to "%20" instead of "+"
          CGI.escape(str).gsub("+", "%20")
        end
    end
  end
end
