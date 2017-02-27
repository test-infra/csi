# frozen_string_literal: true
require 'aws-sdk'

module CSI
  module AWS
    # This module provides a client for making API requests to AWS CloudFormation.
    module CloudFormation
      @@logger = CSI::Plugins::CSILogger.create

      # Supported Method Parameters::
      # CSI::AWS::CloudFormation.connect(
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

        @@logger.info('Connecting to AWS Cloud Formation...')
        if sts_session_token == ''
          cloud_formation_obj = Aws::CloudFormation::Client.new(
            region: region,
            access_key_id: access_key_id,
            secret_access_key: secret_access_key
          )
        else
          cloud_formation_obj = Aws::CloudFormation::Client.new(
            region: region,
            access_key_id: access_key_id,
            secret_access_key: secret_access_key,
            session_token: sts_session_token
          )
        end
        @@logger.info("complete.\n")

        return cloud_formation_obj
      rescue => e
        return e.message
      end

      # Supported Method Parameters::
      # CSI::AWS::CloudFormation.disconnect(
      #   cloud_formation_obj: 'required - cloud_formation_obj returned from #connect method'
      # )

      public

      def self.disconnect(opts = {})
        cloud_formation_obj = opts[:cloud_formation_obj]
        @@logger.info('Disconnecting...')
        cloud_formation_obj = nil
        @@logger.info("complete.\n")

        cloud_formation_obj
      rescue => e
        return e.message
      end

      # Author(s):: Jacob Hoopes <jake.hoopes@gmail.com>

      public

      def self.authors
        authors = "AUTHOR(S):
          Jacob Hoopes <jake.hoopes@gmail.com>
        "

        authors
      end

      # Display Usage for this Module

      public

      def self.help
        puts "USAGE:
          cloud_formation_obj = #{self}.connect(
            region: 'required - region name to connect (eu-west-1, ap-southeast-1, ap-southeast-2, eu-central-1, ap-northeast-2, ap-northeast-1, us-east-1, sa-east-1, us-west-1, us-west-2)',
            access_key_id: 'required - Use AWS STS for best privacy (i.e. temporary access key id)',
            secret_access_key: 'required - Use AWS STS for best privacy (i.e. temporary secret access key',
            sts_session_token: 'optional - Temporary token returned by STS client for best privacy'
          )
          puts cloud_formation_obj.public_methods

          #{self}.disconnect(
            cloud_formation_obj: 'required - cloud_formation_obj returned from #connect method'
          )

          #{self}.authors
        "
      end
    end
  end
end
