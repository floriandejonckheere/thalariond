# frozen_string_literal: true

class MyDevise
  class PasswordsController < Devise::PasswordsController
    layout 'session'

    def create
      user = User.find_by(:email => password_params[:email])

      if user && !user.enabled
        set_flash_message :alert, :disabled
        redirect_to new_user_password_path
      else
        super
      end
    end

    private

    def password_params
      params.require(:user).permit(:email)
    end
  end
end
