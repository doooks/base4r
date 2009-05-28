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

require 'rexml/document'

module Base4R

  # Item describes a single entry that will be or is already stored in Google Base
  class Item

    # array of Attribute objects that describe the Item
    attr_accessor :attributes
    
    # Name of the creator of the Item
    attr_accessor :author_name
    
    # Email of the creator of the Item
    attr_accessor :author_email
    
    # Title of the Item
    attr_accessor :title

    # ID of this Item as assigned by Google
    attr_accessor :base_id

    # unique alphnumeric identifier for the item - e.g. your internal ID code. 
    # IMPORTANT: Once you submit an item with a unique id, this identifier must 
    # not change when you send in a new data feed. Each item must retain the same 
    # id in subsequent feeds.
    attr_accessor :unique_id

    # Represents this Item as Atom XML which is the format required by the Base API. 
    def to_xml
      
      doc = REXML::Document.new('<?xml version="1.0" ?>')

      entry = doc.add_element('entry', {
                                'xmlns'=>'http://www.w3.org/2005/Atom', 
                                'xmlns:g' => 'http://base.google.com/ns/1.0'
                              })
      
      author = entry.add_element('author')
      author.add_element('name').text= @author_name
      author.add_element('email').text= @author_email

      entry.add_element('category',
                        {'scheme'=>'http://www.google.com/type',
                         'term' => 'googlebase.item'
                        }
                       )

      entry.add_element('title').text= @title
      
      @attributes.each do |attr|
        attr.to_xml(entry)
      end

      doc
    end

  end

  #
  # Item with a minimal set of Attributes, extend for specific Item Types
  # 
  #
  class UniversalItem < Item

    # Create a new UniversalItem, with _unique_id_, created by _author_name_ who's email is _author_email_, 
    # described by _description_, found at URL _link_, entitled _title_, phone number is 
    # _contact_phone_, item type is _item_type_, _target_country_ e.g. 'GB', _item_language_ e.g. 'EN' 
    def initialize(unique_id, author_name, author_email, description, link, 
                   title, contact_phone, item_type, target_country, item_lang)
     
      @author_name  = author_name
      @author_email = author_email
      @title = title
      
      @attributes = []

      @attributes << UrlAttribute.new('link', link, :atom)
      @attributes << TextAttribute.new('content', description, :atom)
      @attributes << TextAttribute.new('contact_phone', contact_phone, :g)
      @attributes << TextAttribute.new('item_language', item_lang, :g)
      @attributes << TextAttribute.new('item_type', item_type, :g)
      @attributes << TextAttribute.new('target_country', target_country, :g)
      @attributes << TextAttribute.new('id', unique_id, :g)
    end

    def application=(application)
      @attributes << TextAttribute.new('application', application, :g)
    end
    
    def expiration_date=(expires)
      @attributes << DateTimeAttribute.new('expiration_date', expires, :g)
    end

    def add_image_link(image_url)
      @attributes << BareAttribute.new('image_link', image_url)
    end

    def add_label(label)
      @attributes << TextAttribute.new('label', label, :g)
    end


  end

  # ProductItem is a standard item type. This class includes some of the attributes that are
  # suggested or required for the Product item type.
  #
  class ProductItem < UniversalItem

    def initialize(unique_id, author_name, author_email, description, link, 
                   title, contact_phone, item_type, target_country, item_lang)

      super(unique_id, author_name, author_email, description, link,
            title, contact_phone, item_type, target_country, item_lang)
      
    end
   

    def condition=(condition)
      @attributes << TextAttribute.new('condition', condition, :g)
    end

    def delivery=(will_deliver)

      @attributes << BooleanAttribute.new('delivery', will_deliver.to_s, :g)
    end

    def delivery_notes=(notes)
      
      @attributes << TextAttribute.new('delivery_notes', notes, :g)
    end

    def department=(department)
      
      @attributes << TextAttribute.new('department', department, :g)
    end

    def add_payment=(payment)
      
      @attributes << TextAttribute.new('payment', payment, :g)
    end

    def payment_notes=(notes)
      
      @attributes << TextAttribute.new('payment_notes', notes, :g)
    end

    def pickup=(pickup)
      
      @attributes << BooleanAttribute.new('pickup', false, :g)
    end

    def price(price_amount, price_units)
      
      @attributes << FloatUnitAttribute.new('price', price_amount, price_units, :g)
    end

    def price_type=(price_type)
      
      @attributes << TextAttribute.new('price_type', price_type, :g)
    end

    def price_units=(price_units)
      
      @attributes << TextAttribute.new('price_units', price_units, :g)
    end

    def location=(loc)

      @attributes << LocationAttribute.new('location', loc)
    end

    def product_type=(prod_type)
      
      @attributes << TextAttribute.new('product_type', prod_type, :g)
    end

    def add_custom(name, value)

      if name.downcase == 'quantity' then
        @attributes << IntAttribute.new('Quantity', value, :g)
        return
      end

      self.add_custom_text(name, value)
    end
    

    def add_custom_text(name, value)

      @attributes << TextAttribute.new(name, value, :g)
    end


  end
  
end
