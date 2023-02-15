require './lib/photograph'

RSpec.describe Photograph do
  before :each do
    @attributes = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "4",
      year: "1954"
    }
    @photograph = Photograph.new(@attributes)
  end

  it 'exists' do
    expect(@photograph).to be_a Photograph
  end

  it 'has attributes' do
    expect(@photograph.instance_variables).to eq(%i[@id @name @artist_id @year])
  end
end