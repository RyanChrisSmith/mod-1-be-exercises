require 'csv'
class Curator
  attr_reader :photographs,
              :artists

  def initialize
    @photographs = []
    @artists = []
  end

  def add_photograph(photo)
    @photographs << photo
  end

  def add_artist(artist)
    @artists << artist
  end

  def find_artist_by_id(id)
    artists.find {|artist| artist.id == id}
  end

  def photographs_by_artist
    photographs.group_by do |photograph|
      artists.find { |artist| artist.id == photograph.artist_id }
    end
  end

  def artists_with_multiple_photographs
    artists_with_photos = photographs_by_artist.select { |_artist, photos| photos.length > 1 }
    artists_with_photos.keys.map(&:name)
  end

  def photographs_taken_by_artist_from(country)
    photographs_by_artist.select { |artist, _photos| artist.country == country }.flat_map { |_artist, photos| photos }
  end

  def load_photographs(file)
    CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      add_photograph(Photograph.new({id:row[:id], name:row[:name], artist_id:row[:artist_id],year: row[:year]}))
    end
  end

  def load_artists(file)
    CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      add_artist(Artist.new({id:row[:id], name: row[:name], born:row[:born],died: row[:died], country: row[:country]}))
    end
  end

  def photographs_taken_between(range)
    photographs.select { |photo| photo.year.to_i > range.first && photo.year.to_i < range.last}
  end

  def artists_photographs_by_age(specific_artist)
    # Get an array of the artist's photographs
    photographs = photographs_by_artist[specific_artist]

    # Iterate over the array of photographs, create a new hash with the age of the artist when the photograph
    # was taken as the key and the photograph name as the value.
    photographs.each_with_object({}) do |photo, result|
      # Calculate the age of the artist when the photo was taken by subtracting the artist's birth year from the photo's year
      age = photo.year.to_i - specific_artist.born.to_i

      # Add the photograph name to the result hash with the age as the key
      result[age] = photo.name
    end
  end

end