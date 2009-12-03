class CreateFlights < ActiveRecord::Migration
  def self.up
    create_table :flights do |t|
      t.string :import_id
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
      t.string :point_source
      t.float :altDot
      t.float :delta_distance
      t.float :windDir
      t.float :windMag
      t.float :true_airspeedCalc
      t.float :true_airspeedUsed
      t.float :true_airspeed
      t.float :true_airspeed_dot
      t.float :bank_angle
      t.string :config
      t.float :lift_coeff
        t.timestamps
    end
  end

  def self.down
    drop_table :flights
  end
end
