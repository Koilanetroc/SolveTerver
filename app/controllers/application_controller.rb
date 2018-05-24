class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate
  before_action :force_html

  private

  def authenticate
    redirect_to 'auth#index' unless session[:access_token]
  end

  def force_html
    request.format = 'html'
  end
end
