require "test_helper"

class MarketingControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get marketing_home_url
    assert_response :success
  end

  test "should get about" do
    get marketing_about_url
    assert_response :success
  end

  test "should get how_it_works" do
    get marketing_how_it_works_url
    assert_response :success
  end

  test "should get features" do
    get marketing_features_url
    assert_response :success
  end

  test "should get pricing" do
    get marketing_pricing_url
    assert_response :success
  end

  test "should get contact" do
    get marketing_contact_url
    assert_response :success
  end

  test "should get security" do
    get marketing_security_url
    assert_response :success
  end
end
