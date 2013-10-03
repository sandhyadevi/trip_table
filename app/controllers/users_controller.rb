class UsersController < ApplicationController

before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  
def new
    @user = User.new
	 respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
  
  # GET /users/1
  # GET /users/1.json

   def show
    @user = User.find(params[:id])
    @trips = @user.trips.paginate(page: params[:page])
	respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user.as_json(:only => ["id","username","name"]) }
    end
    end


  # GET /users
  # GET /users.json
    def index
   @users = User.paginate(page: params[:page])
	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user}
    end
  end

  # POST /users
  # POST /users.json
 def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
    def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
   def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
private

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end