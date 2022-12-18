require 'minitest/autorun'
require_relative '../calc/level1.rb'

class Test < Minitest::Test
  def setup
    @calc = Calc.new
  end

  def test_level1_normal1
    #正常系テスト
    #正しく数式が入力された時、適切な計算結果が返ってくること。
    setup
    formula = '40/2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = 12
    assert_equal expected, actual
  end

  def test_level1_abnormal1
    #異常系テスト
    #数式内に不適切な文字が含まれていた場合、エラーメッセージを返すこと。
    setup
    formula = '40a2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/'以外の文字が含まれているか、先頭、末尾に数字以外の文字が入力されています"
    assert_equal expected, actual
  end

  def test_level1_abnormal2
    #異常系テスト
    #数式の先頭が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '+40/2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/'以外の文字が含まれているか、先頭、末尾に数字以外の文字が入力されています"
    assert_equal expected, actual
  end

  def test_level1_abnormal3
    #異常系テスト
    #数式の末尾が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '40/2+2*4-24/3*2*'
    actual = @calc.calc_main(formula)
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/'以外の文字が含まれているか、先頭、末尾に数字以外の文字が入力されています"
    assert_equal expected, actual
  end

  def test_level1_abnormal4
    #異常系テスト
    #数式内で演算子が連続した場合、エラーメッセージを返すこと。
    setup
    formula = '40/*2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 2 : 数式内で'+','-','*','/'が連続して入力されています"
    assert_equal expected, actual
  end

end