# duck typing example

class Wedding
  attr_reader :guests, :flowers, :songs

  def initialize(guests, flowers, songs)
    @guests = guests
    @flowers = flowers
    @songs = songs
  end

  def prepare(preparers)
    preparers.each do |preparer|
      preparer.prepare_wedding(self)
    end
  end
end

class Chef
  def prepare_wedding(wedding)
    prepare_food(wedding.guests)
  end

  def prepare_food(guests)
    puts "Preparing food for #{guests.join(' and ')}..."
  end
end

class Decorator
  def prepare_wedding(wedding)
    decorate_place(wedding.flowers)
  end

  def decorate_place(flowers)
    puts "Placing the #{flowers.join(' and ')} on the tables..."
  end
end

class Musician
  def prepare_wedding(wedding)
    prepare_performance(wedding.songs)
  end

  def prepare_performance(songs)
    puts "Queueing up #{songs.join(' and ')}..."
  end
end

guests = ["Billy", "Jessica"]
flowers = ["lilies", "tulips"]
songs = ["Eye of the Tiger", "Africa"]
details = [guests, flowers, songs]

joe = Chef.new
bob = Decorator.new
linda = Musician.new
staff = [joe, bob, linda]

sean_and_diana = Wedding.new(*details)
sean_and_diana.prepare(staff)
