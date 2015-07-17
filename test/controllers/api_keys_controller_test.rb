require 'test_helper'

class ApiKeysControllerTest < ActionController::TestCase
  setup do
    @api_key = api_keys(:one)
  end

  test "post without secret must fail" do
    post :registerAccount
    assert_response :bad_request
  end
  
  test "post with bad secret must fail" do
    post :registerAccount, { paymentIdentifier: "andfajds", secret:"adfasdf"}
    assert_response :forbidden
  end
  
  test "post without paymentIdentifier: must fail" do
    post :registerAccount, { secret:"adfasdf"}
    assert_response :bad_request
  end
  
  test "register good account must return api_key" do
    post :registerAccount, { paymentIdentifier: "andfajds", secret:ENV['LISHOP_API_SECRET']}
    object = JSON.parse(@response.body)
    assert_not_nil object, "There was no response"
    assert_not_nil object['api_key'], "Response has no api_key"
    assert_equal 32, object['api_key'].length, "The size of the api_key is incorrect"
    assert_response :ok
  end
  
end
