class App < ApplicationRecord

validates :name, uniqueness: true, presence: true
has_many :rooms


end
