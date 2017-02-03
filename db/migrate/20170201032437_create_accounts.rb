class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :bookkeeper_accounts do |t|
      t.string  :type, null: false
      t.string  :name, null: false
      t.string  :code
      t.boolean :contra, index: true, default: false

      t.timestamps
    end
    add_index :bookkeeper_accounts, [:name, :type], unique: true
    add_index :bookkeeper_accounts, [:name, :type, :code], unique: true
  end
end
