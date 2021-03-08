class AppsController < ApplicationController
  skip_forgery_protection
  respond_to :json

  #/Get All Applications
  def index
    
    @apps = App.all
    @app = App.new

    # in case you are searching for specific application insert it is token and will be retrived
    
    if(params[:search])
         @current_application =  App.where(:access_token => params[:search])
    end

    render json: @apps
  end

  def new
    @app = App.new
  end

  # creating new application with :name paramter returning it is token

  def create
  
      @app = App.new permitted_parameters
      # retriving generated unique token and assiging it to new created app
      @app.count = 0
      @app.access_token = generate_token
      # trying to save current application
      if @app.save
        render json: @app
      else 
        render json: @app.errors
      end
  end
  
  # show single application with given paramter id also if given room created 
  # be this token it could be displayed 
  
  def show
    
    # check if :id exists or not as paramter from request body
    
    if(params[:id])
      @current_application  =  App.where(:access_token => params[:id]).first
    end  
    
    # check if chat_search is given or not in request body

    if(params[:chatsearch])
      @current_chats =  Room.where(:name => params[:chatsearch] , :app_token => @current_application.access_token)
    end
     
    # in case both exist (application id and chatname created by this application) and valid will be displayed

    if @current_chats && @current_application
      render json: @current_chats
    elsif @current_application  # if application exists but not chat display it
      render json: @current_application
    end
  end

  def edit
  end

  def update
  end

  def delete_app
    @current_application  =  App.where(:access_token => params[:access_token]).first
    if @current_application.destroy
      render :json => "Successful: Deleted " +  params[:app_token].to_s
    else
      render json: "Unsuccessful: Valid token number but could not Delete"
    end
  end

  def get_chat_counts

    # check if :id exists or not as paramter from request body
    
    if(params[:access_token]) 
      @current_application  =  App.where(:access_token => params[:access_token]).first
      render :json => @current_application.count
    else  # if not exist display error massege  
      render :json => "message: application token is invalid"
    end
  end

  protected

  def load_entities
    @apps = App.all
    @app = App.find(params[:id]) if params[:id]
  end

  def permitted_parameters
    if :name == nil
      render :json => "Application name is missing"
    else
      params.require(:app).permit(:name)
    end
  end

  private
  def application_id
    app_id = params[:id] 
  end 
  def generate_token
    loop do
      token = SecureRandom.hex(10)
      break token unless App.where(access_token: token).exists?
    end
  end

end
