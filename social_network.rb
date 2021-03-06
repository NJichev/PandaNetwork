require_relative 'panda'
require 'set'

# Social network class for our panda friends.
class PandaSocialNetwork
  attr_reader :pandas

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

    if are_friends(panda1, panda2)
      fail 'PandasAlreadyFriends'
    else
      @pandas[panda1] << panda2
      @pandas[panda2] << panda1
    end
  end

  def are_friends(panda1, panda2)
    @pandas[panda1].include? panda2
  end

  def friends_of(panda)
    has_panda?(panda) ? @pandas[panda] : false
  end

  def connections(panda1)
    return false unless has_panda(panda1)
    checked = Set.new
    queue = [panda1]
    checked << panda1
    level = 1

    Enumerator.new do |e|
      until queue.empty?
        last = queue
        queue = []
        last.each do |panda|
          @pandas[panda].each do |p|
            unless last.include?(p) || checked.include?(p)
              queue << p
              checked << p
            end
          end
          checked << panda
        end

        e << [level, queue]
        level += 1
      end
    end
  end

  def connection_level(panda1, panda2)
    return false unless has_panda(panda1) && has_panda(panda2)
    conn_level = -1
    panda1_friends = connections(panda1)

    loop do
      level, friends  = panda1_friends.next
      conn_level = level if friends.include? panda2

      break if friends.empty?
    end

    return conn_level
  end

  def are_connected(panda1, panda2)
    connection = connection_level(panda1, panda2) || 0
    if connection > 0
      return true
    else
      return false
    end
  end

  def how_many_gender_in_network(conn_level, panda, gender)
    is_gender = (gender + '?').to_s
    count_of_gender_friends = 0
    friends_level = connections(panda)

    loop do
      level, friends = friends_level.next
      count_of_gender_friends += friends.count { |f| f.send is_gender }
      break if friends.empty? || level >= conn_level
    end

    count_of_gender_friends
  end

  def save(file_name)
    file = File.new("#{file_name}.txt", "w")
    @pandas.each_with_index do |(panda, friends), index|
      file.write "#{panda.to_s}"
      friends.each{ |friend| file.write " #{friend.email}" }
      file.puts if index < @pandas.length-1
    end
    file.close
  end

  def self.load(file_name)
    file = File.new("#{file_name}.txt", "r")
    network = PandaSocialNetwork.new
    panda_objs = []
    panda_friends = []
    
    file.each_line do |line|
        info = line.split
        panda_objs << Panda.new(info[0], info[1], info[2])
        panda_friends << info[3..info.size]
    end

    panda_objs.each { |panda| network.add_panda(panda) }

    panda_friends.each_with_index do |friends, index|
      unless friends.empty?
        friends.each do |friend_email|
          panda_objs.each do |panda|
            if panda.email == friend_email
              network.make_friends(panda_objs[index], panda) unless network.are_friends(panda_objs[index], panda)
              break
            end
          end
        end
      end
    end

    file.close
    network
  end
end

# network = PandaSocialNetwork.new
# 
# ivo = Panda.new('Ivo', 'ivo@pandamail.com', 'male')
# rado = Panda.new('Rado', 'rado@pandamail.com', 'male')
# tony = Panda.new('Tony', 'tony@pandamail.com', 'female')
# pesho = Panda.new('Pesho', 'peshomail.com', 'male')
# forever_alone = Panda.new('Alone:(', 'alone@mail.com', 'male')
# 
# network.add_panda(ivo)
# network.add_panda(rado)
# network.add_panda(tony)
# network.add_panda(pesho)
# network.add_panda(forever_alone)
# 
# network.make_friends(ivo, rado)
# network.make_friends(rado, tony)
# network.make_friends(rado, pesho)
# network.make_friends(ivo, pesho)
# network.make_friends(tony, pesho)
# 
# p network.connection_level(ivo, rado)
# p network.connection_level(ivo, tony)
# p network.connection_level(ivo, forever_alone)
 
# enum = network.connections(rado)
# p enum.next
# p enum.next
# p enum.next
#
# p how_many_gender_in_network(2, tony, 'male') == 3 #true
#
# network.save("social_network_save_file")
# 
# network_from_file = PandaSocialNetwork.load("social_network_save_file")
# 
# first = nil
# network_from_file.pandas.each_key { |panda| first = panda; break; }
# network_from_file.pandas.each_key do |panda|
#     puts "conn_lvl(#{first.name}, #{panda.name}): #{network_from_file.connection_level(first, panda)}"
# end
