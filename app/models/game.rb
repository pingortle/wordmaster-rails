class Game < ApplicationRecord
  has_many :attempts
  validates_inclusion_of :word, in: Dictionary.popular

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
    [0, attempt_limit - attempts.length].max
  end

  def scored
    score!
    self
  end

  def score!
    attempts.each(&:score!)
  end

  def incomplete?
    status == :incomplete
  end

  def status
    if attempts.last&.correct?
      :won
    elsif remaining_attempt_count == 0
      :lost
    else
      :incomplete
    end
  end

  def self.with_random_word(length: 5)
    create_with(word: Dictionary.popular_of_length(length).sample)
  end
end
