require File.dirname(__FILE__) + '/test_helper'

require "Converter.bundle"
OSX::ns_import :Converter

class TestConverter < Test::Unit::TestCase
  include OSX
  def test_converter_class_exists
    Converter
  end
  
  def test_can_accept_empty_strings
    converter = Converter.alloc.init
    
    assert_equal("", converter.performConversionToArabic(""))

    assert_equal("", converter.performConversionToRoman(""))
  end
  
  def test_icon_conversion
    converter = Converter.alloc.init
    
    assert_equal("1925", converter.performConversionToArabic("MCMXXV"))

    assert_equal("MCMXXV", converter.performConversionToRoman("1925"))
  end
  
  def test_old_conversion
    converter = Converter.alloc.init
    
    assert_equal("CIↃ IↃ CCCCXXV", converter.performOldConversionToRoman("1925"))
  end
  
  def test_largest_simple_number
    converter = Converter.alloc.init

    assert_equal("MMMMCMXCIX", converter.performConversionToRoman("4999"))

    assert_equal("4999", converter.performConversionToArabic("MMMMCMXCIX"))
  end
  
  def test_large_numbers # http://home.att.net/~numericana/answer/roman.htm
    converter = Converter.alloc.init
    
    assert_equal("CCIↃↃ IↃↃ MMMXXXIV", converter.performOldConversionToRoman("18034"))
  end
  
  def test_pietro_bongo # http://www2.inetdirect.net/~charta/Roman_numerals.html
    converter = Converter.alloc.init

    assert_equal("CIↃ CIↃ CIↃ", converter.performOldConversionToRoman("3000"))

    assert_equal("CIↃ IↃↃ", converter.performOldConversionToRoman("4000"))

    assert_equal("IↃↃ", converter.performOldConversionToRoman("5000"))

    assert_equal("IↃↃ CIↃ", converter.performOldConversionToRoman("6000"))
    
    assert_equal("IↃↃ CIↃ CIↃ", converter.performOldConversionToRoman("7000"))
    
    assert_equal("CIↃ CIↃ CCIↃↃ", converter.performOldConversionToRoman("8000"))
  end
  
  def test_german_wikipedia
    converter = Converter.alloc.init
    
    assert_equal("CIↃ", converter.performOldConversionToRoman("1000"))

    assert_equal("CIↃ IↃ CXXXII", converter.performOldConversionToRoman("1632"))

    assert_equal("CIↃ C CIↃ LXXXIV", converter.performOldConversionToRoman("1984"))
    
    assert_equal("CIↃ CIↃ", converter.performOldConversionToRoman("2000"))

    assert_equal("IↃↃↃ CCIↃↃ IↃↃ CDXXXII", converter.performOldConversionToRoman("65432"))
  end
  
  def test_descartes
    converter = Converter.alloc.init
    
    assert_equal("CIↃ IↃ CLXI", converter.performOldConversionToRoman("1661"))
  end
  
  def test_unicode
    converter = Converter.alloc.init

    #assert_equal("ↀ", converter.performOldConversionToRoman("1000"))

    #assert_equal("ↁ", converter.performOldConversionToRoman("5000"))

    #assert_equal("ↂ", converter.performOldConversionToRoman("10000"))
  end
end