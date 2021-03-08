require 'elasticsearch/model'

class RoomMessage < ApplicationRecord
  validates_presence_of :room_id, :user_id, :message, :created_at, :updated_at
 
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :room, inverse_of: :room_messages

  belongs_to :user
  
  index_name    'instaapibugs'
  document_type 'bug'

  es_index_settings = {
    'analysis': {
      'filter': {
        'trigrams_filter': {
          'type':'ngram',
          'min_gram': 3,
          'max_gram': 3
        }
      },
      'analyzer': {
        'trigrams': {
          'type': 'custom',
          'tokenizer': 'standard',
          'filter': [
            'lowercase',
            'trigrams_filter'
          ]
        }
      }
    }
  }

  #def as_indexed_json(options={})
  #as_json(
  #  only: [:id, :first_name, :email],
    #include: [:phone_numbers]
  #)
  #end

  settings es_index_settings do
    mapping do
      indexes :comment, type: 'string', analyzer: 'trigrams'
    end
  
  trigger.after(:insert) do
     "UPDATE room_messages SET room_meesage_id  = ( SELECT IFNULL(MAX(room_meesage_id), 0) + 1 FROM room_messages WHERE room_id  = NEW.room_id );"
  end
 
end




  def as_json(options)
    super(options).merge(user_avatar_url: user.gravatar_url)
  end



end

RoomMessage.import(force: true)
