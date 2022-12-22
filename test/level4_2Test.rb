require 'minitest/autorun'
require_relative '../calc/level4_2.rb'

class Test < Minitest::Test
  def setup
    @calc = Calc.new
  end

  def test_level4_normal1
    #正常系テスト
    #正しく数式が入力された時、適切な計算結果が返ってくること。
    setup
    formula = '2*((3+2)*2)+cbrt(64)+(-2*-2.5)'
    actual = @calc.calc_main(formula)
    expected = 29
    assert_equal expected, actual
  end

  def test_level4_abnormal1
    #異常系テスト
    #数式内に不適切な文字が含まれていた場合、エラーメッセージを返すこと。
    setup
    formula = '40a2+2*4-24/3*2'
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.','cbrt'以外の文字が含まれているか、先頭、末尾に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  
  end
  def test_level4_abnormal2
    #異常系テスト
    #数式の先頭が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '+40/2+2*4-24/3*2'
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.','cbrt'以外の文字が含まれているか、先頭、末尾に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  end
  def test_level4_abnormal3
    #異常系テスト
    #数式の末尾が数字以外であった場合、エラーメッセージを返すこと。
    setup
    formula = '40/2+2*4-24/3*2*'
    expected = "Error Message 1 : 数式に[0-9],'+','-','*','/','E','.','cbrt'以外の文字が含まれているか、先頭、末尾に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  
  end
  def test_level4_abnormal4
    #異常系テスト
    #数式内で演算子が連続した場合、エラーメッセージを返すこと。
    setup
    formula = '40/*2+2*4-24/3*2'
    expected = "Error Message 2 : 数式内で'+','-','*','/','E','.'が連続して入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end 
  end
  def test_level4_abnormal5
    #異常系テスト
    #演算子間に"."が2回以上含まれていた場合、エラーメッセージを返すこと。
    setup
    formula = '40*2+2*4-24/3*2+1.1.1'
    expected = "Error Message 3 : 演算子間に'.'が2回以上入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  
  end
  def test_level4_abnormal6
    #異常系テスト
    #数式を左から確認し、")"の個数が"("を超過した場合、エラーメッセージを返すこと。
    setup
    formula = '40/2+2*4-24/3*2+2E2+0.1+2*(3+2))*(2'
    expected = "Error Message 4 : 数式の途中で')'の個数が'('を超過しています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  
  end
  def test_level4_abnormal7
    #異常系テスト
    #")"の個数と"("の個数が異なっていた場合、エラーメッセージを返すこと。
    setup
    formula = '40/2+2*4-24/3*2+2E2+0.1+2*(3+2)*(2'
    expected = "Error Message 5 : ')'の個数と'('の個数が異なります"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  end
  def test_level4_abnormal8
    #異常系テスト
    #"("の前が数字の場合、エラーメッセージを返すこと。
    setup
    formula = '3*3(2+1)'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  
  end
  def test_level4_abnormal9
    #異常系テスト
    #"("の前が")"の場合、エラーメッセージを返すこと
    setup
    formula = '3*((2+1)(2+1))'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  
  end
  def test_level4_abnormal10
    #異常系テスト
    #"("の前が"."の場合、エラーメッセージを返すこと
    setup
    formula = '3*2.(2+1)'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  
  end
  def test_level4_abnormal11
    #異常系テスト
    #"("の後ろが演算子の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(+2+1)'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  end
  def test_level4_abnormal12
    #異常系テスト
    #"("の後ろが")"の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(()2+1)'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  end
  def test_level4_abnormal13
    #異常系テスト
    #"("の後ろが"."の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(.2+1)'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  end
  def test_level4_abnormal14
    #異常系テスト
    #"("の後ろが"E"の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(E2+1)'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  end
  def test_level4_abnormal15
    #異常系テスト
    #")"の前が演算子の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1*)'
    
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end
  end
  def test_level4_abnormal16
    #異常系テスト
    #")"の前が"E"の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1E)'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end
  end
  def test_level4_abnormal17
    #異常系テスト
    #")"の前が"."の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1.)'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end
  end
  def test_level4_abnormal18
    #異常系テスト
    #")"の後ろが数字の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1)2'
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end
  end
  def test_level4_abnormal19
    #異常系テスト
    #")"の後ろが"."の場合、エラーメッセージを返すこと。
    setup
    formula = '3*(2+1).2'
    
    expected = "Error Message 6 : ')'もしくは'('の前後に不適切な文字が入力されています"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end
  end

  def test_level4_abnormal20
    #異常系テスト
    #cbrt(x)の前が数字の場合エラーを返す
    setup
    formula = '3*(2+1)*3cbrt(8)'
    expected = "Error Message 7 : cbrt関数の形式が異なります"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end  
  end
  def test_level4_abnormal21
    #異常系テスト
    #cbrt(x)の前が")"の場合エラーを返す
    setup
    formula = '3*(2+1)cbrt(8)'
    expected = "Error Message 7 : cbrt関数の形式が異なります"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end
  end
  def test_level4_abnormal22
    #異常系テスト
    #cbrt(x)の前が"."の場合エラーを返す
    setup
    formula = '3*(2+1)+3.cbrt(8)'
    expected = "Error Message 7 : cbrt関数の形式が異なります"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end
  end
  def test_level4_abnormal23
    #異常系テスト
    #cbrt(x)の変数が負の場合エラーを返す
    setup
    formula = '3*(2+1)+cbrt(2-10)'
    expected = "Error Message 8 : cbrt関数の変数が負の値です"
    assert_raises(StandardError, expected) do
      @calc.calc_main(formula)
    end
  end
end