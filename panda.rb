class Panda

	attr_reader :name, :email, :gender

	def initialize(name, email, gender)
		@name = name
		@email = email
		@gender = gender
	}

	def male?
		gender == "male"
 	end

 	def female?
 		gender == "female"
 	end

 	def ==(other)
 		if (name == other.name) and (email == other.email) and (gender == other.gender)
 			true
 		else false
 	end

 	def hash
 		to_s.hash
 	end

 	def to_s
 		"#{name} #{email} #{gender}"
 	end

 	#h[p]=1



}
