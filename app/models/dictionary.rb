class Dictionary
  cattr_accessor :dictionary_path, default: Rails.root.join("vendor/github/dolph/dictionary")
  cattr_accessor :words, default: {
    popular_of_length: {}
  }.with_indifferent_access

  class << self
    def popular
      words[:popular] ||= File.readlines(dictionary_path.join("popular.txt"), chomp: true)
    end

    def popular_of_length(length)
      words[:popular_of_length][length] ||= popular.filter { |word| word.length == length }
    end
  end
end
