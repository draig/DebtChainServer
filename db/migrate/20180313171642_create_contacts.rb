class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :internal_id
      t.string :phones
      t.string :name

      t.references :friend, type: :uuid, references: :users
      t.references :mapped, type: :uuid, references: :users

      t.timestamps
    end
  end
end
