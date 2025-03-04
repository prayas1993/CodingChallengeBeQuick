# Open the dictionary file for reading
dictionary_path = 'dictionary.txt'

# sequences hash to track sequences and their corresponding words
sequences = {}

# Process the dictionary file line by line for better memory usage
File.foreach(dictionary_path) do |word|
  word.chomp! # Removes the trailing newline character (if any) from the string `word`
  word_lower = word.downcase
  next if word_lower.length < 4  # Skip words shorter than four characters

  # Generate all possible four-letter sequences
  (0..word_lower.length - 4).each do |i|
    sequence = word_lower[i, 4]
    # Check if the sequence consists solely of letters
    if sequence.match?(/^[a-z]{4}$/)
      if sequences.key?(sequence)
        # If the sequence already exists, mark it as non-unique
        sequences[sequence] = nil
      else
        # Add the sequence and its corresponding word to the hash
        sequences[sequence] = word
      end
    end
  end
end

# Open the output files for writing
sequences_file = File.open('sequences_optimized.txt', 'w')
words_file = File.open('words_optimized.txt', 'w')

# Write unique sequences and their corresponding words to the output files in one traversal for enchanced performance
sequences.each do |seq, word|
  next if word.nil?  # Skip sequences marked as non-unique
  sequences_file.puts(seq)
  words_file.puts(word)
end

# Close the output files
sequences_file.close
words_file.close