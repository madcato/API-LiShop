require 'test_helper'

class ApiKeysControllerTest < ActionController::TestCase
  setup do
    @api_key = api_keys(:one)
    @invalid_api_key = 'adnfaklhdaksdlkfjaslkd'
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
    @request.headers['X-lishop-api-key'] = @invalid_api_key
    post :requestNewApiKey, { email: 'veladan@gmail.com' }
    assert_response :unauthorized
  end  

  test "post without email must fail" do
    @request.headers['X-lishop-api-key'] = @api_key.api_key
    post :requestNewApiKey
    assert_response :bad_request
  end  
  
  test "post with email must resturn ok and send an email" do
    @request.headers['X-lishop-api-key'] = @api_key.api_key
    inviteeEmail = 'dani_vela@me.com'
    assert_difference ['ApiKey.count', 'ActionMailer::Base.deliveries.size'], +1 do
      post :requestNewApiKey, { email: inviteeEmail }
    end
    invite_email = ActionMailer::Base.deliveries.last
    assert_equal inviteeEmail, invite_email.to[0]
    
    
    assert_response :ok
    object = JSON.parse(@response.body)
    assert_not_nil object, "There was no response"
    api_key = object['api_key']
    assert_not_nil api_key
  end  
  
  test "request a new key with a not owner ApiKey mut be forbidden" do
    @request.headers['X-lishop-api-key'] = api_keys(:two).api_key
    inviteeEmail = 'dani_vela@me.com'
    post :requestNewApiKey, { email: inviteeEmail }    
    assert_response :forbidden
  end
  
  test "request an apikey with an invalid email must resturn interval sever error" do
    @request.headers['X-lishop-api-key'] = @api_key.api_key
    inviteeEmail = 'dani.me.com'
    post :requestNewApiKey, { email: inviteeEmail }  
    
    assert_response :internal_server_error
  end  

  # :removeApiKey
  test ":removeApiKey without api_key must fail" do
    post :removeApiKey, {sharedApiKey: 'guirirui@guir.com'}
    assert_response :forbidden
  end  

  test ":removeApiKey with an invalid api_key must fail" do
    @request.headers['X-lishop-api-key'] = @invalid_api_key
    post :removeApiKey, {sharedApiKey: 'guirirui@guir.com'}
    assert_response :unauthorized
  end  

  test ":removeApiKey without sharedApiKey: must fail" do
    @request.headers['X-lishop-api-key'] = @api_key.api_key
    post :removeApiKey
    assert_response :bad_request
  end  

  test ":removeApiKey with an invalid sharedApiKey: must fail" do
    @request.headers['X-lishop-api-key'] = @api_key.api_key
    post :removeApiKey, {sharedApiKey: 'guirirui@guir.com'}
    assert_response :not_found
  end  

  test ":removeApiKey with an valid sharedApiKey: must return ok and a list" do
    @request.headers['X-lishop-api-key'] = @api_key.api_key
    @otherUser = api_keys(:two)
    post :removeApiKey, {sharedApiKey: @otherUser.api_key}
    assert_response :ok
    object = JSON.parse(@response.body)
    assert_instance_of Array, object, "API should return an Array"
  end  
  
  # :sharedApiKey
  test ":sharedApiKey without api_key must fail" do
    post :sharedApiKey
    assert_response :forbidden
  end  
  
  test ":sharedApiKey with an invalid api_key must fail" do
    @request.headers['X-lishop-api-key'] = @invalid_api_key
    post :sharedApiKey
    assert_response :unauthorized
  end  

  test ":sharedApiKey with an valid api_key must be ok and return a list" do
    @request.headers['X-lishop-api-key'] = @api_key.api_key
    post :sharedApiKey
    assert_response :ok
    object = JSON.parse(@response.body)
    assert_instance_of Array, object, "API should return an Array"
  end  
    
  
end
