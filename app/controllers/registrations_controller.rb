class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    # #Add authentication to see if user exists - this needs to be stated because we
    # #have custom signup params(:user_type)
    # #if the user exists, show an error

    #Extract user type from Devise's user hash and put it in our params
    params[:user_type] = params[:user][:user_type]

    super
  end

  def update
    super
  end
end