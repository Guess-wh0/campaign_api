class AddIndexToCampaignLists < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      ALTER TABLE users ADD COLUMN campaign_names TEXT GENERATED ALWAYS AS (
        JSON_UNQUOTE(
          JSON_EXTRACT(campaigns_list, '$[*].campaign_name')
        )
      ) VIRTUAL;
    SQL

    add_index :users, :campaign_names
  end

  def down
    remove_index :users, :campaign_names

    execute "ALTER TABLE users DROP COLUMN campaign_names;"
  end
end
