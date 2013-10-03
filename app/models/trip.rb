# == Schema Information
#
# Table name: trips
#
#  id              :integer          not null, primary key
#  trip_id         :integer
#  title           :string(255)
#  destination     :string(255)
#  start_date      :date
#  end_date        :date
#  destination_lat :float
#  destination_lng :float
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Trip < ActiveRecord::Base
  
   attr_accessible :trip_id, :title, :destination, :start_date, :end_date, :destination_lat, :destination_lng, :user_id
         
		  belongs_to :user
   validates :user_id, presence: true  
   default_scope -> { order('created_at DESC') }
   validates :trip_id, presence: true
   validates :title, presence: true, length: {maximum: 60}
   validates :destination, presence: true, length: {maximum: 50}
   validates :start_date, presence: true
   validates :end_date, presence: true
   validates :destination_lat, presence: true
   validates :destination_lng, presence: true
   belongs_to :owner, :foreign_key => 'user_id', class_name: 'User'
    
  default_scope order: 'trips.created_at DESC'
end
