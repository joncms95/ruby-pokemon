#     Simple Pokemon Game in Ruby
#
#     1. Player 1 (p1) will choose one pokemon from the list of pokemons
#     2. Player 2 (p2) will randomly pick one of the leftover pokemons
#     3. A battle simulation will be done between the p1's pokemon and p2's pokemon


class Pokemon
  attr_accessor :name, :type, :hp, :power, :strength, :weakness

  def initialize(name, type, hp, power, strength, weakness)
    @name = name
    @type = type
    @hp = hp
    @power = power
    @strength = strength
    @weakness = weakness
  end

  def attack(opponent)
    damage = rand(1..power)
    if opponent.type == strength
      damage *= 2  # Double damage against weakness
      puts "It's super effective!"
    elsif opponent.type == weakness
      damage /= 2  # Half damage against strength
      puts "It's not very effective..."
    end
    opponent.hp -= damage
    puts "#{name} attacks #{opponent.name} and deals #{damage} damage!"
  end

  def alive?
    hp > 0
  end

  def to_s
    @name
  end
end

def battle(p1, p2)
  while p1.alive? && p2.alive?
    p1.attack(p2)
    p2.attack(p1)
    if p1.hp < 0
      p1.hp = 0
    elsif p2.hp < 0
      p2.hp = 0
    end
    puts "Your HP: #{p1.hp} / opponent HP: #{p2.hp}"
  end

  if p1.alive?
    puts 'You win!'
  elsif p2.alive?
    puts 'You lose!'
  else
    puts "It's a draw!"
  end
end

  def show_info(*p)
    p.each_with_index {|x, i| puts "Player #{i + 1}: #{x.name}, HP: #{x.hp}, Power: #{x.power}"}
  end

# List of Pokemon
pokemons = [
  bulbasaur = Pokemon.new('Bulbasaur', 'Grass', rand(20..119), rand(10..29), 'Water', 'Fire'),
  charmander = Pokemon.new('Charmander', 'Fire', rand(20..119), rand(10..29), 'Grass', 'Water'),
  squirtle = Pokemon.new('Squirtle', 'Water', rand(20..119), rand(10..29), 'Fire', 'Grass')
]

# Player chooses a starting Pokemon
puts 'Choose your starting Pokemon:'
pokemons.each_with_index { |pokemon, i| puts " #{i + 1}) #{pokemon}" }
puts "Please insert your Pokemon's index!"
choice = gets.chomp.to_i

p1 =
  case choice
  when 1 then bulbasaur
  when 2 then charmander
  when 3 then squirtle
  else
    puts 'Invalid choice. Defaulting to Bulbasaur.'
    bulbasaur
  end

pokemons.delete(p1)

p2 = pokemons.sample  # Randomly select opponent Pokemon

puts "You chose #{p1.name}!"
puts "Your rival chose #{p2.name}!"
puts "============="
puts 'PLAYERS INFO'
show_info(p1, p2)
puts "============="

puts "LET'S BATTLE!\n .\n ..\n ..."
battle(p1, p2)
