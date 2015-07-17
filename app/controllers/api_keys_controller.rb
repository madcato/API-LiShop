class ApiKeysController < ApplicationController
  before_action :checkParamsNewAccount, :only => [:registerAccount]
  before_action :checkParamsIncludeEmail, :only => [:requestNewApiKey, :recoverApiKey]
  before_action :checkParamsIncludeSharedApiKey, :only => [:removeApiKey]
  before_action :checkSecret, :only => [:registerAccount]
  before_action :checkApiKey, :except => [:registerAccount, :recoverApiKey]

  # To recover forgotten accounts.     
  def recoverApiKey
    begin
      @api_key = ApiKey.find_by!(email: params[:email])
      # TODO: Send api_key to params[email]
      head :ok
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
    
  end

  # To invite a new user to access owner list.  
  def requestNewApiKey
    # Only the owner can invite others
    if !@api_key.owner
      head :forbidden 
    else
      new_api_key = ApiKey.new
      new_api_key.list = @list
      new_api_key.email = params[:email]
      new_api_key.owner = false
      if new_api_key.save
        # TODO: Send invitation to params[email]
        head :ok
      else 
        head :internal_server_error
      end 
    end
  end

  #  To close access to other user.
  def removeApiKey
    begin
      @sharedApiKey = ApiKey.find_by!(api_key: params[:sharedApiKey])
      @sharedApiKey.destroy
      render json: ApiKey.all_without_owner
    rescue ActiveRecord::RecordNotFound
      head :not_found
    end
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

  # Return the shared keys and its emails. The owner user API_KEY is not returned.
  def sharedApiKey 
    render json: ApiKey.all_without_owner
  end
  
  private
  def checkParamsNewAccount
    head :bad_request if params[:paymentIdentifier].nil? || params[:secret].nil? || params[:receipt].nil? 
  end
  
  def checkParamsIncludeEmail
    head :bad_request if params[:email].nil? 
  end

  def checkParamsIncludeSharedApiKey
    head :bad_request if params[:sharedApiKey].nil? 
  end

  def checkSecret
    secret = params[:secret]
    return true if secret.nil? || secret == Rails4Example::Application.config.api_secret
  
    head :forbidden
    return false
  end
end
