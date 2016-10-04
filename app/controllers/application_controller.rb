class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  
protected
  def checkApiKey
    if request.headers['X-lishop-api-key'].nil?
      head :forbidden 
    else 
      begin
        api_key = request.headers['X-lishop-api-key']
        @api_key = ApiKey.find_by!(api_key: api_key)
        @list = @api_key.list
      rescue ActiveRecord::RecordNotFound
        head :unauthorized
      end
    end
  end  
end
