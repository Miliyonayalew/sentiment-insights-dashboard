module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # Extract JWT token from query params since WebSocket doesn't support Authorization headers
      token = request.params[:token]
      return reject_unauthorized_connection unless token

      begin
        decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key)[0]
        user = User.find(decoded_token['sub'])
        return user if user
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        # Invalid token or user not found
      end

      reject_unauthorized_connection
    end
  end
end
