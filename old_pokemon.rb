#     Simple Pokémon Game in Ruby
#     --------------------------------------------------------------------------
#     1. Player 1 (p1) will choose one Pokémon from the list of Pokémons.
#     2. Player 2 (p2) will randomly pick one of the leftover Pokémons.
#     3. A battle simulation will be done between p1's Pokémon and p2's Pokémon.
#     --------------------------------------------------------------------------

class Pokemon
  attr_accessor :name, :evolved, :ultimate_evolved, :type, :hp, :power, :strength, :weakness

  def initialize(name, evolved, ultimate_evolved, type, hp, power, strength, weakness)
    self.name = name
    self.evolved = evolved
    self.ultimate_evolved = ultimate_evolved
    self.type = type
    self.hp = hp
    self.power = power
    self.strength = strength
    self.weakness = weakness
  end

  def attack(opponent)
    damage = rand(1..power)
    if opponent.type == strength
      damage *= 2  # Double damage against your strength type
      puts "#{name} attacks #{opponent.name} and deals #{damage} damage!\nIt's super effective!"
    elsif opponent.type == weakness
      damage /= 2  # Half damage against your weakness type
      puts "#{name} attacks #{opponent.name} and deals #{damage} damage!\nIt's not very effective..."
    end
    opponent.hp -= damage
  end

  def alive?
    hp > 0
  end

  def evolved?
    hp > 50 || power > 20
  end

  def ultimate_evolved?
    hp > 50 && power > 20
  end
end

def battle(p1, p2)
  while p1.alive? && p2.alive?
    p1.attack(p2)
    p2.attack(p1)
    p1.hp = 0 if p1.hp < 0
    p2.hp = 0 if p2.hp < 0
    puts "Your HP: #{p1.hp} / Opponent HP: #{p2.hp}"
  end

  if p1.alive?
    puts "...\n#{p1.name} has beaten #{p2.name}.\nYou win!"
  elsif p2.alive?
    puts "...\n#{p1.name} has lost to #{p2.name}.\nYou lose!"
  else
    puts "It's a draw!"
  end
end

def show_info(*p)
  p.each_with_index { |x, i| puts "Player #{i + 1}: #{x.name}, HP: #{x.hp}, Power: #{x.power}" }
end

def is_evolve?(*p)
  p.each do |pokemon|
    child = pokemon.name
    if pokemon.ultimate_evolved?
      pokemon.name = pokemon.ultimate_evolved
      puts "!!!\nWhat's happening? It seems like #{child} has evolved to #{pokemon.name}!"
    elsif pokemon.evolved?
      pokemon.name = pokemon.evolved
      puts "!!!\nWhat's happening? It seems like #{child} has evolved to #{pokemon.name}!"
    end
  end
end

# List of Pokemon
pokemons = [
  # bulbasaur = Pokemon.new('Bulbasaur', 'Ivysaur', 'Venusaur' 'Grass', 20+rand(100), 10+rand(20), 'Water', 'Fire'),
  # charmander = Pokemon.new('Charmander', 'Charmeleon', 'Charizard', 'Fire', 20+rand(100), 10+rand(20), 'Grass', 'Water'),
  # squirtle = Pokemon.new('Squirtle', 'Wartortle', 'Blastoise', 'Water', 20+rand(100), 10+rand(20), 'Fire', 'Grass')

  # test evolve function
  bulbasaur = Pokemon.new('Bulbasaur', 'Ivysaur', 'Venusaur', 'Grass', 51, 21, 'Water', 'Fire'),
  charmander = Pokemon.new('Charmander', 'Charmeleon', 'Charizard', 'Fire', 20, 21, 'Grass', 'Water'),
  squirtle = Pokemon.new('Squirtle', 'Wartortle', 'Blastoise', 'Water', 10, 10, 'Fire', 'Grass')
]

# Player chooses a starting Pokemon
puts 'Choose your starting Pokemon:'
pokemons.each_with_index { |pokemon, i| puts " #{i + 1}) #{pokemon.name}" }
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

is_evolve?(p1, p2)

puts '============='
puts 'POKEMONS INFO'
show_info(p1, p2)
puts '============='

puts "LET'S BATTLE!\n .\n ..\n ..."
battle(p1, p2)
