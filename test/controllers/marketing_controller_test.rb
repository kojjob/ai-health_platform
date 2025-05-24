require "test_helper"

class MarketingControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_response :success
  end

  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get how_it_works" do
    get how_it_works_url
    assert_response :success
  end

  test "should get features" do
    get features_url
    assert_response :success
  end

  test "should get pricing" do
    get pricing_url
    assert_response :success
  end

  test "should get contact" do
    get contact_url
    assert_response :success
  end

  test "should get security" do
    get security_url
    assert_response :success
  end
end
