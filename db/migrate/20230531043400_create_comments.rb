class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :commentable, polymorphic: true
      t.string :description, required: true
      t.timestamps
    end
  end
end
