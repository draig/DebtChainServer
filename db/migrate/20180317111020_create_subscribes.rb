class CreateSubscribes < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribes do |t|
      t.boolean :active
      t.boolean :sync

      t.timestamps
    end
  end
end
