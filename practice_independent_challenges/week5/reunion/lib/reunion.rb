class Reunion
  attr_reader :name,
              :activities

  def initialize(name)
    @name = name
    @activities = []
  end

  def add_activity(activity)
    activities << activity
  end

  def total_cost
    activities.sum(&:total_cost)
  end

  def breakout
    owed_by_participant = {}
    activities.each do |activity|
      activity.owed.each do |participant, owed|
        owed_by_participant[participant] ||= 0
        owed_by_participant[participant] += owed
      end
    end
    owed_by_participant
  end

  def summary
    breakout.map do |name, owed|
      "#{name}: #{owed}"
    end.join("\n")
  end

  def detailed_breakout
    result = {}

    activities.each do |activity|
      activity.participants.each do |payer, amount_paid|
        payees = (activity.participants.keys - [payer]).select do |payee|
          activity.payments[payee].any? { |p| p[:from] == payer }
        end

        if payees.any?
          payee_count = payees.count
          payee_split = activity.split / payee_count
          payees.each do |payee|
            payer_contribution = payee_split
            payer_contribution += payee_split % 1 if payee == payees.last

            payee_contribution = payer_contribution * -1

            result[payer] ||= []
            result[payee] ||= []

            result[payer] << {
              activity: activity.name,
              payees: [payee],
              amount: payer_contribution.round(2)
            }

            result[payee] << {
              activity: activity.name,
              payees: [payer],
              amount: payee_contribution.round(2)
            }
          end
        end
      end
    end

    result
  end

end