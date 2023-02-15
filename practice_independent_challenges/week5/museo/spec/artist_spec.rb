require './lib/photograph'
require './lib/artist'

RSpec.describe Artist do
  before :each do
    @attributes = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }
    @artist = Artist.new(@attributes)
  end

  it 'exists' do
    expect(@artist).to be_a Artist
  end

  it 'has attributes' do
    expect(@artist.instance_variables).to eq(%i[@id @name @born @died @country @age_at_death])
  end

  it 'will calculate age at death from born and died years' do
    expect(@artist.age_at_death).to eq 82
    expect(@artist.age_at_death).to_not eq 80
  end
end
