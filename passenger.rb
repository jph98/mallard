#!/usr/bin/env ruby

class Passenger

	attr_accessor :name, :origin, :destination, :arrivaltime

	def initialize(name, origin, destination)
		@name = name
		@origin = origin
		@destination = destination
	end
end