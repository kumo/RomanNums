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
    
    assert_equal("0", converter.performConversionToArabic(""))

    assert_equal("", converter.performConversionToRoman(""))
  end
  
  def test_icon_conversion
    converter = Converter.alloc.init
    
    assert_equal("1925", converter.performConversionToArabic("MCMXXV"))

    assert_equal("MCMXXV", converter.performConversionToRoman("1925"))
  end
  
  def test_old_conversion
    converter = Converter.alloc.init
    
    assert_equal("(I) I) CCCCXXV", converter.performOldConversionToRoman("1925"))
  end
  
  def test_largest_simple_number
    converter = Converter.alloc.init

    assert_equal("MMMMCMXCIX", converter.performConversionToRoman("4999"))

    assert_equal("4999", converter.performConversionToArabic("MMMMCMXCIX"))
  end
  
  def test_large_numbers
    converter = Converter.alloc.init
    
    assert_equal("((I)) I)) MMMXXXIV", converter.performOldConversionToRoman("18034"))
  end
  
  def test_pietro_bongo # http://www2.inetdirect.net/~charta/Roman_numerals.html
    converter = Converter.alloc.init

    assert_equal("(I) (I) (I)", converter.performOldConversionToRoman("3000"))

    assert_equal("(I) I))", converter.performOldConversionToRoman("4000"))

    assert_equal("I))", converter.performOldConversionToRoman("5000"))

    assert_equal("I)) (I)", converter.performOldConversionToRoman("6000"))
    
    assert_equal("I)) (I) (I)", converter.performOldConversionToRoman("7000"))
    
    assert_equal("(I) (I) ((I))", converter.performOldConversionToRoman("8000"))
  end
  
  def test_german_wikipedia
    converter = Converter.alloc.init
    
    assert_equal("(I)", converter.performOldConversionToRoman("1000"))

    assert_equal("(I) I) CXXXII", converter.performOldConversionToRoman("1632"))

    assert_equal("(I) C (I) LXXXIV", converter.performOldConversionToRoman("1984"))
    
    assert_equal("(I) (I)", converter.performOldConversionToRoman("2000"))

    assert_equal("I))) ((I)) I)) CDXXXII", converter.performOldConversionToRoman("65432"))
  end
  
  def test_descartes
    converter = Converter.alloc.init
    
    assert_equal("(I) I) CLXI", converter.performOldConversionToRoman("1661"))
  end
  
  def test_unicode
    converter = Converter.alloc.init

    #assert_equal("ↀ", converter.performOldConversionToRoman("1000"))

    #assert_equal("ↁ", converter.performOldConversionToRoman("5000"))

    #assert_equal("ↂ", converter.performOldConversionToRoman("10000"))
  end
end