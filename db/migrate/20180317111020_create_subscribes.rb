class CreateSubscribes < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribes do |t|
      t.boolean :active, default: true
      t.boolean :sync, default: true

      t.belongs_to :user, type: :uuid, index: true
      t.belongs_to :debt, index: true
      t.timestamps
    end
  end
end
