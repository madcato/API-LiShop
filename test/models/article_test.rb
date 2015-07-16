require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save article without name" do
    article = Article.new
    assert_not article.save
  end
  
  test "should save a basic article" do
    article = articles(:one)
    assert article.save
  end
  
  test "should save a complex article" do
    article = articles(:three)
    assert article.save
  end
  
  test "should not save a article without list_id" do
    article = Article.new
    article.name = 'Hola'
    assert_not article.save
  end

  test "should not save a article without qty" do
    article = Article.new
    article.name = 'Hola'
    article.list_id = 3
    assert_not article.save
  end

  test "should not save a article without checked" do
    article = Article.new
    article.name = 'Hola'
    article.list_id = 3
    article.qty = 3
    assert_not article.save
  end

  test "should save a basic article 2" do
    article = Article.new
    article.name = 'Hola'
    article.list_id = 3
    article.qty = 3
    article.checked = 0
    assert article.save
  end
  
  test "should not save a lista_id not numeric" do
    article = Article.new
    article.name = 'Hola'
    article.list_id = 'pepe'
    article.qty = 3
    article.checked = 0
    assert_not article.save
  end

  test "should not save a qty not numeric" do
    article = Article.new
    article.name = 'Hola'
    article.list_id = 2
    article.qty = 'adf'
    article.checked = 0
    assert_not article.save
  end

  test "should not save a checked not numeric" do
    article = Article.new
    article.name = 'Hola'
    article.list_id = 2
    article.qty = 3
    article.checked = 'adg'
    assert_not article.save
  end
end
