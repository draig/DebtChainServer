class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :phone
      t.string :ava

      t.timestamps
    end
  end
end
