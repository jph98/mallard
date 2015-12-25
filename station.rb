#!/usr/bin/env ruby

class Station

	attr_accessor :name, :connections, :people, :profit

	def initialize(name)
		@name = name
		@connections = {}
		@people = 0
		@profit = 0.0
	end

	def addpoint(station)
		@connections[station.name] = station
	end

	def add_people(num)
		@people += num
	end

	def remove_people(num) 
		if @people - num > 0
			@people -= num
		else
			@people = 0
		end
	end

	def remove_by_destination(destination)

		@people.delete_if do |p|
			p.destination.eql? destination
		end
	end

	def to_s
		return @name + ", no conns: " + @connections.size.to_s
	end

end