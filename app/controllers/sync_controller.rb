class SyncController < ApplicationController
  def sync

    User.update! name: params.require(:user).permit(:name) if params[:user].present?
  end
end
