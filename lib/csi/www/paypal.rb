# frozen_string_literal: true
require 'yaml'

module CSI
  module WWW
    # This plugin supports paypal.com actions.
    module Paypal
      # Supported Method Parameters::
      # browser_obj = CSI::WWW::Paypal.open(
      #   browser_type: :firefox|:chrome|:ie|:headless,
      #   proxy: 'optional - http(s)://proxy_host:port',
      #   with_tor: 'optional - boolean (defaults to false)'
      # )

      public

      def self.open(opts = {})
        browser_type = if opts[:browser_type].nil?
                         :firefox
                       else
                         opts[:browser_type]
                       end

        proxy = opts[:proxy].to_s unless opts[:proxy].nil?

        with_tor = if opts[:with_tor]
                     true
                   else
                     false
                   end

        if proxy
          if with_tor
            browser_obj = CSI::Plugins::TransparentBrowser.open(
              browser_type: browser_type,
              proxy: proxy,
              with_tor: with_tor
            )
          else
            browser_obj = CSI::Plugins::TransparentBrowser.open(
              browser_type: browser_type,
              proxy: proxy
            )
          end
        else
          browser_obj = CSI::Plugins::TransparentBrowser.open(
            browser_type: browser_type
          )
        end

        browser_obj.goto('https://www.paypal.com')

        return browser_obj
      rescue => e
        raise e
      end

      # Supported Method Parameters::
      # browser_obj = CSI::WWW::Paypal.login(
      #   browser_obj: 'required - browser_obj returned from #open method',
      #   username: 'required - username',
      #   password: 'optional - passwd (will prompt if blank),
      #   mfa: 'optional - if true prompt for mfa token (defaults to false)'
      # )

      public

      def self.login(opts = {})
        browser_obj = opts[:browser_obj]
        username = opts[:username].to_s.scrub.strip.chomp
        password = opts[:password]

        if password.nil?
          password = CSI::Plugins::AuthenticationHelper.mask_password
        else
          password = opts[:password].to_s.scrub.strip.chomp
        end
        mfa = opts[:mfa]

        browser_obj.goto('https://www.paypal.com/signin')

        browser_obj.text_field(id: 'email').wait_until_present.set(username)
        browser_obj.text_field(id: 'password').wait_until_present.set(password)
        browser_obj.button(id: 'btnLogin').wait_until_present.click

        if mfa
          # Send code to SMS
          browser_obj.button(id: 'btnSelectSoftToken').wait_until_present.click
          until browser_obj.url == 'https://www.paypal.com/myaccount/home'
            print 'enter mfa token: '
            mfa_token = gets.to_s.scrub.strip.chomp
            browser_obj.text_field(id: 'security-code').wait_until_present.set(mfa_token)
            browser_obj.button(id: 'btnCodeSubmit').wait_until_present.click
            sleep 3
          end
          print "\n"
        end

        return browser_obj
      rescue => e
        raise e
      end

      # Supported Method Parameters::
      # browser_obj = CSI::WWW::Paypal.logout(
      #   browser_obj: 'required - browser_obj returned from #open method'
      # )

      public

      def self.logout(opts = {})
        browser_obj = opts[:browser_obj]
        browser_obj.link(index: 13).wait_until_present.click

        return browser_obj
      rescue => e
        raise e
      end

      # Supported Method Parameters::
      # browser_obj = CSI::WWW::Paypal.close(
      #   browser_obj: 'required - browser_obj returned from #open method'
      # )

      public

      def self.close(opts = {})
        browser_obj = opts[:browser_obj]
        browser_obj = CSI::Plugins::TransparentBrowser.close(browser_obj: browser_obj)
      rescue => e
        raise e
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
        puts %{USAGE:
          browser_obj = #{self}.open(
            browser_type: 'optional - :firefox|:chrome|:ie|:headless (Defaults to :firefox)',
            proxy: 'optional - http(s)://proxy_host:port',
            with_tor: 'optional - boolean (defaults to false)'
          )
          puts "browser_obj.public_methods"

          browser_obj = #{self}.login(
            browser_obj: 'required - browser_obj returned from #open method',
            username: 'required - username',
            password: 'optional - passwd (will prompt if blank),
            mfa: 'optional - if true prompt for mfa token (defaults to false)'
          )

          browser_obj = #{self}.logout(
            browser_obj: 'required - browser_obj returned from #open method'
          )

          #{self}.close(
            browser_obj: 'required - browser_obj returned from #open method'
          )

          #{self}.authors
        }
      end
    end
  end
end