require './lib/activity'
require './lib/reunion'

RSpec.describe Reunion do
  before :each do
    @reunion = Reunion.new('1406 BE')
    @activity_1 = Activity.new('Brunch')
  end

  it 'exists' do
    expect(@reunion).to be_a Reunion
  end

  it 'has a name' do
    expect(@reunion.name).to eq('1406 BE')
  end

  it 'starts without activities' do
    expect(@reunion.activities).to eq([])
  end

  it 'can add activities' do
    expect(@reunion.activities).to eq([])

    @reunion.add_activity(@activity_1)
    expect(@reunion.activities).to eq([@activity_1])
  end

  it 'can calculate total cost of the reunion' do
    @activity_1.add_participant('Maria', 20)
    @activity_1.add_participant('Luther', 40)
    @reunion.add_activity(@activity_1)

    expect(@reunion.total_cost).to eq(60)
  end

  it 'can calculate multiple events for the reunion' do
    @activity_1.add_participant('Maria', 20)
    @activity_1.add_participant('Luther', 40)
    @reunion.add_activity(@activity_1)
    @activity_2 = Activity.new('Drinks')
    @activity_2.add_participant('Maria', 60)
    @activity_2.add_participant('Luther', 60)
    @activity_2.add_participant('Louis', 0)
    @reunion.add_activity(@activity_2)

    expect(@reunion.total_cost).to eq(180)
  end

  it 'can calculate total owed from all activites for each person' do
    @activity_1.add_participant('Maria', 20)
    @activity_1.add_participant('Luther', 40)
    @reunion.add_activity(@activity_1)
    @activity_2 = Activity.new('Drinks')
    @activity_2.add_participant('Maria', 60)
    @activity_2.add_participant('Luther', 60)
    @activity_2.add_participant('Louis', 0)
    @reunion.add_activity(@activity_2)

    expect(@reunion.breakout).to eq({ 'Maria' => -10, 'Luther' => -30, 'Louis' => 40 })
  end

  it 'can summarize what is owed in a human readable format' do
    @activity_1.add_participant('Maria', 20)
    @activity_1.add_participant('Luther', 40)
    @reunion.add_activity(@activity_1)
    @activity_2 = Activity.new('Drinks')
    @activity_2.add_participant('Maria', 60)
    @activity_2.add_participant('Luther', 60)
    @activity_2.add_participant('Louis', 0)
    @reunion.add_activity(@activity_2)

    expect(@reunion.summary).to eq("Maria: -10\nLuther: -30\nLouis: 40")
  end

  xit 'can give a detailed breakdown of all activities and money owed and to whom' do
    @activity_1.add_participant('Maria', 20)
    @activity_1.add_participant('Luther', 40)
    @reunion.add_activity(@activity_1)
    @activity_2 = Activity.new('Drinks')
    @activity_2.add_participant('Maria', 60)
    @activity_2.add_participant('Luther', 60)
    @activity_2.add_participant('Louis', 0)
    @reunion.add_activity(@activity_2)
    @activity_3 = Activity.new("Bowling")
    @activity_3.add_participant("Maria", 0)
    @activity_3.add_participant("Luther", 0)
    @activity_3.add_participant("Louis", 30)
    @reunion.add_activity(@activity_3)
    @activity_4 = Activity.new("Jet Skiing")
    @activity_4.add_participant("Maria", 0)
    @activity_4.add_participant("Luther", 0)
    @activity_4.add_participant("Louis", 40)
    @activity_4.add_participant("Nemo", 40)
    @reunion.add_activity(@activity_4)

    expect(@reunion.detailed_breakout).to eq({
        "Maria" => [
          {
            activity: "Brunch",
            payees: ["Luther"],
            amount: 10
          },
          {
            activity: "Drinks",
            payees: ["Louis"],
            amount: -20
          },
          {
            activity: "Bowling",
            payees: ["Louis"],
            amount: 10
          },
          {
            activity: "Jet Skiing",
            payees: ["Louis", "Nemo"],
            amount: 10
          }
        ],
        "Luther" => [
          {
            activity: "Brunch",
            payees: ["Maria"],
            amount: -10
          },
          {
            activity: "Drinks",
            payees: ["Louis"],
            amount: -20
          },
          {
            activity: "Bowling",
            payees: ["Louis"],
            amount: 10
          },
          {
            activity: "Jet Skiing",
            payees: ["Louis", "Nemo"],
            amount: 10
          }
        ],
        "Louis" => [
          {
            activity: "Drinks",
            payees: ["Maria", "Luther"],
            amount: 20
          },
          {
            activity: "Bowling",
            payees: ["Maria", "Luther"],
            amount: -10
          },
          {
            activity: "Jet Skiing",
            payees: ["Maria", "Luther"],
            amount: -10
          }
        ],
        "Nemo" => [
          {
            activity: "Jet Skiing",
            payees: ["Maria", "Luther"],
            amount: -10
          }
        ]
      })
  end
end