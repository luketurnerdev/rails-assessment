class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def check_if_printer
    if current_user != nil
      if current_user.user_type == "printer" && Printer.find_by_id(current_user.id) == nil
        #does user exist in the printer table?
        #if not, redirect them to the info form and then put them in the table
        redirect_to printer_info_path(printer: @printer)
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(sign_up_parameters)
    end
  end

  def sign_up_parameters
    [:first_name, :last_name, :email, :password, :phone, :postcode, :user_type]
  end

end