class TripsController < ApplicationController
  
   before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy
  
  
   def show
    @trip = Trip.find(params[:id])
     respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trip }
end
end

  def new
    @trip = Trip.new
  end
  
  def index
   @trips = current_user.trips.all
   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trips }
    end
   end

  def create
    @trip = current_user.trips.build(params[:trip])
     if @trip.save
     
      flash[:success] = "Trip created!"
      redirect_to @trip
      # Handle a successful save.
    else
      render 'new'
    end
  end

end
