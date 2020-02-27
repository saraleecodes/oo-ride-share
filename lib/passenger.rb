require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      costs = []
      @trips.each do |trip|
        costs << trip.cost unless trip.cost == nil
      end
      return costs.sum
    end

    def total_time_spent
      durations = []
      @trips.each do |trip|
        durations << trip.duration unless trip.end_time == nil
      end
      return durations.sum
      # calculating total amount of time in seconds.
    end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
