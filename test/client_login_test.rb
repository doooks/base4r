# Base4R is a ruby interface to Google Base
# Copyright 2007 Dan Dukeson

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
# tests for ClientLogin
#

require 'test/unit'
require 'client_login'
require 'test/test_config'

module Base4R

  class ClientTest < Test::Unit::TestCase #:nodoc:

    def setup

      @username = TEST_CONFIG[:username]
      @password = TEST_CONFIG[:password]
      @login = ClientLogin.new
    end

    def test_login_correct

      resp = @login.authenticate(@username, @password)      
      assert resp
    end

    def test_login_incorrect

      resp = @login.authenticate(@username, @password+'wrongpassword');
      assert resp.instance_of?(Net::HTTPForbidden)
      flunk
      
    rescue 
      assert true
    end

    def test_captcha_exception
      e = CaptchaRequiredException.new('test@example.com')
      assert_equal 'test@example.com', e.email
    end
    
  end
  
end
