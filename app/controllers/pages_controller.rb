class PagesController < ApplicationController
  #Authenticate users on all pages except landing page
  before_action :authenticate_user!, except: [:index]
  before_action :job_summary, only: [:dashboard]

  #Don't run the redirection on the printer info page
  # skip_before_action :check_if_printer, only: [:printer_info, :sign_out]

  def index
    redirect_to dashboard_path if user_signed_in?
  end

  def dashboard
    @user_id = current_user.id

    if current_user != nil && current_user.user_type == 'printer'
      if Printer.find_by_user_id(current_user.id).nil?
        redirect_to printer_info_path
      end
    end
  end

  def printer_info
    @printer = Printer.new
  end

  def create
    if Printer.find_by_user_id(current_user.id).nil?
      @printer = Printer.create(printer_params)
    end

    if @printer.errors.any?
      render 'printer_info'
    else
      redirect_to dashboard_path
    end
  end

  private

  def printer_params
    params.require(:printer).permit(:abn, :printer_model, :user_id)
  end

  def job_summary
    #Determine which quotes have been made into a job by searching the relevant tables
    @active_listings = Listing.where(user_id: current_user.id).count

    @listings_count = Listing.all.count

    if current_user.user_type == "printer"
      #return quotes that belong to the user, and the associated job also belong to the user
      @open_quotes = Quote.joins(:printer).where(printers:{user_id:current_user.id}, has_job:false).count

      #Only run if the user's printer info has been added into the printer table
      if Printer.where(user_id:current_user.id).exists?
        @completed_jobs = Job.joins(:quote).where(quotes: {printer_id: Printer.find_by_user_id(current_user.id).id}).where(jobs: {status: true}).count
        #Check if a quote has been assigned to a job that belongs to another printer
      end
    elsif current_user.user_type == "designer"
      @open_quotes = Quote.joins(:listing).where(listings:{user_id:current_user.id}, has_job:false).count
      @completed_jobs = Job.joins(:listing).where(listings: {user_id: current_user.id}).where(jobs: {status: true}).count
    else
      #Kick them out if not logged into either type
      redirect_to root_path
    end 
  end
end