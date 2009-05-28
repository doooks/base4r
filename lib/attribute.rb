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
# following taken from http://code.google.com/apis/base/starting-out.html
# 
# There are some limitations on how long your attribute names and values can be and how many you can use:

#     * titles: between 3-1000 characters
#     * attributes:
#           o names: 30 characters
#           o attribute text: 1000 characters, including spaces
#           o total number permitted: 30 per item
#     * labels:
#           o names: 40 characters
#           o total number permitted: 10 per item
#     * URL length: 1000

module Base4R

  # Attributes are typed key-value pairs that describe content. Attributes describe the
  # Base Item. Client code should use subclasses of Attribute such as TextAttribute, 
  # BareAttribute, DateTimeAttribute, IntAttribute, FloatUnitAttribute, UrlAttribute, 
  # LocationAttribute, BooleanAttribute. 
  # Each of these can represent themselves as required by the Atom format.
  class Attribute

    attr_accessor :name
    attr_accessor :value
    attr_accessor :type_name
    attr_accessor :namespace
    
    # Represent this Attribute as an XML element that is a child of _parent_.
    def to_xml(parent)

      el = parent.add_element(calc_el_name())

      if @namespace == :g then
        el.add_attribute('type', @type_name)
      end
      el.text=@value
    end
    
    protected

    def initialize(name, value, namespace)
      @name = name
      @value = value
      @namespace = namespace
    end

    def calc_el_name
      if @namespace == :g then
        el_name = 'g:'+@name
      else 
        el_name = @name
      end
      el_name
    end
 
 end

  # TextAttribute is a simple string.
  class TextAttribute < Attribute
    
    # Create a TextAttribute with _name_, _value_ and in _namespace_
    def initialize(name, value, namespace)
      @type_name = 'text'
      super(name, value, namespace)
    end
  end

  # BareAttribute is a string attribute but is in the google namespace
  class BareAttribute < Attribute
    
    # Create a BareAttribute with _name_ and _value_
    def initialize(name, value)
      super(name, value, :g)
    end
    
    def to_xml(parent)
      el = parent.add_element('g:'+name).text=value
    end
  end

  # UrlAttribute represents a URL
  class UrlAttribute < Attribute
    
    # Create a UrlAttribute with _name_, _value_ and _namespace_
    def initialize(name, value, namespace)
      @type_name = 'url'
      super(name, value, namespace)
    end
    
    def to_xml(parent)
     
      urlel = parent.add_element(calc_el_name())
      urlel.add_attribute('rel', 'alternate')
      urlel.add_attribute('type', 'text/html')
      urlel.add_attribute('href', @value)
    end

  end

  # DateTimeAttribute represents a DateTime
  class DateTimeAttribute < Attribute

    def initialize(name, value, namespace)
      @type_name = 'dateTime'
      super(name, value, namespace)
    end
  end

  # IntAttribute represents an Integer
  class IntAttribute < Attribute

    def initialize(name, value, namespace)
      @type_name = 'int'
      super(name, value, namespace)
    end
  end

  # BooleanAttribute represents a Boolean
  class BooleanAttribute < Attribute

    def initialize(name, value, namespace)
      @type_name = 'boolean'
      super(name, value, namespace)
    end
  end

  # FloatUnitAttribute represents a floating-point property with units.
  class FloatUnitAttribute < Attribute

    # Create a FloatUnitAttribute with _name_, a quantity of _number_, described in _units_ and in _namespace_ 
    def initialize(name, number, units, namespace)
      @type_name = 'floatUnit'
      super(name, number.to_s+' '+units, namespace)
    end
  end

  # LocationAttribute represents an Item's location
  class LocationAttribute < Attribute

    # Create a LocationAttribute with _name_ and in _location_
    def initialize(name, location)
      @type_name = 'location'
      super(name, location, :g)
    end
  end
  
end
