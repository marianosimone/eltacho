Sequel.migration do
  up do
    # And create database schema for development.
    create_table :bins do
      primary_key :id
      String :name
    end

    create_table :events do
      primary_key :id
      String :name, null: false
      DateTime :start
      DateTime :end
    end

    create_join_table bin_id: :bins, event_id: :events

    create_table :disposals do
      primary_key :id
      foreign_key :bin_id, :bins, null: false
      DateTime :created_at, null: false
      Integer :count, null: false, default: 0
    end
  end
end