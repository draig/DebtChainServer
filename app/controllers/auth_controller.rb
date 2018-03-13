class AuthController < ApplicationController
  before_action :get_phone, only: [:send_sms, :verify_code]

  def send_sms
    response = Authy::PhoneVerification.start(
        via: 'sms',
        country_code: @country_code,
        phone_number: @phone_number
    )

    if !response.ok?
      render json: {error: 'Error delivering code verification'}, status: :internal_server_error and return
    end

    render json: response, status: :ok
  end

  def verify_code
    params.require(:verification_code)
    @verification_code = params[:verification_code]

    response = Authy::PhoneVerification.check(
        verification_code: @verification_code,
        country_code: @country_code,
        phone_number: @phone_number
    )

    if !response.ok?
      render json: {error: 'Verify Token Error'}, status: :internal_server_error and return
    end

    user = User.find_or_create_by phone: @phone

    render json: user, status: :ok
  end

  private

  def get_phone
    params.require %i[phone_number country_code]
    @phone_number = params[:phone_number]
    @country_code = params[:country_code]
    @phone = @country_code + @phone_number
  end
end
