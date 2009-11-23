class CreateFlights < ActiveRecord::Migration
  def self.up
    create_table :flights do |t|
      t.string :title
  	  t.integer :time
  	  t.float :latitude
  	  t.float :longitude
  	  t.float :altitude
  	  t.float :groundspeed
  	  t.float :heading
  	  t.float :air_temp
  	  t.float :air_density
  	  t.float :pressure
        t.timestamps
    end
  end

  def self.down
    drop_table :flights
  end
end
