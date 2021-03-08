class RoomMessagesController < ApplicationController
  skip_forgery_protection

  
  def index
    if params[:id]
       @roomMessage = RoomMessage.find(params[:id])
       render json: @roomMessage
    else
       render json: "message: No element with this id"
    end
  end  

  # create Message which will be sent to sidekiq and sidekiq will wait worker to 
  #begin and process from the queue and insert by GO 
  def create
    # initialize room
    @room = Room.find params.dig(:room_message, :room_id)
    # here I am preventing roomcount reason for this if multiple server running
    # at same time and two users send massege at same time massege in this room 
    # will be incremented once not twice in this lock block we ensuure that 
    # this entity will be invoked once only.
    @room.with_lock do
      if @room.count == nil
        @room.count = 0
      end
      chat_count = @room.count + 1;
      @room.update(count: chat_count)
    end

    # Here I am sending the operation to sidekiq where Go  waits to start working 
    
    MessageWorker.perform_async @room.id, current_user.id, params.dig(:room_message, :message)

    # elastic search by default waits to recieve call back from rails after that it reindex it is
    # document so that new data could be easily found after insertion directly in our case we use
    # go so no feedback reaches elastic search this function do the job to reindex the latest record
    # entered database
    reindex_elastic
    
    render :json => {"message": 'Massege send successfull to Go worker'}
  end

  def reindex_elastic
    record_id = RoomMessage.maximum(:id) # get the id of current element
    record = RoomMessage.find(record_id) # extract that record
    record.__elasticsearch__.index_document #reindex it
  end

  def get_messages_under_specif_chat

    if params[:app_token] == nil || params[:chat_number] == nil
      render :json => "message: missing paramters"
    end

    @room = Room.where(:id => params[:chat_number])
    @rooms_created_under_app =  @room.where(:app_token => params[:app_token]).first
    if @rooms_created_under_app
      @messages = RoomMessage.where(:room_id => @rooms_created_under_app.id)
    end 
    render :json => @messages
    #render :json 
  end

  def delete
    if params[:id]
      @roomMessage = RoomMessage.find(params[:id])
    else
      render json: "message: No element with this id"
    end

    if @roomMessage.destroy
      render json: "message: Deleted"
    else 
      render json: "message: Could not delete message"
    end    
  end
end