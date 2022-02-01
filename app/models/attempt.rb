class Attempt < ApplicationRecord
  belongs_to :game
  delegate :word, :attempts, :attempt_limit, to: :game

  attribute(
    :letters,
    Type::Custom.new(
      wraps: ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array.new(
        ActiveRecord::Type::String.new
      ),
      in: {
        String => ->(value) { value.each_char.with_index.map { |char, index| Letter.new(value: char.presence, index: index) } },
        Array => ->(value) { value.each_with_index.map { |char, index| Letter.new(value: char.presence, index: index) } }
      },
      out: ->(letters) { letters.map(&:value) },
    ),
    default: -> { [] }
  )

  validates_inclusion_of :guess, in: Dictionary.popular
  validates_length_of :attempts, maximum: ->(attempt) { attempt.attempt_limit }

  def correct?
    letters.all?(&:correct?)
  end

  def guess
    letters.map(&:value).join("")
  end

  def letters_attributes
    letters.map(&:attributes)
  end

  def letters_attributes=(value)
    self.letters = case value
    when Hash
      value.sort_by(&:first).map { |_, hash| hash[:value] }
    else
      value
    end
  end

  def score!
    letters.zip(word.each_char) do |letter, answer|
      if letter.value == answer
        letter.correct!
      end
    end

    letters.filter(&:unknown?).each do |candidate|
      word.each_char.with_index do |answer, index|
        if candidate.value == answer && !letters.map(&:correct_index).include?(index)
          candidate.correct_with_incorrect_location!(index: index)
        end
      end
    end

    letters.filter(&:unknown?).each(&:incorrect!)
  end

  class Letter
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :value, :string
    attribute :score, :string, default: :unknown
    attribute :index, :integer
    attribute :correct_index, :integer

    def value=(value)
      super(value.try { downcase.chomp })
    end

    def correct!
      self.score = :correct
      self.correct_index = index
    end

    def correct_with_incorrect_location!(index:)
      self.score = :correct_with_incorrect_location
      self.correct_index = index
    end

    def incorrect!
      self.score = :incorrect
    end

    def unknown?
      score.inquiry.unknown?
    end

    def correct?
      score.inquiry.correct?
    end

    def attributes
      {"value" => value}
    end
  end
end
