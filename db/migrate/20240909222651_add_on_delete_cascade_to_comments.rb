class AddOnDeleteCascadeToComments < ActiveRecord::Migration[7.2]
  def change
    # remove the current foreign key and add it gain with cascade
    remove_foreign_key :comments, :posts
    add_foreign_key :comments, :posts, on_delete: :cascade
  end
end
