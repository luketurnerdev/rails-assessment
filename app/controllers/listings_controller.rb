class ListingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:new, :create, :edit, :update]

  def index
    @listings = printer? ? Listing.all : User.find(current_user.id).listings
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.create(listing_params)
    if @listing.errors.any?
      render 'new'
    else
      redirect_to listing_path(@listing.id)
    end
  end

  def show
    id = params[:id]
    @listing = Listing.find(id)
  end

  def update
    @listing = Listing.find(params[:id])

    if @listing.update(listing_params)
      redirect_to(@listing)
    else
      render :edit
    end
  end

  def edit
    @listing = Listing.find(params[:id])
  end

  def destroy
    Listing.find(params[:id]).destroy
    redirect_to listings_path
  end

  private

  def set_listing
    id = params[:id]
    @listing = Listing.find(id)
  end

  def authorize_user
    redirect_to listings_path if printer?
  end

  def listing_params
    params.require(:listing).permit(
      :description,
      :budget,
      :due_date,
      :has_job,
      :design_file
    )
  end

  def printer?
    current_user.user_type == 'printer'
  end
end
