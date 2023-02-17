class Activity
  attr_reader :name,
              :participants

  def initialize(name)
    @name = name
    @participants = Hash.new { |k, v| k[v] = [] }
  end

  def add_participant(name, paid)
    participants[name] = paid
  end

  def total_cost
    participants.values.sum
  end

  def split
    total_cost / participants.keys.count
  end

  def owed
    participants.transform_values { |paid| split - paid }
  end

  def payments
    payments = Hash.new { |h, k| h[k] = [] }
    owed.each do |participant, amount_owed|
      participants.each do |payer, amount_paid|
        if amount_paid > split
          if amount_owed > 0
            if amount_owed > amount_paid - split
              payments[participant] << { from: payer, amount: amount_paid - split }
              amount_owed -= amount_paid - split
            else
              payments[participant] << { from: payer, amount: amount_owed }
              amount_owed = 0
            end
          end
        end
      end
    end
    payments
  end


end