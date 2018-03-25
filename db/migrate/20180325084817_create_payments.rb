class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string :title
      t.numeric :amount
      t.string :currency
      t.string :payer
      t.string :party
      t.boolean :deleted

      t.belongs_to :creator, type: :uuid, references: :users
      t.belongs_to :debt, index: true
      t.timestamps
    end
  end
end