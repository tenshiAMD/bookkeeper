class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :bookkeeper_entries do |t|
      t.string  :description, null: false
      t.date    :date, null: false, index: true

      t.timestamps
    end
  end
end
