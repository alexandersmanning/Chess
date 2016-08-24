class Player 
	attr_accessor :color, :name
	def initialize(color)
		@color = color 
	end 

	def get_name 
		puts "Please enter your name:"
		@name = gets.chomp.scan(/.{1,25}/).first
	end 

	def get_move 
		begin 
			input = gets.chomp.scan(/\d/).first(2)
			raise if input.count < 2
		rescue 
			puts "you must enter a valid set of coordinates"
			retry 
		end 

		input.map(&:to_i)
	end 
end 