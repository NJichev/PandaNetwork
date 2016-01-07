requre_relative 'panda.rb'

class PandaSocialNetwork
  def initialize
    @pandas = {}
  end

  def add_panda(panda)
    if @pandas[panda]
      raise "PandaAlreadyThere"
    else
      @pandas[panda] = []
    end
  end

  def has_panda?(panda)
    @pandas[panda] ? true : false
  end

  def make_friends(panda1, panda2)
    add_panda(panda1) unless has_panda?(panda1)
    add_panda(panda2) unless has_panda?(panda2)

    if are_friends?(panda1, panda2)
      raise "PandasAlreadyFriends"
    else
      @pandas[panda1] << panda2
      @pandas[panda2] << panda1
    end
  end

  def are_friends?(panda1, panda2)
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

    while not queue.empty?
      last = queue
      checked.push(*queue)
      last.each do |element|
        queue.push element unless checked.include? element
      end

      level += 1
      return level if queue.include? panda2 
    end
    return -1
  end
  
  def are_connected(panda1, panda2)
    connection = connection_level(panda1, panda2) || 0
    if connection >= 1
      return true
    else
      return false
    end
  end
end
