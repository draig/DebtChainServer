class CreateDefaultAvatarts < ActiveRecord::Migration[5.1]
  def change
    create_table :default_avatarts do |t|
      t.string :url
    end
  end
end
