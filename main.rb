#!/usr/bin/env ruby

require_relative "network"
require_relative "train"
require_relative "station"
require "colorize"

class Main

	def initialize

		@network = Network.new()

		ne = Station.new("Newport")
		ca = Station.new("Cardiff")
		cs = Station.new("Chipping Sodbury")
		gm = Station.new("Great Malvern")
		bad = Station.new("Badminton")
		br = Station.new("Bristol Temple Meads")
		ba = Station.new("Bath Spa")

		connect(ne, ca, 4.50)
		# connect(cs, ne)
		# connect(gm, cs)
		# connect(cs, bad)
		# connect(ba, br)
		# connect(br, ne)

		#@network.addstations([ca, ne, cs, gm, br, ba])
		@network.addstations([ca, ne])

		# Stop times for trains in seconds
		@min_stop = 1
		@max_stop = 5

		@thread_group = []
		bristolian = Train.new("Bristolian", 50, [ne, ca], @network)
		@network.addtrain(bristolian)
		@thread_group << add_train_thread(bristolian)

		# pullman = Train.new("Pullman", 20, [ca, ne, br], @network)
		# @network.addtrain(pullman)
		# @thread_group << add_train_thread(bristolian)

		# cotswolds = Train.new("Cotswolds and Malvern Express", 20, [gm, cs, bad], @network)
		# @network.addtrain(cotswolds)
		# @thread_group << add_train_thread(cotswolds)

		# devonian = Train.new("Devonian", 40, [ba, br], @network)
		# @network.addtrain(devonian)
		# @thread_group << add_train_thread(devonian)
		
		@min_arrive = 5
		@max_arrive = 20
		@min_depart = 0
		@max_depart = 2
	end

	def add_train_thread(train)

		Thread.new {

			local = train
			while(true) 
				local.action()
				sleep(rand(@min_stop..@max_stop))
			end
		}
	end

	def connect(a, b, cost)
		a.addpoint(b)
		b.addpoint(a)
		@network.add_fare(a, b, cost)
	end

	def debug_station(st) 
		puts "Station Debug: #{st.name}"
		st.connections.each_key do |name|
			puts "\tgoes to #{name}"
		end
	end

	def start()

		puts "Starting network simulator...\n"

		passengers = Thread.new {

			while(true) 
				puts "\n-- Station Passenger Modifications --\n"

				@network.stations.each_key do |name|

					# TODO: Weight these based on how long they wait eventually
					num_arriving = rand(@min_arrive..@max_arrive)
					num_depart = rand(@min_depart..@max_depart)

					puts "- #{name} - £#{'%.02f' % @network.stations[name].profit} profit:\t\t\t\n\tarrive:" + 
						" [#{num_arriving}]".colorize(:green) + 
						"\tleave: " + 
						"[#{num_depart}]".colorize(:red)

					@network.stations[name].add_people(num_arriving)
					@network.stations[name].remove_people(num_depart)
					puts "\tWaiting at station:" + "[#{@network.stations[name].people}]".colorize(:blue)
				end
\
				sleep(10)
			end
		}

		@thread_group << passengers

		@thread_group.each(&:join)

		# Add another thread for adding/removing passengers at station
	end

end

m = Main.new()
m.start()