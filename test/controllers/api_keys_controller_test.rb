require 'test_helper'

class ApiKeysControllerTest < ActionController::TestCase
  setup do
    @api_key = api_keys(:one)
  end
  
  # :registerAccount
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
      post :registerAccount, { paymentIdentifier: "anddfsdffajds", secret:ENV['LISHOP_API_SECRET'], receipt: "ADAFSDFASDF"}
    end
    object = JSON.parse(@response.body)
    assert_not_nil object, "There was no response"
    assert_not_nil object['api_key'], "Response has no api_key"
    assert_equal 32, object['api_key'].length, "The size of the api_key is incorrect"
    assert_response :ok
  end
  
  test "calling registerAccount two times must return two different api_keys, but must generate only one list" do
    pi = "anddfsdffajds"
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

  # :requestNewApiKey
  test "post without api_key must fail" do
    post :requestNewApiKey
    assert_response :bad_request
  end  

  test "post with an invalid api_key must fail" do
    INVALID_API_KEY = 'adnfaklhdaksdlkfjaslkd'
    @request.headers['api_key'] = INVALID_API_KEY
    post :requestNewApiKey, { email: 'veladan@gmail.com' }
    assert_response :unauthorized
  end  

  test "post without email must fail" do
    @request.headers['api_key'] = @api_key.api_key
    post :requestNewApiKey
    assert_response :bad_request
  end  
  
  test "post with email must resturn ok and send an email" do
    @request.headers['api_key'] = @api_key.api_key
    assert_difference('ApiKey.count') do
      post :requestNewApiKey, { email: 'veladan@gmail.com' }
    end
    assert_response :ok
  end  

  # :recoverApiKey  
  test ":recoverApiKey post without email must fail" do
    post :recoverApiKey
    assert_response :bad_request
  end  

  test ":recoverApiKey post with an invalid email must fail" do
    post :recoverApiKey, {email: 'guirirui@guir.com'}
    assert_response :bad_request
  end  

  test " :recoverApiKey valid post should return ok" do
    @validUser = api_keys(:two)
    post :recoverApiKey, {email: @validUser.email}
    assert_response :ok
  end
  
end
