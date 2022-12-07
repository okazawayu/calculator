require 'minitest/autorun'
 
class SampleMinitestTest < Minitest::Test
  def test_case
    assert_equal 'rightcode', 'rightcode'.upcase
    assert_equal 'rightcode', 'rightcode'.downcase
    assert_equal 'Rightcode', 'rightcode'.capitalize
  end
end