class CreateShortLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :short_links do |t|
      t.string :original_url
      t.string :short_code

      t.timestamps
    end

    add_index :short_links, :short_code, unique: true
  end
end
