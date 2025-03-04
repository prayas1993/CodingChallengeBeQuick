class SequenceExtractor
  # Initialize the class with file paths
  def initialize(dictionary_path, sequences_file_path, words_file_path)
    @dictionary_path = dictionary_path
    @sequences_file_path = sequences_file_path
    @words_file_path = words_file_path
    @sequences = {}
  end

  # Extract valid four-letter sequences from a word
  def extract_sequences(word)
    word_lower = word.downcase
    return if word_lower.length < 4  # Skip words shorter than four characters

    # Generate all possible four-letter sequences
    (0..word_lower.length - 4).each do |i|
      sequence = word_lower[i, 4]
      # Check if the sequence consists solely of letters
      if sequence.match?(/^[a-z]{4}$/)
        if @sequences.key?(sequence)
          # If the sequence already exists, mark it as non-unique
          @sequences[sequence] = nil
        else
          # Add the sequence and its corresponding word to the hash
          @sequences[sequence] = word
        end
      end
    end
  end

  # Process the dictionary file
  def process_dictionary
    File.foreach(@dictionary_path) do |word|
      word.chomp!  # Remove trailing newline character
      extract_sequences(word)
    end
  end

  # Write unique sequences and words to output files
  def write_output_files
    File.open(@sequences_file_path, 'w') do |sequences_file|
      File.open(@words_file_path, 'w') do |words_file|
        @sequences.each do |seq, word|
          next if word.nil?  # Skip sequences marked as non-unique
          sequences_file.puts(seq)
          words_file.puts(word)
        end
      end
    end
  end

  # Main method to execute the program
  def run
    process_dictionary
    write_output_files
    puts "Processing complete. Output files generated: #{@sequences_file_path}, #{@words_file_path}"
  end
end

# Create an instance of the SequenceExtractor class and run the program
dictionary_path = 'dictionary.txt'
sequences_file_path = 'sequences_optimized.txt'
words_file_path = 'words_optimized.txt'

extractor = SequenceExtractor.new(dictionary_path, sequences_file_path, words_file_path)
extractor.run