#!/usr/bin/env ruby

class Fare

	attr_accessor :origin, :destination, :cost

	def initialize(origin, destination, cost)
		@origin = origin
		@destination = destination
		@cost = cost
	end
end