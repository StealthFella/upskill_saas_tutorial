class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before action :only_current_user
  
  # GET to /user/:user_id/profile/new
  def new
    # Render a blank profile details form.
    @profile = Profile.new
  end
  
  
  # POST to /user/:user_id/profile
  def create
    
    # Ensure we have the user who is filling out the form.
   @user = User.find( params[:user_id])
   
   # Create profile linked to this specific user with the whitelisted profiles ( profile params )
   # 
   @profile = @user.build_profile( profile_params )
   
   # If it saves and is successful then send notice and redirect to root.
   if @profile.save
     flash[:success] = "Profile Updated!"
     redirect_to user_path( params[:user_id] )
   else
     render action :new
   end
  end
  
  # GET to /users/:user_id/profile/edit
  def edit
    @user = User.find( params[:user_id])
    @profile = @user.profile
  end
  
  # PUT to /users/:user_id/profile
  def update
    # Retrieve the user from the database
    @user = User.find( params[:user_id] )
    # Retrieve that user's profile
    @profile = @user.profile
    # Mass assign edited/updated profile attributes and save(update)
    if @profile.update_attributes(profile_params)
      flash[:success] = "Profile has been updated!"
      # Redirect user to their profile page
      redirect_to user_path(id:  params[:user_id] )
    else
      render action: :edit
    end
  end
  
  # Whitelist the params below.
  private
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :avatar,  :job_title, :phone_number, :contact_email, :description)
  end
  
  def only_current_user
    @user = User.find( params [:user_id])
    redirect_to(root_url) unless @user == current_user
  end

    
end