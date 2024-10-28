require "test_helper"

class BalanceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get balance_index_url
    assert_response :success
  end

  test "should get show" do
    get balance_show_url
    assert_response :success
  end

  test "should get destroy" do
    get balance_destroy_url
    assert_response :success
  end
end
