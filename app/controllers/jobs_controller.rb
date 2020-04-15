class JobsController < ApplicationController
  before_action :amount_of_user_jobs, only: :index

  def index
    @jobs = Job.all
    @user_id = current_user.id
  end

  def show
    id = params[:id]
    @job = Job.find(id)
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(status: true, completed_at: Time.now)
      redirect_to job_path(@job)
    end
  end

  private

  def amount_of_user_jobs
    Job.joins(:listing).where(listings: { user_id: @user_id }).count if designer?
    Job.joins(:quote).where(quotes: { printer_id: printer_id }).count
  end

  def designer?
    current_user.user_type == 'designer'
  end

  def printer_id
    Printer.find_by_user_id(@user_id).id
  end
end
