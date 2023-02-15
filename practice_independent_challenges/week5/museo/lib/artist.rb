class Artist
  attr_reader :id,
              :name,
              :born,
              :died,
              :country,
              :age_at_death

  def initialize(attributes)
    @id = attributes[:id]
    @name = attributes[:name]
    @born = attributes[:born]
    @died = attributes[:died]
    @country = attributes[:country]
    @age_at_death = @died.to_i - @born.to_i
  end
end