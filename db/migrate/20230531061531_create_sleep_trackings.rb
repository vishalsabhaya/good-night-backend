class CreateSleepTrackings < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_trackings do |t|
      t.references :user, foreign_key: true, comment: 'user id'
      t.datetime :clock_in, comment: 'sleep time'
      t.datetime :clock_out, comment: 'Wakeup time out'
      t.integer :sleep_duration, comment: 'time diffrence in second'
      t.timestamps
    end
  end
end
