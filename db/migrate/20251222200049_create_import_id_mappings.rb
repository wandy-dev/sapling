class CreateImportIdMappings < ActiveRecord::Migration[8.1]
  def change
    create_table :import_id_mappings do |t|
      t.string :source
      t.string :source_type
      t.string :source_id
      t.string :target_id

      t.timestamps
    end
  end
end
