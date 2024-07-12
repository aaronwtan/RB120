# Consider the following code:
class Pet
  attr_reader :type, :name

  def initialize(type, name)
    @type = type
    @name = name
  end

  def to_s
    "a #{type} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end

  def number_of_pets
    pets.size
  end
end

class Shelter
  attr_reader :name, :owners
  attr_accessor :pets

  def initialize(name)
    @name = name
    @owners = []
    @pets = []
  end

  def add_pets(pets)
    if pets.is_a?(Array)
      self.pets += pets
    else
      pets << pet
    end
  end

  def number_of_pets
    pets.size
  end

  def adopt(owner, pet)
    owners << owner unless owners.include?(owner)
    owner.pets << pets.delete(pet)
    puts "#{owner.name} adopted #{pet}!"
  end

  def print_adoptions
    owners.each do |owner|
      puts "#{owner.name} has adopted the following pets:"
      puts owner.pets
      puts ''
    end
  end

  def print_unadopted_pets
    puts ''
    puts "#{name} has the following unadopted pets:"
    puts pets
    puts ''
  end
end

butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

asta = Pet.new('dog', 'Asta')
laddie = Pet.new('dog', 'Laddie')
fluffy = Pet.new('cat', 'Fluffy')
kat = Pet.new('cat', 'Kat')
ben = Pet.new('cat', 'Ben')
chatterbox = Pet.new('parakeet', 'Chatterbox')
bluebell = Pet.new('parakeet', 'Bluebell')

pets = [butterscotch, pudding, darwin, kennedy, sweetie, molly, chester,
        asta, laddie, fluffy, kat, ben, chatterbox, bluebell]

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new('The Animal Shelter')
shelter.add_pets(pets)
shelter.print_unadopted_pets

shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.print_unadopted_pets
shelter.print_adoptions

puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "#{shelter.name} has #{shelter.number_of_pets} unadopted pets."

# Write the classes and methods that will be necessary to make this code run, and print the following output:
# P Hanson has adopted the following pets:
# a cat named Butterscotch
# a cat named Pudding
# a bearded dragon named Darwin

# B Holmes has adopted the following pets:
# a dog named Molly
# a parakeet named Sweetie Pie
# a dog named Kennedy
# a fish named Chester

# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.

# The order of the output does not matter, so long as all of the information is presented.
