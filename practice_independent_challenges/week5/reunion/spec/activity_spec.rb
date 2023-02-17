require './lib/activity'

RSpec.describe Activity do
  before :each do
    @activity = Activity.new("Brunch")
  end

  it 'exists' do
    expect(@activity).to be_a Activity
  end

  it 'has attributes' do
    expect(@activity.name).to eq('Brunch')
  end

  it 'starts without any participants' do
    expect(@activity.participants).to eq({})
  end

  it 'can add participants and money paid and return a hash' do
    @activity.add_participant("Maria", 20)

    expect(@activity.participants).to eq({'Maria' => 20})
  end

  it 'can display the total cost of the activity' do
    @activity.add_participant("Maria", 20)
    expect(@activity.total_cost).to eq(20)

    @activity.add_participant("Luther", 40)
    expect(@activity.total_cost).to eq(60)
  end

  it 'can calculate the split by totalling money and dividing total participants' do
    @activity.add_participant("Maria", 20)
    @activity.add_participant("Luther", 40)

    expect(@activity.split).to eq(30)
  end

  it 'can calculate money owed by using the split and comparing to money paid' do
    @activity.add_participant("Maria", 20)
    @activity.add_participant("Luther", 40)

    expect(@activity.owed).to eq({'Maria' => 10, 'Luther' => -10})
  end
end