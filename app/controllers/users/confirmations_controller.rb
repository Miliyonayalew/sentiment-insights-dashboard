class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      render json: { message: "Your email address has been successfully confirmed.", is_success: true }, status: :ok
    else
      render json: { message: "Email confirmation failed.", errors: resource.errors.full_messages, is_success: false }, status: :unprocessable_entity
    end
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
        render json: { message: "Confirmation instructions have been sent to your email.", is_success: true }, status: :ok
    else
        render json: { message: "Failed to send confirmation instructions.", errors: resource.errors.full_messages, is_success: false }, status: :unprocessable_entity
    end
  end
end