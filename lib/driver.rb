require_relative 'csv_record'

module RideShare
  class Driver < CsvRecord
    attr_reader :name, :vin, :status, :trips
    attr_writer :status

    def initialize(id:, name:, vin:, status: :AVAILABLE, trips: nil)
      super(id)

			raise ArgumentError.new("Driver status is not valid") unless %i[AVAILABLE UNAVAILABLE].include?(status)
      raise ArgumentError.new("VIN must be at least 17 characters") unless vin.length == 17
      raise ArgumentError.new("Invalid driver ID") unless id > 0

      @name = name
			@vin = vin
			@status = status
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def start_trip(trip)
      @status = :UNAVAILABLE
      add_trip(trip)
    end

    def average_rating
			ratings = []
			@trips.each do |trip|
				ratings << trip.rating unless trip.rating.nil?
			end
			return @trips.length == 0 ? 0 : (ratings.sum / ratings.length).to_f.round(1)
	  end

    def total_revenue
      return 0 if @trips.length == 0
      return @trips.sum { |trip| trip.cost.nil? ? 0 : ((trip.cost - 1.65)* 0.8) }.round(2)
    end

    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
				vin: record[:vin],
				status: record[:status].to_sym
      )
    end
  end
end
