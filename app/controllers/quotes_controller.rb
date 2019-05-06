class QuotesController < ApplicationController
    def index
        #shows all quotes
        @quotes = Quote.all


        #make sure there is a listing to reference
       
    end

    def show
        # view a single quote
        id = params[:id]
        @quote = Quote.find(id)
    end

    def create

        # create new quote for a listing
        if current_user.user_type == "printer"
           
            @quote = Quote.create(
                total_price: params[:quote][:total_price],
                job_size: params[:quote][:job_size],
                turnaround_time: params[:quote][:turnaround_time],
                has_job: false,
                printer_id: params[:quote][:printer_id],
                listing_id: params[:quote][:listing_id]
            )
                
            
                if @quote.errors.any?
                    # @listing = params[:quote][:listing_id].to_i

                    render "new"
                    
                else
                    redirect_to quote_path(@quote.id)
                end



        end


    end

    def render_with_errors
        @quote = params[:quote]
        @listing = params[:listing]
        render 'new'
    end

    def new
        # shows form for creating a new quote
        @quote = Quote.new
    end

    def my_quotes
        @user_id = current_user.id
        @quotes = Quote.all
    end

    def edit
        # shows form for editing an existing quote
        @quote = Quote.find(params[:id])
    end

    def update
        # updates the listing
        @quote = Quote.find(params[:id])
        if @quote.update(quote_params)
            redirect_to(@quote)
        else
            render "edit"
        end
    end

    private
    def quote_params
        params.require(:quote).permit(:total_price, :job_size, :turnaround_time, :printer_id, :listing_id)
        # whitelist of what we will accept
    end
end