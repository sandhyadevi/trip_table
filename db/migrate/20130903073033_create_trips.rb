class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.belongs_to :user
      t.integer :trip_id
      t.string :title
      t.string :destination
      t.date :start_date
      t.date :end_date
      t.float :destination_lat
      t.float :destination_lng
      
      
      t.references :user

      t.timestamps
    end
	 add_index :trips, [:user_id]
     
  end
end
