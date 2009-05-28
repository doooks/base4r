# Base4R is a ruby interface to Google Base
# Copyright 2007, 2008 Dan Dukeson

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

#
# Authenticates the user with google ClientLogin
#
#
require 'net/https'

module Base4R

  #
  # ClientLogin authenticates the user with Google Accounts using the ClientLogin service.
  #
  class ClientLogin

    ServiceURL = URI.parse('https://www.google.com/accounts/ClientLogin')

    # Create a ClientLogin. _options_ is optional and by default logs into
    # the Google Base API.
    def initialize(options={})

      defaults = {:accountType => 'GOOGLE',
                  :service => 'gbase',
                  :source => 'base4r-clientloginapp-v1'}

       @config = defaults.merge(options)
    end

    # attempt to authenticate _email_ and _password_ with Google.
    # Returns an authentication token on success, raises Exception on failure.
    # todo: make exception handling more useful
    def authenticate(email, password)

      params = {
        'accountType' => @config[:accountType],
        'Email' => email,
        'Passwd' => password,
        'service' => @config[:service],
        'source' => @config[:source]
      }
      
      req = Net::HTTP::Post.new(ServiceURL.path)
      req.set_form_data(params)

      http = Net::HTTP.new(ServiceURL.host, 443)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.ca_file = File.expand_path(File.dirname(__FILE__)+"/../cert/cacert.pem")

      # todo - above is probably reading file for every request, cache certs instead

      resp = http.request(req)
            
      unless resp.instance_of? Net::HTTPOK then
        resp.body =~ /^Error=(.+)$/

        raise CaptchaRequiredException.new(email) if 'CaptchaRequired' == $1        
        raise 'unknown exception authenticating with google:'+$1
      end

      # parse the auth key from the body
      resp.body =~ /^Auth=(.+)$/
      return $1

    end
  end

  # thrown when ClientLogin fails to authenticate because the ClientLogin API has 
  # requested that the user complete a captcha validation. 
  class CaptchaRequiredException < Exception
    
    attr_reader :email
    
    # Create a CaptchaRequiredException to notify the user that _email_ must complete
    # a captcha validation
    def initialize(email)
      @email = email
    end
  end

end
