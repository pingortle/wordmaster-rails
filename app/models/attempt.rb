class Attempt < ApplicationRecord
  belongs_to :game

  attribute(
    :letters,
    Type::Custom.new(
      wraps: ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array.new(
        ActiveRecord::Type::String.new
      ),
      in: {
        String => ->(value) { value.each_char.map { |char| Letter.new(value: char.presence) } },
        Array => ->(value) { value.each.map { |char| Letter.new(value: char.presence) } }
      },
      out: ->(letters) { letters.map(&:value) },
    ),
    default: -> { [] }
  )

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

  class Letter
    include ActiveModel::Model
    attr_accessor :value

    def attributes
      {"value" => value}
    end
  end
end
