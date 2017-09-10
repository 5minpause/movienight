class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    render "pages/#{params[:page]}"
  end
end
