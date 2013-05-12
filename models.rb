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
    String :description, text: true
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

  def count
    bins.map(&:count).inject(0, :+)
  end

  def to_hash
    super.merge(count: count)
  end
end

class Disposal < Sequel::Model
  many_to_one :bin
end

unless db_url
  # Create some models.
  5.times { |n| Bin.create(name: "Tacho #{n + 1}") }
  e = Event.create(name: 'BAHackaton', description: 'Hackaton de Buenos Aires')
  e.add_bin(Bin[2])
  e.add_bin(Bin[4])
  3.times { Disposal.create(bin: Bin[2], count: 1, created_at: Time.now) }
end