require_relative 'panda'

# Social network class for our panda friends.
class PandaSocialNetwork
  def initialize
    @pandas = {}
  end

  def add_panda(panda)
    if @pandas[panda]
      fail 'PandaAlreadyThere'
    else
      @pandas[panda] = []
    end
  end

  def has_panda(panda)
    @pandas[panda] ? true : false
  end

  def make_friends(panda1, panda2)
    add_panda(panda1) unless has_panda(panda1)
    add_panda(panda2) unless has_panda(panda2)

    if are_friends?(panda1, panda2)
      fail 'PandasAlreadyFriends'
    else
      @pandas[panda1] << panda2
      @pandas[panda2] << panda1
    end
  end

  def are_friends(panda1, panda2)
    return true if @pandas[panda1].include? panda2
    false
  end

  def friends_of(panda)
    has_panda?(panda) ? @pandas[panda] : false
  end

  def connection_level(panda1, panda2)
    return false unless has_panda(panda1) && has_panda(panda2)
    queue = [panda1]
    checked = []
    level = 1

    until queue.empty?
      last = queue
      queue = []
      last.each do |panda|
        checked << panda unless checked.include? panda
        queue.push(*@pandas[panda])
      end
      return level if queue.include? panda2
      level += 1
    end
    -1
  end

  def are_connected(panda1, panda2)
    connection = connection_level(panda1, panda2) || 0
    if connection > 0
      return true
    else
      return false
    end
  end

  def how_many_gender_in_network(level, panda, gender)
  end
end

network = PandaSocialNetwork.new

ivo = Panda.new('Ivo', 'ivo@pandamail.com', 'male')
rado = Panda.new('Rado', 'rado@pandamail.com', 'male')
tony = Panda.new('Tony', 'tony@pandamail.com', 'female')

network.add_panda(ivo)
network.add_panda(rado)
network.add_panda(tony)

network.make_friends(ivo, rado)
network.make_friends(rado, tony)

p network.connection_level(ivo, rado) # true
p network.connection_level(ivo, tony) # true

p network.how_many_gender_in_network(1, rado, 'female') == 1 # true
