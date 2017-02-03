class CreateAmounts < ActiveRecord::Migration[5.0]
  def change
    create_table :bookkeeper_amounts do |t|
      t.string      :type, null: false
      t.references  :account, null: false
      t.references  :entry, null: false
      t.decimal     :value, null: false, precision: 20, scale: 10

      t.timestamps
    end
    add_index :bookkeeper_amounts, [:account_id, :entry_id]
  end
end
