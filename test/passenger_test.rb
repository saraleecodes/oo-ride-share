require_relative 'test_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end

    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end

      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
        @driver = RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE
        )
      trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5
        )

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end

  describe "net_expenditures and total_time_spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
        )
      @driver = RideShare::Driver.new(
        id: 54,
        name: "Test Driver",
        vin: "12345678901234567",
        status: :AVAILABLE
      )
      trip_1 = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 5.68,
        rating: 5
        
        )
      @passenger.add_trip(trip_1)

      trip_2 = RideShare::Trip.new(
        id: 10,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 11.79,
        rating: 5
        )
      @passenger.add_trip(trip_2)
    end
    
    it "returns 0 if the passenger has no trips" do
    new_passenger = RideShare::Passenger.new(
      id: 10,
      name: "Mx. No Trips",
      phone_number: "1-602-620-2330 x3723",
      trips: []
      )
      expect(new_passenger.net_expenditures).must_equal 0
      expect(new_passenger.total_time_spent).must_equal 0
    end

    it "returns a sum of all the trip costs" do
      expect(@passenger.net_expenditures).must_equal 17.47
    end

    it "does not include any in-progress trip for net expenditures" do
      trip3 = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger_id: 3,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      )
      @passenger.add_trip(trip3)
      expect(@passenger.net_expenditures).must_equal 17.47
    end

    it "returns the total time spent in trips in seconds" do
      expect(@passenger.total_time_spent).must_equal 172800
    end

    it "does not include any in-progress trip for total time spent" do
      trip3 = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger_id: 3,
        start_time: Time.now,
        end_time: nil,
        cost: nil,
        rating: nil
      )
      @passenger.add_trip(trip3)
      expect(@passenger.total_time_spent).must_equal 172800
    end
  end
end
