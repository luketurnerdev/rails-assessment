class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    quote_id = params[:data][:object][:client_reference_id].to_i
    @stripe_transaction_id = params[:data][:object][:payment_intent]

    # check to see if job is already created with this quote id
    if !Job.find_by_quote_id(quote_id).nil?
      # if yes, update job with stripe_transaction_id
      Job.find_by_quote_id(quote_id).update(
        stripe_transaction_id: @stripe_transaction_id
      )
    else
      # if no, create job
      @quote = Quote.find(quote_id)

      @job = Job.create(
          listing_id: @quote.listing_id,
          quote_id: quote_id,
          printer_id: @quote.printer_id,
          status: false,
          stripe_transaction_id: @stripe_transaction_id
      )

      # need to update has_job column in listing and quote tables
      @quote.update(has_job: true)
      Listing.find(@job.listing_id).update(has_job: true)
    end

    render json: ''
  end

  def success
    redirect_to job_path(Job.find_by_quote_id(params[:quote_id]).id)
  end

  def cancel
  end
end