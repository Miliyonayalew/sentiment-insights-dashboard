class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: { message: "Reset password instructions have been sent to your email.", is_success: true }, status: :ok
    else
      render json: { message: "Failed to send reset password instructions.", errors: resource.errors.full_messages, is_success: false }, status: :unprocessable_entity
    end
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      render json: { message: "Password has been reset successfully.", is_success: true }, status: :ok
    else
      render json: { message: "Password reset failed.", errors: resource.errors.full_messages, is_success: false }, status: :unprocessable_entity
    end
  end
end
