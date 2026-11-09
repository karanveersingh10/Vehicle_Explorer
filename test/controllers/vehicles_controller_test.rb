require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vehicles_url
    assert_response :success
  end

  test "should get show" do
    vehicle = vehicles(:one)
    get vehicle_url(vehicle)
    assert_response :success
  end
end
