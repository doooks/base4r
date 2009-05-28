#
# tests for Item and children
#

require 'test/unit'
require 'item'

module Base4R

  class ItemTest < Test::Unit::TestCase #:nodoc:

    def setup
      
      @item = UniversalItem.new('ABC123',
                                'Dan',
                                'dan@example.com',
                                'A wonderful item with many featureful benefits',
                                'http://example.com/greatstuff/item/goo',
                                'Beneficial Product',
                                '0114 1234567',
                                'generic item',
                                'GB',
                                'EN')

      @expiration_time = Time.now+7*60*60*24

      @item.application = 'base4r'
      @item.expiration_date = @expiration_time
      @item.add_image_link('http://example.com/images/big1.png')
      @item.add_image_link('http://example.com/images/big2.png')
      @item.add_label('big')
      @item.add_label('clever')
      @item.add_label('funny')

    end

    
    def test_attributes_present
      assert_equal 14, @item.attributes.size
    end

    def test_xml

      expected_xml = "<?xml version='1.0'?><entry xmlns:g='http://base.google.com/ns/1.0' xmlns='http://www.w3.org/2005/Atom'><author><name>Dan</name><email>dan@example.com</email></author><category term='googlebase.item' scheme='http://www.google.com/type'/><title>Beneficial Product</title><link href='http://example.com/greatstuff/item/goo' rel='alternate' type='text/html'/><content>A wonderful item with many featureful benefits</content><g:contact_phone type='text'>0114 1234567</g:contact_phone><g:item_language type='text'>EN</g:item_language><g:item_type type='text'>generic item</g:item_type><g:target_country type='text'>GB</g:target_country><g:id type='text'>ABC123</g:id><g:application type='text'>base4r</g:application><g:expiration_date type='dateTime'>#{@expiration_time}</g:expiration_date><g:image_link>http://example.com/images/big1.png</g:image_link><g:image_link>http://example.com/images/big2.png</g:image_link><g:label type='text'>big</g:label><g:label type='text'>clever</g:label><g:label type='text'>funny</g:label></entry>"
      actual_xml = ""
      @item.to_xml.write(actual_xml)
      self.assert_equal expected_xml, actual_xml 
      
    end    
  end
end
