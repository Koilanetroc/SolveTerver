class AuthController < ApplicationController
  skip_before_action :authenticate, only: [:index]

  def index
    if params[:code].present?
      token = Octokit.exchange_code_for_token(params[:code], ENV['CLIENT_ID'], ENV['CLIENT_SECRET'])
      session[:access_token] = token[:access_token]
      redirect_to stars_path
    else
      @client_id = ENV['CLIENT_ID']
      redirect_to stars_path if session[:access_token]
    end
  end
end
