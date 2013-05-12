Sequel.migration do
  change do
    alter_table(:events) do
      add_column :image, File, text: true
    end
  end
end