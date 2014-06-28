class CreateStashes < ActiveRecord::Migration
  def self.up
    create_table :stashes do |t|
      t.integer :contentable_id
      t.string :contentable_type
      t.text :tags
      t.boolean :hidden
      t.boolean :all_tags
      t.timestamps
    end

    create_table :messages do |t|
      t.text :content
    end

  end

  def self.down
    drop_table :stashes
    drop_table :messages
  end
end
