require 'set'

# Read the dictionary file
dictionary_path = 'dictionary.txt'
words = File.readlines(dictionary_path).map(&:chomp)

# Track sequences and their corresponding words in order as they appear in the dictionary
sequences = []
# Using a Set to manage collections of unique elements and for fast lookups
non_unique_sequences = Set.new

words.each do |word|
  word_lower = word.downcase
  next if word_lower.length < 4  # Skip words shorter than four characters

  # Generate all possible four-letter sequences
  (0..word_lower.length - 4).each do |i|
    sequence = word_lower[i, 4]
    # Check if the sequence consists solely of letters
    if sequence.match?(/^[a-z]{4}$/)
      if non_unique_sequences.include?(sequence)
        next  # Skip the sequences that are already marked as non-unique
      elsif sequences.any? { |entry| entry[:sequence] == sequence }
        # If the sequence already exists, mark it as non-unique and remove it
        non_unique_sequences.add(sequence)
        sequences.reject! { |entry| entry[:sequence] == sequence }
      else
        # Add the sequence and its corresponding word to the list
        sequences << { sequence: sequence, word: word }
      end
    end
  end
end

# Write the sequences and words to their respective files in the correct order
File.open('sequences.txt', 'w') do |f|
  sequences.each { |entry| f.puts entry[:sequence] }
end

File.open('words.txt', 'w') do |f|
  sequences.each { |entry| f.puts entry[:word] }
end