# Requiring JSON to manipulate JSON format
require 'json'

input = {
  "listings": [
    { "id": 1, "num_rooms": 2 },
    { "id": 2, "num_rooms": 1 },
    { "id": 3, "num_rooms": 3 }
  ],
  "bookings": [
    { "id": 1, "listing_id": 1, "start_date": "2016-10-10", "end_date": "2016-10-15" },
    { "id": 2, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
    { "id": 3, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-20" }
  ],
  "reservations": [
    { "id": 1, "listing_id": 1, "start_date": "2016-10-11", "end_date": "2016-10-13" },
    { "id": 1, "listing_id": 1, "start_date": "2016-10-13", "end_date": "2016-10-15" },
    { "id": 1, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
    { "id": 3, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-18" }
  ]
}

input2 = {
  "listings": [
    { "id": 1, "num_rooms": 2 },
    { "id": 2, "num_rooms": 1 },
    { "id": 3, "num_rooms": 3 }
  ],
  "bookings": [
    { "id": 1, "listing_id": 1, "start_date": "2016-10-10", "end_date": "2016-10-15" },
    { "id": 2, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
    { "id": 3, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-20" }
  ],
  "reservations": [
    { "id": 1, "listing_id": 1, "start_date": "2016-10-11", "end_date": "2016-10-20" },
    { "id": 2, "listing_id": 1, "start_date": "2016-10-13", "end_date": "2016-10-15" },
    { "id": 3, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
    { "id": 4, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-18" }
  ]
}

input3 = {}

input4 = {
  "listings": [
    { "id": 1, "num_rooms": 2 },
    { "id": 2, "num_rooms": 1 },
    { "id": 3, "num_rooms": 3 }
  ],
  "bookings": [
    { "id": 1, "listing_id": 1, "start_date": "2016-10-10", "end_date": "2016-10-15" },
    { "id": 2, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
    { "id": 3, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-20" }
  ],
  "reservations": [
  ]
}

input5 = {
  "listings": [
    { "id": 1, "num_rooms": 2 },
    { "id": 2, "num_rooms": 1 },
    { "id": 3, "num_rooms": 3 }
  ],
  "bookings": [
  ],
  "reservations": [
    { "id": 1, "listing_id": 1, "start_date": "2016-10-11", "end_date": "2016-10-20" },
    { "id": 2, "listing_id": 1, "start_date": "2016-10-13", "end_date": "2016-10-15" },
    { "id": 3, "listing_id": 1, "start_date": "2016-10-16", "end_date": "2016-10-20" },
    { "id": 4, "listing_id": 2, "start_date": "2016-10-15", "end_date": "2016-10-18" }
  ]
}

def handle_cleanings(input)
  # Create an empty object
  # Return if bookings is empty
  # For each booking, create a mission
  # Get the number of rooms of the listing in a variable
  # Create a mission for the start date: 10€ * room
  # Create a mission for the end date: 5€ * room
  # For each reservation
  # Get the number of rooms of the listing in a variable
  # Get the end date of the booking in a variable
  # Create a mission if end_date different from booking end_date
  # Return object

  # Testing if input is nil
  if input[:bookings].nil?
    return {:missions => [] }.to_json
  else

    # Local variables for better readability
    listings = input[:listings]
    bookings = input[:bookings]
    reservations = input[:reservations]

    # Declaring the empty array for all missions
    missions = []

    # Each loop going through all bookings
    bookings.each do |booking|
      # Retrieving the listing associated with the booking
      listing = listings.detect { |listing| listing[:id] == booking[:listing_id] }
      # Storing the number of rooms in a variable
      number_rooms = listing[:num_rooms]
      # Creating the mission object for the checkin and checkout
      mission_checkin = {:listing_id=>listing[:id], :mission_type=>"first_checkin", :date=>booking[:start_date], :price=>number_rooms*10}
      mission_checkout = {:listing_id=>listing[:id], :mission_type=>"last_checkout", :date=>booking[:end_date], :price=>number_rooms*5}
      # Pushing the missions created into the result array
      missions.push(mission_checkin, mission_checkout)
    end

    # Each loop going through all reservations
    reservations.each do |reservation|
      # Retrieving the listing associated with the booking
      listing = listings.detect { |listing| listing[:id] == reservation[:listing_id] }
      # Storing the number of rooms in a variable
      number_rooms = listing[:num_rooms]
      # Declaring a local variable to test if the end date of the booking and reservation is the same
      same_end_date = false
      # Retrieving all the bookings associated with the reservation
      bookings_reservation = bookings.select { |booking| booking[:listing_id] == reservation[:listing_id] }
      # Each loop to go through all bookings with the same listing id as reservation
      bookings_reservation.each do |booking_reservation|
        # Change the variable to true and break the loop if found any matching end_date
        if booking_reservation[:end_date] == reservation[:end_date]
          same_end_date = true
          break
        end
      end
       # Test the end_date and add a new mission only if the end_date is not the same
      if !same_end_date
        mission_checkout_checkin = {:listing_id=>listing[:id], :mission_type=>"checkout_checkin", :date=>reservation[:end_date], :price=>number_rooms*10}
        missions.push(mission_checkout_checkin)
      end
    end

    # Return the all the missions in a JSON format
    return {:missions => missions }.to_json

  end

end

p handle_cleanings(input)
p handle_cleanings(input2)
p handle_cleanings(input3)
p handle_cleanings(input4)
p handle_cleanings(input5)
