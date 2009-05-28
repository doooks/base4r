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
# tests for Attribute and subclasses
#
require 'test/unit'
require 'attribute'

module Base4R
  
  class AttributeTest < Test::Unit::TestCase #:nodoc:

    def setup
      
      @text_attr = TextAttribute.new('testname', 'testvalue', :g)
      @url_attr = UrlAttribute.new('testname', 'testvalue', :g)
      @date_time_attr = DateTimeAttribute.new('testname', 'testvalue', :g)
      @int_attr = IntAttribute.new('testname', 'testvalue', :g)

    end
    
    def test_type_names
      assert_equal 'text', @text_attr.type_name
      assert_equal 'url', @url_attr.type_name
      assert_equal 'dateTime', @date_time_attr.type_name
      assert_equal 'int', @int_attr.type_name
    end

    def test_accessors

      @text_attr.name = 'foo'
      @text_attr.value = 'bar'
      @text_attr.type_name = 'text'
      @text_attr.namespace = :atom
      
      assert_equal 'foo', @text_attr.name
      assert_equal 'bar', @text_attr.value
      assert_equal 'text',@text_attr.type_name
      assert_equal :atom, @text_attr.namespace
    end

  end

end
