# frozen_string_literal: true

class MyDevise
  class ConfirmationsController < Devise::ConfirmationsController
    layout 'session'

    def create
      user = User.find_by(:email => confirmation_params[:email])

      if user && !user.enabled
        set_flash_message :alert, :disabled
        redirect_to new_user_confirmation_path
      else
        super
      end
    end

    private

    def confirmation_params
      params.require(:user).permit(:email)
    end
  end
end
