class ApiKeysController < ApplicationController
  before_action :checkParamsNewAccount, :only => [:registerAccount]
  before_action :checkSecret, :only => [:registerAccount]
 
  # To invite a new user to access owner list.  
  def requestNewApiKey

  end

  # To create or recover an account.
  def registerAccount
    @list = List.find_or_create_by(paymentIdentifier: params[:paymentIdentifier])
    if @list.save
      @account = ApiKey.new
      @account.list = @list
      @account.owner = true
      if @account.save
        render json: { api_key: @account.api_key}
      else
        head :internal_server_error
      end
    else 
      head :internal_server_error
    end
  end

  private
  def checkParamsNewAccount
    head :bad_request if params[:paymentIdentifier].nil? || params[:secret].nil? || params[:receipt].nil? 
  end

  def checkSecret
    secret = params[:secret]
    return true if secret.nil? || secret == Rails4Example::Application.config.api_secret
  
    head :forbidden
    return false
  end
end
