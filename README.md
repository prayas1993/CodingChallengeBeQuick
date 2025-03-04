# Unique Four-Letter Sequences Extractor

This project contains two Ruby scripts that extract unique four-letter sequences from words in a dictionary file. The scripts generate two output files:

- `sequences/sequences_optimized.txt`: Contains unique four-letter sequences.
- `words/words_optimized.txt`: Lists the corresponding word for each sequence.

Both solutions achieve the same goal but differ in their implementation and efficiency. Below is an explanation of how each solution works and why the second solution is more efficient.Additionally, an object-oriented approach is provided for better modularity and reusability.

---

## Solution 1: Using an Array and a Set

### Code Overview

```ruby
require 'set'

# Read the dictionary file
dictionary_path = 'dictionary.txt'
words = File.readlines(dictionary_path).map(&:chomp)

# Track sequences and their corresponding words in order as they appear in the dictionary
sequences = []
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

# Write the sequences and words to their respective files in the correct order as they were present in the dictionary
File.open('sequences.txt', 'w') do |f|
  sequences.each { |entry| f.puts entry[:sequence] }
end

File.open('words.txt', 'w') do |f|
  sequences.each { |entry| f.puts entry[:word] }
end
```

### How It Works

1. **Read the Dictionary**:

   - The dictionary file is read into memory using `File.readlines`.

2. **Track Sequences**:

   - An array (`sequences`) is used to store unique sequences and their corresponding words.
   - A `Set` (`non_unique_sequences`) is used to track sequences that appear more than once.

3. **Process Each Word**:

   - For each word, all possible four-letter sequences are generated.
   - If a sequence is already in the `sequences` array, it is marked as non-unique and removed.
   - If a sequence is unique, it is added to the `sequences` array.

4. **Write Output Files**:
   - The `sequences` array is iterated to write unique sequences and their corresponding words to the output files.

---

## Solution 2: Using a Single Hash

### Code Overview

```ruby
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

# Write unique sequences and their corresponding words to the output files in one traversal for enhanced performance
sequences.each do |seq, word|
  next if word.nil?  # Skip sequences marked as non-unique
  sequences_file.puts(seq)
  words_file.puts(word)
end

# Close the output files
sequences_file.close
words_file.close
```

### How It Works

1. **Read the Dictionary Line by Line**:

   - The dictionary file is processed line by line using `File.foreach`, which is memory-efficient for large files.

2. **Track Sequences**:

   - A single hash (`sequences`) is used to store sequences as keys and their corresponding words as values.
   - If a sequence is encountered again, its value is set to `nil` to mark it as non-unique.

3. **Process Each Word**:

   - For each word, all possible four-letter sequences are generated.
   - If a sequence is already in the hash, it is marked as non-unique.
   - If a sequence is unique, it is added to the hash.

4. **Write Output Files**:
   - The `sequences` hash is iterated to write unique sequences and their corresponding words to the output files.

---

## Why Solution 2 is Better

1. **Memory Efficiency**:

   - Instead of loading the entire dictionary into memory with File.readlines, the script uses File.foreach to process the file line by line. This significantly reduces memory usage for large files.
   - Solution 1 loads the entire file into memory, which can be problematic for large dictionaries.

2. **Space Efficiency**:

   - Solution 2 uses a single hash to track sequences, reducing space complexity.
   - Solution 1 uses both an array and a set, increasing space usage.

3. **Time Efficiency**:

   - Solution 2 has a lower time complexity due to efficient hash operations.
   - Solution 1 performs expensive array operations (`any?` and `reject!`), making it slower.

4. **Simplicity**:
   - Solution 2 is simpler and easier to maintain, as it uses a single data structure (a hash) for tracking sequences.

---

## Conclusion

While both solutions achieve the same goal, **Solution 2** is more efficient in terms of memory usage, space complexity, and time complexity. It is the preferred approach for processing large dictionary files.

## Object-Oriented Approach

For better modularity, reusability, and maintainability, the problem can also be solved using an **object-oriented approach**. Below is the class-based implementation:

### Code Overview

```ruby
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
```

### How It Works

1. **Initialization**:

   - The `SequenceExtractor` class is initialized with paths to the dictionary file and output files.
   - An empty hash (`@sequences`) is created to store sequences and their corresponding words.

2. **Extract Sequences**:

   - The `extract_sequences` method processes a single word to extract valid four-letter sequences.
   - It updates the `@sequences` hash to track unique and non-unique sequences.

3. **Process Dictionary**:

   - The `process_dictionary` method reads the dictionary file line by line and calls `extract_sequences` for each word.

4. **Write Output Files**:

   - The `write_output_files` method writes unique sequences and their corresponding words to the output files.

5. **Run the Program**:
   - The `run` method orchestrates the program by calling `process_dictionary` and `write_output_files`.

---

# How to Run the Program

1. Clone the repository:

   ```bash
   git clone https://github.com/prayas1993/CodingChallengeBeQuick.git
   cd CodingChallengeBeQuick
   ```

2. Ensure the dictionary file (`dictionary.txt`) is in the same directory.

3. Run the script using any one of the commands:

   ```bash
   ruby extract_sequences_object_oriented.rb
   ```

   ```bash
   ruby extract_sequences_optimized.rb
   ```

4. The output files (`sequences_optimized.txt` and `words_optimized.txt`) will be generated in the same directory.

---
