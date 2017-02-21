class ProfilesController < ApplicationController
  
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
  
  # Whitelist the params below.
  private
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :job_title, :phone_number, :contact_email, :description)
  end
end