require 'minitest/autorun'
require_relative '../calc/level2.rb'

class Test < Minitest::Test
  def setup
    @calc = Calc.new
  end

  def test_level2_normal1
    #正常系テスト
    #正しく数式が入力された時、適切な計算結果が返ってくること。
    setup
    formula = '40/2+2*4-24/3*2+2E2+0.1'
    actual = @calc.calc_main(formula)
    expected = 212.1
    assert_equal expected, actual
  end

  def test_level2_abnormal1
    #異常系テスト
    #数式内に不適切な文字が含まれていた場合、エラーメッセージを返すこと。
    setup
    formula = '40a2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.'以外の文字が含まれているか、先頭、末尾に数字以外の文字が入力されています"
    assert_equal expected, actual
  end

  def test_level2_abnormal2
    #異常系テスト
    #数式の先頭が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '+40/2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.'以外の文字が含まれているか、先頭、末尾に数字以外の文字が入力されています"
    assert_equal expected, actual
  end

  def test_level2_abnormal3
    #異常系テスト
    #数式の末尾が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '40/2+2*4-24/3*2*'
    actual = @calc.calc_main(formula)
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.'以外の文字が含まれているか、先頭、末尾に数字以外の文字が入力されています"
    assert_equal expected, actual
  end

  def test_level1_abnormal4
    #異常系テスト
    #数式内で演算子が連続した場合、エラーメッセージを返すこと。
    setup
    formula = '40/*2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected =  "Error Message 2 : 数式内で'+','-','*','/','E','.'が連続して入力されています"
    assert_equal expected, actual
  end

  def test_level1_abnormal5
    #異常系テスト
    #演算子間に"."が2回以上含まれていた場合、エラーメッセージを返すこと。
    setup
    formula = '40*2+2*4-24/3*2+1.1.1'
    actual = @calc.calc_main(formula)
    expected =  "Error Message 3 : 演算子間に'.'が2回以上入力されています"
    assert_equal expected, actual
  end

end