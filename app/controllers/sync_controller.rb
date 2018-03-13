class SyncController < ApplicationController
  before_action :auth

  def sync
    @current_user.update! params.require(:user).permit(:name) if params[:user].present?

     #if params[:contacts].present?

    render json: { status: 'Success' }, status: :ok
  end

  private

  def auth
    begin
      @current_user = User.auth request.headers['Authorization']
    rescue => ex
      render json: { status: 'Error', error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
