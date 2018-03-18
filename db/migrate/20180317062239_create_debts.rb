class CreateDebts < ActiveRecord::Migration[5.1]
  def change
    create_table :debts do |t|
      t.string :party
      t.string :currency
      t.string :title

      t.references :creator, type: :uuid, references: :users
      t.timestamps
    end
  end
end
