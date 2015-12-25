#!/usr/bin/env ruby

require_relative "fare"

class Network

	attr_accessor :trains, :stations, :fares

	DEBUG = false
	
	def initialize()

		@stations = {}
		@trains = {}
		@fares = []
	end

	def addstation(s)

		@stations[s.name] = s
	end

	def addstations(stations)
		stations.each do |s|
			@stations[s.name] = s
		end
	end

	def add_fare(a, b, cost)

		# Need to add both ways
		@fares << Fare.new(a, b, cost)
		@fares << Fare.new(b, a, cost)
		puts "Added: #{a.name} to #{b.name} both ways @ #{cost}"
	end

	def get_fare(origin, destination) 
		@fares.each do |f|
			if f.origin.name.eql? origin.name and f.destination.name.eql? destination.name
				puts "Cost is: #{f.cost} for #{origin.name} - #{destination.name}" if DEBUG
				return f.cost
			end
		end
		raise "Could not find fare for: #{origin.name} #{destination.name}"
	end

	def addtrain(t)

		if (validate(t))
			@trains[t.name] = t
		else
			raise "Train route not valid"
		end
	end

	# Validate the trains
	def validate(train)

		num_points = train.points.size
		name = train.points[0].name
		route_station = @stations[name]
		puts "Validating #{train.name}: \n\tInitial: #{route_station.name}, num_points: #{num_points}"

		# Get all remaining points and validate they connect up
		other_points = train.points[1..num_points]
		
		other_points.each do |p|
			valid_connections = route_station.connections

			if !valid_connections.keys.include? p.name
				puts "\tWARN: Could not find next connection for: #{p.name}"
			else
				puts "\tValid: #{p.name}"
			end
			route_station = p
		end

	end
end