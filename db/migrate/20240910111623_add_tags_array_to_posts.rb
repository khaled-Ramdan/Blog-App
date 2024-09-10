class AddTagsArrayToPosts < ActiveRecord::Migration[7.2]
  def change
    # Remove old tags column
    remove_column :posts, :tags
    # add new tags column
    add_column :posts, :tags, :string, array: true, default: []

  end
end
