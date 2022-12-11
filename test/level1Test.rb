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
    expected = 'Error Message 1 : Formula is not appropriate'
    assert_equal expected, actual
  end

  def test_level1_abnormal2
    #異常系テスト
    #数式の先頭が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '+40/2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = 'Error Message 1 : Formula is not appropriate'
    assert_equal expected, actual
  end

  def test_level1_abnormal2
    #異常系テスト
    #数式の先頭が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '40/2+2*4-24/3*2*'
    actual = @calc.calc_main(formula)
    expected = 'Error Message 1 : Formula is not appropriate'
    assert_equal expected, actual
  end

  def test_level1_abnormal3
    #異常系テスト
    #数式内で演算子が連続した場合、エラーメッセージを返すこと。
    setup
    formula = '40/*2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = 'Error Message 1 : Formula is not appropriate'
    assert_equal expected, actual
  end

end