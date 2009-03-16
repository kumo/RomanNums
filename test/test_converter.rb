require File.dirname(__FILE__) + '/test_helper'

require "Converter.bundle"
OSX::ns_import :Converter

class TestConverter < Test::Unit::TestCase
  include OSX
  def test_converter_class_exists
    Converter
  end
  
  def test_can_be_reset
    converter = Converter.alloc.init
    
    converter.convertToArabic("")
    
    assert_equal("0", converter.arabicResult)
  end
end