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
    post :registerAccount, { paymentIdentifier: "andfajds", secret:"adfasdf", receipt: "ADAFSDFASDF"}
    assert_response :forbidden
  end
  
  test "post without paymentIdentifier must fail" do
    post :registerAccount, { secret:"adfasdf",receipt: "ADAFSDFASDF"}
    assert_response :bad_request
  end

  test "post without receipt must fail" do
    post :registerAccount, { paymentIdentifier: "andfajds", secret:"adfasdf"}
    assert_response :bad_request
  end
  
  test "register good account must return api_key" do
    assert_difference('List.count') do
      post :registerAccount, { paymentIdentifier: "andfajds", secret:ENV['LISHOP_API_SECRET'], receipt: "ADAFSDFASDF"}
    end
    object = JSON.parse(@response.body)
    assert_not_nil object, "There was no response"
    assert_not_nil object['api_key'], "Response has no api_key"
    assert_equal 32, object['api_key'].length, "The size of the api_key is incorrect"
    assert_response :ok
  end
  
  test "calling registerAccount two times must return two different api_keys, but must generate only one list" do
    pi = "andfajds"
    re = "ADAFSDFASDF"
    assert_difference('List.count') do
       post :registerAccount, { paymentIdentifier: pi, secret:ENV['LISHOP_API_SECRET'], receipt: re}
     end
    object = JSON.parse(@response.body)
    assert_not_nil object, "There was no response"
    first_api_key = object['api_key']
    assert_not_nil first_api_key, "Response has no api_key"
    assert_equal 32, object['api_key'].length, "The size of the api_key is incorrect"
    assert_response :ok
    
    assert_no_difference('List.count') do
      post :registerAccount, { paymentIdentifier: pi, secret:ENV['LISHOP_API_SECRET'], receipt: re}
    end
    object = JSON.parse(@response.body)
    assert_not_nil object, "There was no response"
    second_api_key = object['api_key']
    assert_not_nil first_api_key, "Response has no api_key"
    assert_not_equal first_api_key, second_api_key, "Recovering the accout must return a new api_key"
    assert_equal 32, object['api_key'].length, "The size of the api_key is incorrect"
    assert_response :ok
  end
  
end
