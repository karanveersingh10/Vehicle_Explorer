require "test_helper"

class MakesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get makes_url
    assert_response :success
  end

  test "should get show" do
    make = makes(:one)
    get make_url(make)
    assert_response :success
  end
end
