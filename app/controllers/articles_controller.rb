class ArticlesController < ApplicationController
  before_action :checkApiKey
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  
  # GET /articles
  # GET /articles.json
  def index
    @articles = @list.articles.all
    
    if params[:updated_at].nil?
      @articles = @list.articles.all
    else
      strDateTime = params[:updated_at];
      dateTime = DateTime.parse(strDateTime)
      dateTime = dateTime + 1.second
      @articles = @list.articles.where("updated_at > ?",dateTime)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { @articles = @list.articles.select('id') if params[:onlyIds].nil?;render :json => @articles; }
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @article }
    end
  end

  # GET /articles/new
  def new
    @article = @list.articles.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @article }
    end
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = @list.articles.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :json => @article, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = @list.articles.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:list_id, :name, :qty, :category, :type, :shop, :prize, :checked)
    end
end
