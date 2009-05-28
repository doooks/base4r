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

require 'net/http'
require 'client_login'

module Base4R

  # BaseClient handles all communication with the Base API using HTTP
  class BaseClient

    ITEMS_PATH = '/base/feeds/items/'
    SNIPPETS_PATH = '/base/feeds/snippets/'    
    BASE_HOST = 'base.google.com'

    attr_reader :auth_key #:nodoc:
    attr_reader :feed_path #:nodoc:

    # Construct a BaseClient, which will make API requiest for the Base account
    # belonging to _username_, authenticating with _password_ and using _api_key_. 
    # Requests will be made against the public feed if _public_feed_ is true, which is the default.
    # The BaseClient can be used for a number of Base API requests.
    # 
    def initialize(username, password, api_key, public_feed=true)

      @auth_key = ClientLogin.new.authenticate(username, password)
      @api_key = api_key

      if public_feed then
        @feed_path = SNIPPETS_PATH
      else
        @feed_path = ITEMS_PATH
      end
    end

    # Creates the supplied _item_ as a new Base Item.
    # Throws an Exception if there is a problem creating _item_.
    #
    def create_item(item)
      
      resp = do_request(item.to_xml.to_s, 'POST')
      raise "Error creating base item:"+resp.body unless resp.kind_of? Net::HTTPCreated
      resp['location'] =~ /(\d+)$/
      item.base_id= $1
      $1
    end

    # Update the supplied Base _item_. Returns true on success.
    # Throws an Exception if there is a problem updating _item_.
    #
    def update_item(item)

      raise "base_id is required" if item.base_id.nil?
      resp = do_request(item.to_xml.to_s, 'PUT', item.base_id)
      raise "Error updating base item:"+resp.body unless resp.kind_of? Net::HTTPOK
      true
    end

    # Delete the supplied Base _item_. Returns true on success.
    # Throws an Exception if there is a problem deleting _item_
    #
    def delete_item(item)

      raise "base_id is required" if item.base_id.nil?
      resp = do_request(nil, 'DELETE', item.base_id)
      raise "Error deleting base item:"+resp.body unless resp.kind_of? Net::HTTPOK
      true
    end

    private

    def do_request(data, http_method, base_id=nil)

      url = 'http://'+BASE_HOST+@feed_path
      url << base_id unless base_id.nil?
      
      url = URI.parse(url)

      headers = {'X-Google-Key' => 'key='+@api_key,
                 'Authorization' => 'GoogleLogin auth='+@auth_key,
                 'Content-Type' => 'application/atom+xml'}

      result = Net::HTTP.start(url.host, url.port) { |http|
        http.send_request(http_method, url.path, data, headers)
      }
      
    end

  end 
end
