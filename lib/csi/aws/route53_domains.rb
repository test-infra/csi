# frozen_string_literal: true
require 'aws-sdk'

module CSI
  module AWS
    # This module provides a client for making API requests to Amazon Route 53 Domains.
    module Route53Domains
      @@logger = CSI::Plugins::CSILogger.create()

      # Supported Method Parameters::
      # CSI::AWS::Route53Domains.connect(
      #   region: 'required - region name to connect (eu-west-1, ap-southeast-1, ap-southeast-2, eu-central-1, ap-northeast-2, ap-northeast-1, us-east-1, sa-east-1, us-west-1, us-west-2)',
      #   access_key_id: 'required - Use AWS STS for best privacy (i.e. temporary access key id)',
      #   secret_access_key: 'required - Use AWS STS for best privacy (i.e. temporary secret access key',
      #   sts_session_token: 'optional - Temporary token returned by STS client for best privacy'
      # )
      public
      def self.connect(opts = {})
        region = opts[:region].to_s.scrub.chomp.strip
        access_key_id = opts[:access_key_id].to_s.scrub.chomp.strip
        secret_access_key = opts[:secret_access_key].to_s.scrub.chomp.strip
        sts_session_token = opts[:sts_session_token].to_s.scrub.chomp.strip

        begin
          @@logger.info('Connecting to AWS Route53Domains...')
          if sts_session_token == ''
            r53_domains_obj = Aws::Route53Domains::Client.new(
              region: region,
              access_key_id: access_key_id,
              secret_access_key: secret_access_key
            )
          else
            r53_domains_obj = Aws::Route53Domains::Client.new(
              region: region,
              access_key_id: access_key_id,
              secret_access_key: secret_access_key,
              session_token: sts_session_token
            )
          end
          @@logger.info("complete.\n")

          return r53_domains_obj  
        rescue => e
          return e.message
        end
      end

      # Supported Method Parameters::
      # CSI::AWS::Route53Domains.disconnect(
      #   r53_domains_obj: 'required - r53_domains_obj returned from #connect method'
      # )
      public
      def self.disconnect(opts = {})
        r53_domains_obj = opts[:r53_domains_obj]
        @@logger.info('Disconnecting...')
        r53_domains_obj = nil
        @@logger.info("complete.\n")

        return r53_domains_obj
      end

      # Author(s):: Jacob Hoopes <jake.hoopes@gmail.com>
      public
      def self.authors
        authors = %Q{AUTHOR(S):
          Jacob Hoopes <jake.hoopes@gmail.com>
        }

        return authors
      end

      # Display Usage for this Module
      public
      def self.help
        puts %Q{USAGE:
          r53_domains_obj = #{self}.connect(
            region: 'required - region name to connect (eu-west-1, ap-southeast-1, ap-southeast-2, eu-central-1, ap-northeast-2, ap-northeast-1, us-east-1, sa-east-1, us-west-1, us-west-2)',
            access_key_id: 'required - Use AWS STS for best privacy (i.e. temporary access key id)',
            secret_access_key: 'required - Use AWS STS for best privacy (i.e. temporary secret access key',
            sts_session_token: 'optional - Temporary token returned by STS client for best privacy'
          )
          puts r53_domains_obj.public_methods

          #{self}.disconnect(
            r53_domains_obj: 'required - r53_domains_obj returned from #connect method'
          )

          #{self}.authors
        }
      end
    end
  end
end
