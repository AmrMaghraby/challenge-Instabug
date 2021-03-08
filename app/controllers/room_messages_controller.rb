class RoomMessagesController < ApplicationController
  skip_forgery_protection
  before_action :load_entities
  
  def index
    @roomMessages = RoomMessage.all
    render json: @roomMessages
  end  


  def create
    @room = Room.find params.dig(:room_message, :room_id)
    @room.with_lock do
      if @room.count == nil
        @room.count = 0
      end
      chat_count = @room.count + 1;
      @room.update(count: chat_count)
    end 
    MessageWorker.perform_async @room.id, current_user.id, params.dig(:room_message, :message)
    record_id = RoomMessage.maximum(:id)
    record = RoomMessage.find(record_id)
    #render json:  record
    record.__elasticsearch__.index_document
    #render json: record_id
    #index_name = Person.index_name
    #index_name = RoomMessage.index_name
    #RoomMessage.__elasticsearch__.create_index! force: true
    #RoomMessage.all.find_in_batches(batch_size: 1) do |group|
      #render json: group
      
    #   group_for_bulk = group.map do |a|
    #     { index: { _id: a.id, data: a.message } }
    #   end
    #  RoomMessage.__elasticsearch__.client.bulk(
    #    index: "instaapibug",
    #    type: "bug",
    #    body: group_for_bulk
    #  )
    #end
    #
    
    
    #index_name = RoomMessage.index_name
    #RoomMessage.__elasticsearch__.client.bulk(index: index_name, );
    #RoomMessage.__elasticsearch__.create_index!
    #RoomMessage.__elasticsearch__.refresh_index!  force: true
    render :json => {"message": 'Massege send successfull to Go worker'}
  end

  protected

  def load_entities
    #@room = Room.find params.dig(:room_message, :room_id)
  end
end

#MessageWorker.perform_async 1, 1 , "dd"