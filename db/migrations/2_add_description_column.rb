Sequel.migration do
  change do
    alter_table(:events) do
      add_column :description, String, text: true
    end
  end
end