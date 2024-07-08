class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      t.json :campaigns_list

      t.timestamps
    end

    add_index :users, :email
  end
end
