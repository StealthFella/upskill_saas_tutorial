class ContactsController < ApplicationController
  
  # GET request to /contact-us, custom route
  # Show new contact form, empty.
  def new
    @contact = Contact.new  
  end
  
  
  # POST Request to /contacts create
  def create
    # Mass assignment of form-fields into Content object
    @contact = Contact.new(contact_params)
    # Save the contact object to the database
    if @contact.save
      # Store form-fields via parameters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into the Contact Mailer 
      # email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      # Store success message in flash hash
      # and redirect to the NEW action up top.
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      # If Contact object doesn't save,
      # store the error in flash hash and redirect to the
      # new action up top.
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private
    # To collect data from form, we need to use
    # strong parameters (security feature) and whitelist
    # the form fields.
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end