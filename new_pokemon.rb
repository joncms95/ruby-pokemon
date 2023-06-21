#     Simple Pokémon Game in Ruby
#     --------------------------------------------------------------------------
#     1. Player 1 (p1) will choose one Pokémon from the list of Pokémons.
#     2. Player 2 (p2) will randomly pick one of the leftover Pokémons.
#     3. A battle simulation will be done between p1's Pokémon and p2's Pokémon.
#     --------------------------------------------------------------------------

# Classes
class Pokemon
  attr_accessor :name, :hp, :attack, :attack_multiplier, :defense_multiplier, :stun_status, :skill_rng

  def initialize(name, hp, attack, skill_rng) test
    @name = name
    @hp = hp
    @attack = attack
    @attack_multiplier = 1.0
    @defense_multiplier = 1.0
    @attack_status = true
    @stun_status = 0
    @skill_rng = skill_rng
    @skill_counter = 0
  end

  def hit(opponent)
    if @skill_counter > 0
      use_skill(opponent)
    elsif rand <= skill_rng
      use_skill(opponent)
    end

    return unless @attack_status == true && @stun_status == 0

    critical_hit?
    damage = (@attack * @attack_multiplier * opponent.defense_multiplier)
    puts "#{@name} attacks #{opponent.name} and deals #{damage} damage!"
    opponent.hp -= damage
  end

  def alive?
    @hp > 0
  end

  def critical_hit?
    return unless rand <= 0.05

    @attack_multiplier = 2.0
    print "It's a critical hit! "
  end

  def reset_status
    @attack_status = true
    @attack_multiplier = 1.0
    @stun_status -= 1 if @stun_status > 0
  end
end

class Bulbasaur < Pokemon
  def initialize
    super('Bulbasaur', 100.0, 10.0, 0.1)
  end

  def use_skill(opponent)
    if @skill_counter > 0
      leech_seed(opponent)
    else # initial hydration
      @skill_counter = 5
      puts 'Bulbasaur casts Leech Seed! Bulbasaur will draw 5 hp per turn. (Last for 5 turns)'
      leech_seed(opponent)
    end
  end

  def leech_seed(opponent)
    critical_hit?
    @skill_damage = (5 * @attack_multiplier * opponent.defense_multiplier)
    self.hp += @skill_damage
    opponent.hp -= @skill_damage
    @skill_counter -= 1
    @attack_multiplier = 1.0
    puts "Leech Seed! Bulbasaur draws #{@skill_damage} hp from #{opponent.name}. (Turns left: #{@skill_counter})"
  end
end

class Charmander < Pokemon
  def initialize
    super('Charmandar', 90.0, 12.0, 0.2)
  end

  def use_skill(opponent)
    ember(opponent)
    puts "#{name} casts Ember! #{name} burns #{opponent.name} and deals #{@skill_damage} damage."
  end

  def ember(opponent)
    critical_hit?
    @skill_damage = ((attack * 2) * @attack_multiplier * opponent.defense_multiplier)
    opponent.hp -= @skill_damage
    @attack_multiplier = 1.0
  end
end

class Snorlax < Pokemon
  def initialize
    super('Snorlax', 200.0, 5.0, 0.1)
  end

  def use_skill(_opponent = nil)
    if @skill_counter > 0
      puts "#{name} is still resting... (Turns left: #{@skill_counter})"
      @skill_counter -= 1
    else # initial hydration
      @skill_counter = 2
      rest
      puts "#{name} Rests! #{name} restore 50 hp but will sleep for 2 turns."
      @skill_counter -= 1
    end
  end

  def rest
    self.hp += 50
    @attack_status = false
  end

  def reset_status
    super if @skill_counter == 0
  end
end

class Squirtle < Pokemon
  def initialize
    super('Squirtle', 120.0, 9.0, 0.2)
  end

  def use_skill(_opponent = nil)
    if @skill_counter > 0
      puts "#{name} has Iron Defense... (Turns left: #{@skill_counter})"
      @skill_counter -= 1
    else # initial hydration
      @skill_counter = 3
      iron_defense
      puts "#{name} casts Iron Defense! #{name} will only receive 50% damage for 3 turns."
      @skill_counter -= 1
    end
  end

  def iron_defense
    self.defense_multiplier = 0.5
  end

  def reset_status
    super
    self.defense_multiplier = 1.0 if @skill_counter == 0
  end
end

class Pikachu < Pokemon
  def initialize
    super('Pikachu', 90.0, 12.0, 0.1)
  end

  def use_skill(opponent)
    thunderbolt(opponent)
    puts "#{name} casts Thunderbolt! #{name} deals #{@skill_damage} to #{opponent.name} and paralyzed him for 1 turn."
  end

  def thunderbolt(opponent)
    critical_hit?
    @skill_damage = ((attack * 2) * @attack_multiplier * opponent.defense_multiplier)
    opponent.hp -= @skill_damage
    opponent.stun_status = 1
    @attack_multiplier = 1.0
  end
end

# Battle
def battle(p1, p2)
  while p1.alive? && p2.alive?
    p1.hit(p2)
    p2.hit(p1)
    p1.reset_status
    p2.reset_status
    p1.hp = 0 if p1.hp < 0
    p2.hp = 0 if p2.hp < 0
    puts "Your HP: #{p1.hp} / Opponent HP: #{p2.hp}"
    puts
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
  p.each_with_index { |x, i| puts "Player #{i + 1}: #{x.name}, HP: #{x.hp}, Attack: #{x.attack}" }
end

# List of Pokémon
pokemons = [
  bulbasaur = Bulbasaur.new,
  charmander = Charmander.new,
  snorlax = Snorlax.new,
  squirtle = Squirtle.new,
  pikachu = Pikachu.new
]

# Player chooses a starting Pokémon
puts 'Choose your starting Pokémon: (You can only randomly choose Pikachu)'
pokemons.each_with_index { |pokemon, i| puts " #{i + 1}) #{pokemon.name}" }
puts "Please insert your Pokémon's index! (Press enter to random)"
choice = gets.chomp

p1 =
  case choice
  when '1' then bulbasaur
  when '2' then charmander
  when '3' then snorlax
  when '4' then squirtle
  when ''
    puts 'You randomly chose a Pokémon'
    pokemons.sample
  else
    puts 'Invalid choice, you will be given a random Pokémon.'
    pokemons.sample
  end

pokemons.delete(p1)

p2 = pokemons.sample  # Randomly select opponent Pokémon

puts "You chose #{p1.name}!"
puts "Your rival chose #{p2.name}!"

puts '============================================'
puts "POKEMONS' INFO"
show_info(p1, p2)
puts '============================================'

puts "LET'S BATTLE!\n .\n ..\n ..."
battle(p1, p2)
