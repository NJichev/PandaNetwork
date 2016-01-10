# Panda class for our social network.
class Panda
  attr_reader :name, :email, :gender

  def initialize(name, email, gender)
    @name = name
    @email = email
    @gender = gender
  end

  def male?
    gender == 'male'
  end

  def female?
    gender == 'female'
  end

  def ==(other)
    name == other.name &&
      email == other.email &&
      gender == other.gender
  end

  def hash
    to_s.hash
  end

  def to_s
    "#{name} #{email} #{gender}"
  end

  alias_method :==, :eql?
end
