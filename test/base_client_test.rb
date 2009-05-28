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
# tests for BaseClient
#

require 'test/unit'
require 'base_client'
require 'net/http'
require 'test/test_config'

module Base4R

  class BaseClientTest < Test::Unit::TestCase #:nodoc:

    def setup      

      @username = TEST_CONFIG[:username]
      @password = TEST_CONFIG[:password]
      @api_key  = TEST_CONFIG[:api_key]
      
      @base_client = Base4R::BaseClient.new(@username, @password, @api_key, false)

      @item = UniversalItem.new('TEST123',
                                'base4r test author',
                               'base4r@example.com',
                               'This description describes a new item',
                               'http://example.com/items/dir/34545.html',
                               'Title of a new item',
                               '0114 1111111',
                               'products',
                                'GB',
                                'EN')

    end

    def teardown
    end

    def test_feed_path

      assert_equal '/base/feeds/items/', @base_client.feed_path     
      another_client = BaseClient.new(@username, @password, @api_key)
      assert_equal '/base/feeds/snippets/', another_client.feed_path
    end

    def test_update_item

      base_id = @base_client.create_item(@item)
      assert base_id.kind_of?(String)
      @item.add_label('updated_label')
      assert @base_client.update_item(@item)
    end

    def test_post_simple_item
      
      base_id = @base_client.create_item(@item)
      assert base_id.kind_of?(String)
    end

     def test_delete_item
       
       assert @base_client.create_item(@item)
       assert @base_client.delete_item(@item)
     end

    # sanity test to assert the network is up
    def test_getter

      resp = Net::HTTP.get_response('www.google.com', '/base/feeds/itemtypes/en_GB/jobs')   
      assert resp.kind_of?(Net::HTTPOK)
    end


  end

end

