class CreateFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :feeds do |t|
      t.belongs_to :user, index: true
      t.references :feedable, polymorphic: true
      t.timestamps
    end
  end
end
