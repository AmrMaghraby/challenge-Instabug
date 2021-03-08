class RoomsController < ApplicationController
  # Loads:
  # @rooms = all rooms
  # @room = current room when applicable
  skip_forgery_protection
  #respond_to :json
  before_action :load_entities

  def index
    @rooms = Room.all
    render json: @rooms
  end

  def new
    @room = Room.new
  end

  def create
    
    @room = Room.new permitted_parameters

    #if params[:app_id] == nil
    #   render :new
    #else
       #@room.app_id = params[:app_id]

      @app = App.find(@room.app_id)
      @app.with_lock do 
        if @app.count == nil
          @app.count = 0
        end
        room_number = @app.count + 1
        @app.update(count: room_number)
      end
       
       if @app.access_token != @room.app_token
          render :json => 'App token not correctly inserted'
       elsif @app.access_token == @room.app_token && @room.save 
          #flash[:success] = "Room #{@room.name} was created successfully"
          #redirect_to rooms_path
          render json: @room
       elsif
          render json: @room.errors
       end
    end
  #end
  def show
    #@room_message = RoomMessage.new room: @room
    #@room_messages = @room.room_messages.includes(:user)
    
    if params[:search_message]    
          @results = params[:search_message].nil? ? [] : RoomMessage.search(params[:search_message])
    end
    if params[:id]
      begin
        @current_room = Room.find(params[:id])
        render json: @current_room
      rescue Exception
        render :json => "Couldn't find Room with 'id'"+params[:id]
      end  
    end  
  end

  def edit
  end

  def update
    #if @room.update_attributes(permitted_parameters)
    #  flash[:success] = "Room #{@room.name} was updated successfully"
    #  redirect_to rooms_path
    #else
    #  render :new
    #end
  end

  protected

  def load_entities
    #@rooms = Room.all
    #@room = Room.find(params[:id]) if params[:id]
  end

  def permitted_parameters
    params.require(:room).permit(:name ,:app_token, :app_id)
  end
  
  private
  def chat_id
    chatId = params[:id]
  end
end
