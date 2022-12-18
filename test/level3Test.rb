require 'minitest/autorun'
require_relative '../calc/level3.rb'

class Test < Minitest::Test
  def setup
    @calc = Calc.new
  end

  def test_level3_normal1
    #正常系テスト
    #正しく数式が入力された時、適切な計算結果が返ってくること。
    setup
    formula = '40/2+2*4-24/3*2+2E2+0.1+2*((3+2)*2)'
    actual = @calc.calc_main(formula)
    expected = 232.1
    assert_equal expected, actual
  end

  def test_level3_abnormal1
    #異常系テスト
    #数式内に不適切な文字が含まれていた場合、エラーメッセージを返すこと。
    setup
    formula = '40a2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.'以外の文字が含まれているか、先頭、末尾に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level3_abnormal2
    #異常系テスト
    #数式の先頭が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '+40/2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.'以外の文字が含まれているか、先頭、末尾に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level3_abnormal3
    #異常系テスト
    #数式の末尾が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '40/2+2*4-24/3*2*'
    actual = @calc.calc_main(formula)
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.'以外の文字が含まれているか、先頭、末尾に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal4
    #異常系テスト
    #数式内で演算子が連続した場合、エラーメッセージを返すこと。
    setup
    formula = '40/*2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 2 : 数式内で'+','-','*','/','E','.'が連続して入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal5
    #異常系テスト
    #演算子間に"."が2回以上含まれていた場合、エラーメッセージを返すこと。
    setup
    formula = '40*2+2*4-24/3*2+1.1.1'
    actual = @calc.calc_main(formula)
    expected = "Error Message 3 : 演算子間に'.'が2回以上入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal6
    #異常系テスト
    #数式を左から確認し、")"の個数が"("を超過した場合、エラーメッセージを返すこと。
    setup
    formula = '40/2+2*4-24/3*2+2E2+0.1+2*(3+2))*(2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 4 : 数式の途中で')'の個数が'('を超過しています"
    assert_equal expected, actual
  end
  def test_level1_abnormal7
    #異常系テスト
    #")"の個数と"("の個数が異なっていた場合、エラーメッセージを返すこと。
    setup
    formula = '40/2+2*4-24/3*2+2E2+0.1+2*(3+2)*(2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 5 : ')'の個数と'('の個数が異なります"
    assert_equal expected, actual
  end
  def test_level1_abnormal8
    #異常系テスト
    #"("の前が数字の場合、エラーメッセージを返すこと。
    setup
    formula = '3*3(2+1)'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal9
    #異常系テスト
    #"("の前が")"の場合、エラーメッセージを返すこと
    setup
    formula = '3*((2+1)(2+1))'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal10
    #異常系テスト
    #"("の前が"."の場合、エラーメッセージを返すこと
    setup
    formula = '3*2.(2+1)'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal11
    #異常系テスト
    #"("の後ろが演算子の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(+2+1)'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal12
    #異常系テスト
    #"("の後ろが")"の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(()2+1)'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal13
    #異常系テスト
    #"("の後ろが"."の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(.2+1)'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal14
    #異常系テスト
    #"("の後ろが"E"の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(E2+1)'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal15
    #異常系テスト
    #")"の前が演算子の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1*)'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal16
    #異常系テスト
    #")"の前が"E"の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1E)'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal17
    #異常系テスト
    #")"の前が"."の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1.)'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal18
    #異常系テスト
    #")"の後ろが数字の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1)2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
  def test_level1_abnormal19
    #異常系テスト
    #")"の後ろが"."の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1).2'
    actual = @calc.calc_main(formula)
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_equal expected, actual
  end
end