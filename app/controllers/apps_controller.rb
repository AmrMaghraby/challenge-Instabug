class AppsController < ApplicationController
  skip_forgery_protection
  #respond_to :json
  #before_action :load_entities
  respond_to :json
  def index
    @apps = App.all
    @app = App.new
    if(params[:search])
         @current_application =  App.where(:access_token => params[:search])
    end
    render json: @apps
  end

  def new
    @app = App.new
  end

  def create
      @app = App.new permitted_parameters
      @app.access_token = generate_token
     
     if @app.save
        render json: @app
     else 
        render json: @app.errors
     end
  end

  def show
    if(params[:id])
      @current_application  =  App.where(:access_token => params[:id]).first
    end  
    
    if(params[:chatsearch])
      @current_chats =  Room.where(:name => params[:chatsearch] , :app_token => @current_application.access_token)
    #render :json => @current_chats
    end
    if @current_chats && @current_application
      render json: @current_chats
    elsif @current_application
      render json: @current_application
    end
  end

  def edit
  end

  def update
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
