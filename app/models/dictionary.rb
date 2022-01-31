class Dictionary
  cattr_accessor :dictionary_path, default: Rails.root.join("vendor/github/dolph/dictionary")
  cattr_accessor :words, default: {}

  class << self
    def popular
      words[:popular] ||= File.readlines(dictionary_path.join("popular.txt"), chomp: true)
    end
  end
end
