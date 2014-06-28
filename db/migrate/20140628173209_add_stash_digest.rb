class AddStashDigest < ActiveRecord::Migration
  def change
    add_column :stashes, :digest, :string
    remove_column :stashes, :tags
  end
end
