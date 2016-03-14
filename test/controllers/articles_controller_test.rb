require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase
  setup do
    @article = articles(:one)
    @api_key = api_keys(:one)
    @invalid_api_key = 'adnfaklhdaksdlkfjaslkd'
  end

  
  test "get without api_key must fail" do
    get :index
    assert_response :forbidden
  end  

  test "get with an invalid api_key must fail" do
    @request.headers['api_key'] = @invalid_api_key
    get :index
    assert_response :unauthorized
  end  
  
  test "should get index" do
    @request.headers['api_key'] = @api_key.api_key
    get :index
    assert_response :success
    assert_not_nil assigns(:articles)
  end

  test "should get new" do
    @request.headers['api_key'] = @api_key.api_key
    get :new
    assert_response :success
  end

  test "should create article" do
    @request.headers['api_key'] = @api_key.api_key
    assert_difference('Article.count') do
      post :create, article: { category: @article.category, checked: @article.checked, list_id: @article.list_id, name: @article.name, prize: @article.prize, qty: @article.qty, shop: @article.shop, type: @article.type }
    end

    assert_redirected_to article_path(assigns(:article))
  end
  
  test "should fail to create an article without qty" do
    @request.headers['api_key'] = @api_key.api_key
    post :create, :format => :json, article: { category: @article.category, checked: @article.checked, list_id: @article.list_id, shop: @article.shop, type: @article.type }
    assert_response :unprocessable_entity
  end

  test "should create article in json" do
    @request.headers['api_key'] = @api_key.api_key
    assert_difference('Article.count') do
      post :create, :format => :json, article: { category: @article.category, checked: @article.checked, list_id: @article.list_id, name: @article.name, prize: @article.prize, qty: @article.qty, shop: @article.shop, type: @article.type }
    end

    assert_response :success
  end

  test "should show article" do
    @request.headers['api_key'] = @api_key.api_key
    get :show, id: @article
    assert_response :success
  end

  test "should get edit" do
    @request.headers['api_key'] = @api_key.api_key
    get :edit, id: @article
    assert_response :success
  end

  test "should update article" do
    @request.headers['api_key'] = @api_key.api_key
    patch :update, id: @article, article: { category: @article.category, checked: @article.checked, list_id: @article.list_id, name: @article.name, prize: @article.prize, qty: @article.qty, shop: @article.shop, type: @article.type }
    assert_redirected_to article_path(assigns(:article))
  end

  test "should update article in json" do
    @request.headers['api_key'] = @api_key.api_key
    patch :update, format: :json, id: @article, article: { category: @article.category, checked: @article.checked, list_id: @article.list_id, name: @article.name, prize: @article.prize, qty: @article.qty, shop: @article.shop, type: @article.type }
    assert_response :success
  end

  test "should fail to update an article in json without qty" do
    @request.headers['api_key'] = @api_key.api_key
    patch :update, format: :json, id: @article, article: { category: @article.category, checked: @article.checked, list_id: @article.list_id, name: @article.name, prize: @article.prize, qty: nil, shop: @article.shop, type: @article.type }
    assert_response :unprocessable_entity
  end
  
  test "should destroy article" do
    @request.headers['api_key'] = @api_key.api_key
    assert_difference('Article.count', -1) do
      delete :destroy, id: @article
    end

    assert_redirected_to articles_path
  end
end
