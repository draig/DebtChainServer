class AuthController < ApplicationController
  before_action :phone, only: %i[send_sms verify_code]

  def send_sms
    response = Authy::PhoneVerification.start(via: 'sms', country_code: @country_code, phone_number: @phone_number)
    render json: { status: 'Error', error: 'Error delivering code verification' }, status: :internal_server_error && return unless response.ok?
    render json: { status: 'Success' }, status: :ok
  end

  def verify_code
    params.require(:verification_code)
    @verification_code = params[:verification_code]
    response = Authy::PhoneVerification.check(verification_code: @verification_code, country_code: @country_code, phone_number: @phone_number)
    render json: { status: 'Error', error: 'Verify Token Error' }, status: :internal_server_error && return unless response.ok?
    user = User.find_or_create_by phone: @phone
    render json: { user: user.dto, auth_token: JsonWebToken.encode(user_id: user.id) }, status: :ok
  end

  private

  def phone
    params.require %i[phone_number country_code]
    @phone_number = params[:phone_number]
    @country_code = params[:country_code]
    @phone = @country_code + @phone_number
  end
end
