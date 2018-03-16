require 'time'
require 'base64'
require 'openssl'
require 'json'
require 'rest-client'

module Aliyun
  module Cloudpush
    class Client

      def push(employee_id, title, body)
        params = {
          "TargetValue": employee_id,
          "Title": title,
          "Body": body,
        }
        http_post(default_push_params.merge(params))
      end

      private

        def default_push_params
          {
            "Action": "Push",
            "AppKey": Aliyun::Cloudpush.app_key,
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
            'AccessKeyId': Aliyun::Cloudpush.access_key_id,
            'SignatureMethod': "HMAC-SHA1",
            'SignatureVersion': "1.0",
            'SignatureNonce': (rand * 1_000_000_000).to_s,
            'Timestamp': Time.now.utc.iso8601
          }
        end

        def params_str(action, params)
          str = params.sort.map { |k, v| [CGI.escape(k.to_s), CGI.escape(v.to_s)].join('=') }.join('&')
          "#{action}&#{CGI.escape('/')}&#{CGI.escape(str)}"
        end

        def signature(str)
          Base64.strict_encode64(
            OpenSSL::HMAC.digest('sha1', "#{Aliyun::Cloudpush.access_key_secret}&", str)
          )
        end

        def http_post(params = {})
          p = default_params.merge(params)
          s = signature(params_str('POST', p))
          res = RestClient.post(ENDPOINT, p.merge('Signature': s))
          JSON.parse(res)
        end
    end
  end
end
