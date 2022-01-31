class Game < ApplicationRecord
  has_many :attempts

  def current_attempt
    attempts.new(
      letters: " " * word.length
    )
  end

  def remaining_attempts
    remaining_attempt_count.times.map {
      attempts.new(letters: " " * word.length)
    }
  end

  def remaining_attempt_count
    [0, attempt_limit - attempts.length - 1].max
  end

  def score!
    attempts.each(&:score!)
  end
end
