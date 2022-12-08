require 'minitest/autorun'
require_relative '../calc/level1.rb'

class Test < Minitest::Test
  def setup
    @calc = Calc.new
  end

  def test_level1
    setup
    formula = '40/2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = 12
    assert_equal expected, actual

    setup
    formula = '40a2+2*4-24/3*2'
    actual = @calc.calc_main(formula)
    expected = 'Error Message 1 : Formula is not appropriate'
    assert_equal expected, actual

  end
end