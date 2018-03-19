class AddSyncToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :sync, :boolean, default: false
  end
end
