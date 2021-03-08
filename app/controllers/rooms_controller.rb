class RoomsController < ApplicationController
  skip_forgery_protection
  respond_to :json
  
  # Get all rooms created
  def index
    if :app_token == nil
      render :json => "message: Applicaiton token missing"
    else
      @rooms = Room.where(:app_token => params[:app_token])
      render json: @rooms
    end
  end

  def new
    @room = Room.new
  end
  
  # create new room under given application token
  def create
    
    # initialize new room with name and application
    #(token and id) which will be placed under it.
    @room = Room.new permitted_parameters
    
    # find app which room will be placed under it
    @app = App.find(@room.app_id)
    
    # handling race condition if more than server running at 
    # same time this variable will be update one time instead of twice
    # assume two users at same time incrementing it if it was 5 
    # then it will be 6 not 7
    @app.with_lock do # lock what will happen here so only one user will increment
   
      # in case app is null it will throw exception here I try to prevent it
      if @app.count == nil
        @app.count = 0
      end
      
      room_number = @app.count + 1
      @app.update(count: room_number)
    
    end
    
    # if user entered wrong app token warn him
    if @app.access_token != @room.app_token
      render :json => 'App token not correctly inserted'
    elsif @app.access_token == @room.app_token && @room.save # if room saved? display it
      render json: @room
    elsif
      render json: @room.errors
    end
  end
  
  def show
    # getting id to retrive corrosponding room
    if params[:id]
  
      begin
        @current_room = Room.find(params[:id])
        render json: @current_room
      rescue Exception
        render :json => "Couldn't find Room with 'id'"+params[:id]
      end  
    end  
  end

  def get_chat_counts
    
    if params[:app_token] == nil || params[:chat_number] == nil
      render :json => "message: missing paramters"
    end

    @room = Room.where(:id => params[:chat_number])
    @rooms_created_under_app =  @room.where(:app_token => params[:app_token])

    render :json => @rooms_created_under_app.count
  end


  def delete_room

    if params[:app_token] == nil || params[:chat_number] == nil
      render :json => "message: missing paramters"
    end

    @room = Room.where(:id => params[:chat_number])
    @rooms_created_under_app =  @room.where(:app_token => params[:app_token])
    
    if @rooms_created_under_app
      if @rooms_created_under_app.first.destroy
        render :json => "Successful: Deleted " +  params[:app_token].to_s
      else
        render :json => "Unsuccessful: Could not perfrom operation"
      end
    end
  end

  def edit
  end

  def update
  end

  protected

  def permitted_parameters
    params.require(:room).permit(:name ,:app_token, :app_id)
  end
  
  private
  def chat_id
    chatId = params[:id]
  end
end
