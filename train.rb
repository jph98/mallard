#!/usr/bin/env ruby

require_relative "passenger"

class Train

	attr_accessor :name, :points, :current, :passengers

	DEBUG = false
	FORWARD = "forward"
	BACKWARD = "backward"

	def initialize(name, capacity, points, network)

		@names = File.readlines("names.txt")
		puts "Read: #{@names.length}"
		@name = name
		@points = points
		@profit = 0
		@passengers = []
		@capacity = capacity
		@current = points[0] # List of stations with first one selected
		@direction = FORWARD # Direction the train is travelling in
		@network = network
	end

	def action()
		
		dropoff, pickup = handle_passengers()

		next_station = get_next_location()

		sleep(1)
		interval = rand(1..5)
		sleep(interval)
		puts "\n-- Train: #{@name} --" + 
				"\n\tcarrying " + "#{@passengers.size()}".colorize(:blue) + " passengers " +
				"\n\tCurrent Location: #{@current.name}" + 
				"\n\tDestination: #{next_station.name}" +
				"\n\tStart of Line: #{start_of_the_line(next_station.name)}" + 
				"\n\tEnd of Line: #{end_of_the_line(next_station.name)}" + 
				"\n\tTime for stop: #{interval} secs\n"
		@current = next_station
	end

	def handle_passengers()
		
		puts "\n-- Passenger boarding/dropoff --"
		avail_space = @capacity - @passengers.size()

		# TODO: Handle passenger destinations
		# Only add passengers that arrive and board the train

		dropoff = 0
		total_made = 0
		@passengers.each do |p|

			if p.destination.name.eql? @current.name
				paid = @network.get_fare(p.origin, p.destination)
				@current.profit += paid
				total_made += paid
				@passengers.delete(p)
				dropoff += 1
			end
		end

		if dropoff > 0
			puts "\t#{dropoff} passengers dropped off, made £#{'%.02f' % total_made}"
		end

		# Pickup
		pickup = 0

		if @current.people >= avail_space
			@current.people -= avail_space
			pickup = avail_space
		elsif @current.people <= avail_space
			pickup = @current.people
			@current.people = 0
		end

		if pickup > 0
			puts "\t#{pickup} passengers boarding train"
		end

		pickup.times do
			destination = get_random_destination(@current)
			name = get_random_name()
			@passengers << Passenger.new(name, @current, destination)
			puts "Added passenger: #{name} going from #{current.name} to #{destination}" if DEBUG
		end

		puts "\n"

		return dropoff, pickup
	end

	def get_random_destination(origin)

		points_to_chose = @points.dup()
		points_to_chose.delete origin
		
		max = points_to_chose.length - 1
		destination = points_to_chose[rand(0..max)]
		return destination
	end

	def get_random_name
		return @names[rand(0..@names.length)]
	end

	def start_of_the_line(name)

		@points.each_with_index do |p,i|
			pos = i + 1
			if p.name.eql? name and pos.eql? 1
				return true
			end
		end
		return false
	end

	def end_of_the_line(name)

		@points.each_with_index do |p,i|
			pos = i+1
			if p.name.eql? name and pos.eql? @points.length
				return true
			end
		end
		return false
	end


	def get_next_location()

		forward = @direction.eql? FORWARD
		backward = @direction.eql? BACKWARD

		@points.each_with_index do |p,i|

			name_match = p.name.eql? @current.name
			pos = i+1

			puts "name: #{p.name} name_match: #{name_match} pos: #{pos}, @points.length: #{@points.length}, direction #{@direction}" if DEBUG
			if name_match and forward and !pos.eql? @points.length
				puts "Forward, not at end" if DEBUG
			 	return @points[i+1]
			elsif name_match and backward and !pos.eql? 0
				puts "Backward, not at end" if DEBUG
			 	return @points[i-1]
			elsif name_match and forward and pos.eql? @points.length
				puts "Forward, END" if DEBUG
				direction = BACKWARD
			 	return @points[i-1]
			elsif name_match and backward and pos.eql? 0
			 	direction = FORWARD
			 	puts "Backward, END" if DEBUG
			 	return @points[i+1]
			end
		end
	end

	def to_s
		return "#{@name} - route size: #{@points.size}\n\t\tLocation: #{@current.name}"
	end

end