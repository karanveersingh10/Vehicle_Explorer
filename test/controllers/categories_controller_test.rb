require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get categories_url
    assert_response :success
  end

  test "should get show" do
    category = categories(:one)
    get category_url(category)
    assert_response :success
  end
end
