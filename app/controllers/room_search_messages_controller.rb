class RoomSearchMessagesController < ApplicationController
    skip_forgery_protection

  
    def index
        if params[:search_message]    
           @results = params[:search_message].nil? ? [] : RoomMessage.search(params[:search_message])
        end
       render json: @results
    end
  
    def new
    end
  
    def create
    end
    
    def show
    end
  
    def edit
    end
  
    def update
    end
end
