# Connect to database.
db_url = ENV['DATABASE_URL']
if db_url
  # If a database URL is passed (e.g. on Heroku), connect to that database.
  Sequel.connect db_url
else
  # Use in-memory database.
  db = Sequel.sqlite

  # And create database schema for development.
  db.create_table :bins do
    primary_key :id
    String :name
  end

  db.create_table :events do
    primary_key :id
    String :name, null: false
    DateTime :start
    DateTime :end
  end

  db.create_join_table bin_id: :bins, event_id: :events

  db.create_table :disposals do
    primary_key :id
    foreign_key :bin_id, :bins, null: false
    DateTime :created_at, null: false
    Integer :count, null: false, default: 0
  end
end

# Add JSON serialization to all models.
Sequel::Model.plugin :json_serializer, naked: true

class Bin < Sequel::Model
  many_to_many :events
  one_to_many :disposals

  def count
    disposals_dataset.sum(:count) || 0
  end

  def to_hash
    super.merge(count: count)
  end
end

class Event < Sequel::Model
  many_to_many :bins
end

class Disposal < Sequel::Model
  many_to_one :bin
end

unless db_url
  # Create some models.
  Bin.create(name: 'BAhackaTacho')
end