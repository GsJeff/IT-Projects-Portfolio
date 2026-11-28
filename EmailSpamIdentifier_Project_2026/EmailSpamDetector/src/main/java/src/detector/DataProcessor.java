package src.detector;

import java.util.*;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Set;


public class DataProcessor {

    /*
     *                 ----------FUNCTION APPENDIX---------------
     *
     *          - removePrevClean: removes all files in cleaned folders
     *
     *          - readFile: reads a specific file,
     *                  HELPER METHOD for: readFolder
     *
     *          - writeFile: writes a new file to a specified folder path
     *                  HELPER METHOD for: cleanFileToFolder
     *
     *          - countFiles: counts files in a folder --> probability functions
     *
     *          - readFolder: reads all the files in a folder --> GUI (?)
     *
     *          - getWordFrequencies: creates a map of unique words and their frequency within a file
     *                  HELPER METHOD for: getFolderWordFrequencies
     *
     *          - getFolderWordFrequencies: creates a map of unique words and their frequency for all the files in a
     *                                      folder ---> probability functions
     *
     *          - fetchFilePaths: fetches a file paths from a directory ---> GUI
     *
     *          - readFileAsText: reads a file and returns a string with each word appended to new line
     *                  HELPER METHOD for: cleanFileToFolder
     *
     *          - cleanText: cleans a files text of white noise words and returns as string
     *                  HELPER METHOD for: cleanFileToFolder
     *
     *          - cleanFileToFolder: uses helper methods to clean file of white noise.
     *                  HELPER METHOD for: cleanFolderToFolder
     *
     *          - cleanFolderToFolder: cleans all files in a folder and inputs clean file to a new folder (specified)
     *
     *          - wordSplitFunction: takes a file of text and returns an array list of words split by white space
     *                  HELPER METHOD for: readFile, getWordFrequencies, cleanText
     *
     *          - wordSetFile: takes a file of text and returns a set of unique words found in the specified file.
     *
     *          - wordSetFolder: takes a file of text and returns a set of unique words found in the specified folder.
     *
     *          - analyzeFolder: This method trains and tests a Naive Bayes spam classification model using the cleaned
     *            training datasets to then process and display the data by transferring it to GUI code.
     */


    /**
     * removes everything in clean file folders
     */
    public void removePrevClean () {
        File obj1 = new File("src/main/resources/data/train/clean_ham");
        File obj2 = new File("src/main/resources/data/train/clean_spam");

        // Create array of the files in the folders
        File[] folders = {obj1, obj2};
        for (File folder : folders) {
            if (folder.exists() && folder.isDirectory()) {
                File[] files = folder.listFiles(); // get all files in folder
                if (files != null) {
                    for (File file : files) {
                        if (file.isFile()) { // only delete files, not subfolders
                            boolean deleted = file.delete();
                            if (!deleted) {
                                System.out.println("Fail delete file: " + file.getAbsolutePath());
                            }
                        }
                    }
                }
            } else {
                System.out.println("Folder DNE: " + folder.getAbsolutePath());
            }
        }
    }

    /**
     * Writes a new file
     * @param folderPath path to new folder
     * @param fileName name of new file
     * @param text text to be included in new file & folder
     */
    public void writeFile(String folderPath, String fileName, String text) {
        try {
            // Create a Path object for the destination folder
            Path dir = Paths.get(folderPath);
            // Ensure the destination folder exists - if it does not exist, it will be created (including parent folders)
            Files.createDirectories(dir);
            // Create the full path to the output file
            Path filePath = dir.resolve(fileName);
            // Write the provided text to the file. If the file already exists, it will be overwritten
            // If it does not exist, it will be created automatically
            Files.writeString(filePath, text);
        } catch (IOException e) {
            // Handle any file I/O errors (e.g., permission issues, invalid paths)
            e.printStackTrace();
        }
    }

    /**
     * This method simply counts the number of files inside a folder
     * @param folderPath folder path of the file to count
     * @return Integer num of files in folder returned
     */
    public static int countFiles(String folderPath) {
        // Create a file object representing the folder path
        File folder = new File(folderPath);
        // Ensure the path exists and is a directory
        if (!folder.exists() || !folder.isDirectory()) {
            System.out.println("Invalid folder path");
            return 0;
        }
        // Retrieve all entries in the folder
        File[] files = folder.listFiles();
        // If folder is empty or inaccessible
        if (files == null) return 0;
        int count = 0;
        // Count only regular files
        for (File file : files) {
            if (file.isFile()) {
                count++;
            }
        }
        return count;
    }

    /**
     * This function gets the frequency of all words in a given file
     * ***----> helper method for 'getFolderWordFrequences()'
     * @param filepath filepath of the file that is being used
     * @return map of unique words and the frequency of the words for a specific file
     */
    public static Map<String, Integer> getWordFrequencies(String filepath) {
        // Read the entire file into one string
        String text = readFileAsText(filepath);
        // Split into individual works with our wordSplitFunction
        ArrayList<String> fileWords = wordSplitFunction(text);
        // make a frequencies map to count the number of times a word appears
        Map<String, Integer> freqMap = new HashMap<>();
        for (String word : fileWords) {
            // if for some reason a word is blank skip it
            if (word.isBlank()) continue;
            // If word exists, increment; otherwise start at 1
            freqMap.put(word, freqMap.getOrDefault(word, 0) + 1);
        }
        return freqMap;
    }

    /**
     * This function gets the word frequencies across all files in a given folder, it calls the
     * getWordFrequencies function which does it per file in a loop
     * @param folderPath string path of the folder being used
     * @return returns a map of ALL unique words in a specified folder, and the frequency of each word
     */
    public static Map<String, Integer> getFolderWordFrequencies(String folderPath) {
        // Create a File object for the folder path
        File folder = new File(folderPath);
        // Ensure the folder exists and is a directory
        if (!folder.exists() || !folder.isDirectory()) {
            System.out.println("Invalid folder path");
            return new HashMap<>();
        }
        // Retrieve all files in the folder
        File[] files = folder.listFiles();
        if (files == null) return new HashMap<>();
        // Map to store combined word frequencies across all files
        Map<String, Integer> totalFreq = new HashMap<>();
        // Process each file in the folder
        for (File file : files) {
            // Skip subdirectories
            if (!file.isFile()) continue;
            // Get word frequencies for the current file
            Map<String, Integer> fileFreq = getWordFrequencies(file.getAbsolutePath());

            // Merge current file frequencies into the total frequency map
            for (Map.Entry<String, Integer> entry : fileFreq.entrySet()) {
                String word = entry.getKey();
                int count = entry.getValue();

                totalFreq.put(word, totalFreq.getOrDefault(word, 0) + count);
            }
        }
        // Return the combined word frequency map
        return totalFreq;
    }

    /**
     * Reads an entire file into a single String for tokenization
     * @param filepath filepath string
     * @return string of words each on a new line determined by whitespace or a " " space to separate them.
     */
    public static String readFileAsText(String filepath) {
        File obj = new File(filepath);
        StringBuilder sb = new StringBuilder(); // Efficiently build large strings
        try (Scanner scanner = new Scanner(obj)) {
            // Read the file line by line and append to one String
            while (scanner.hasNextLine()) {
                sb.append(scanner.nextLine()).append(" ");
            }
        } catch (FileNotFoundException e) {
            // Handles case where the file path is invalid or missing
            e.printStackTrace();
        }
        // Return full file contents as a single String
        return sb.toString();
    }

    /**
     * Removes white-noise words and returns cleaned text (space-separated)
     * @param text inputted text to clean
     * @param whiteNoiseList predetermined list of "white noise" words
     * @return a cleaned string of words with the white noise words removed
     */
    public String cleanText(String text, ArrayList<String> whiteNoiseList) {
        // Put noise words in a Set for fast contains()
        Set<String> noiseSet = new HashSet<>(whiteNoiseList);

        ArrayList<String> tokens = wordSplitFunction(text);
        StringBuilder cleaned = new StringBuilder();

        for (String token : tokens) {
            if (token.isBlank()) continue;

            // keep token only if it is NOT white noise
            if (!noiseSet.contains(token)) {
                cleaned.append(token).append(" ");
            }
        }

        return cleaned.toString().trim();
    }

    /**
     * Cleans ONE file and writes it to destination folder
     * @param inputFilePath file path to clean
     * @param outputFolderPath where to put newly cleaned file
     * @param whiteNoiseList array list of white noise words
     */
    public void cleanFileToFolder(String inputFilePath, String outputFolderPath, ArrayList<String> whiteNoiseList) {

        File inFile = new File(inputFilePath);
        String originalText = readFileAsText(inputFilePath);

        String cleanedText = cleanText(originalText, whiteNoiseList);

        // Write output file with the same name as input
        writeFile(outputFolderPath, inFile.getName(), cleanedText);
    }

    /**
     * Cleans EVERY file in a folder and writes them all to destination folder
     * @param inputFolderPath folder path to clean
     * @param outputFolderPath output folder path for cleaned filed
     * @param whiteNoiseList array list of white noise words
     */
    public void cleanFolderToFolder(String inputFolderPath, String outputFolderPath, ArrayList<String> whiteNoiseList) {
        File folder = new File(inputFolderPath);

        if (!folder.exists() || !folder.isDirectory()) {
            System.out.println("Invalid folder path");
            return;
        }

        File[] files = folder.listFiles();
        if (files == null) return;
        for (File file : files) {
            if (file.isFile()) {
                cleanFileToFolder(file.getAbsolutePath(), outputFolderPath, whiteNoiseList);
            }
        }
    }

    /**
     * This method takes each file of text, and splits it by word and stores it in an arraylist.
     * This segment will be delimited by spaces.
     * @param text a String that will be delimited by spaces once processed through this method.
     * @return an arraylist
     */
    public static ArrayList<String> wordSplitFunction(String text) {
        text = text.toLowerCase().replaceAll("[^a-z0-9\\s]", "");
        String[] splitText = text.split("\\s+"); // Split by whitespace
        // Convert array to ArrayList
        return new ArrayList<>(Arrays.asList(splitText));
    }

    /**
     * Returns a set of unique words found in the specified file.
     * This method uses getWordFrequencies() to obtain a map of words
     * and their counts, then takes it and returns the map's keys.
     *
     * @param filepath the path of the file to scan
     * @return a HashSet containing the unique words in the file
     */
    public HashSet<String> wordSetFile(String filepath) {
        return new HashSet<>(getWordFrequencies(filepath).keySet());
    }

    // initialization of the class to work within analyzeFolder().
    private final ProbabilityFunctions probabilityFunctions = new ProbabilityFunctions();

    /**
     * This method trains a Naive Bayes spam classification model using the cleaned training datasets
     * (clean_ham and clean_spam), then classifies all files in the specified folder.
     * -->Training: Builds two word frequency maps (ham and spam), then generates a spam probability model.
     * -->Testing: For each file in the folder, it takes the unique words and computes the spam probability.
     *
     * The file is classified as "Spam" if the probability is ≥ 0.5, otherwise it is classified as "Ham".
     *
     * @param folderPath the path to the folder containing files to be analyzed
     * @return a List of SpamResults representing the predicted class ("Spam" or "Ham")
     *         and spam probability for each file in the folder. Returns an empty list if the folder is empty or invalid.
     */
    public List<SpamResults> analyzeFolder(String folderPath) {

        List<SpamResults> results = new ArrayList<>();

        // training
        String trainHamPath = "src/main/resources/data/train/clean_ham";
        String trainSpamPath = "src/main/resources/data/train/clean_spam";

        Map<String, Integer> trainHamFreq = getFolderWordFrequencies(trainHamPath);
        Map<String, Integer> trainSpamFreq = getFolderWordFrequencies(trainSpamPath);

        int numHamFiles = countFiles(trainHamPath);
        int numSpamFiles = countFiles(trainSpamPath);

        Map<String, Double> spamModel =
                probabilityFunctions.generateProbabilityModel(
                        trainHamFreq,
                        trainSpamFreq,
                        numHamFiles,
                        numSpamFiles
                );


        // testing
        File folder = new File(folderPath);
        File[] files = folder.listFiles();
        if (files == null) return results;

        for (File file : files) {
            if (!file.isFile()) continue;

            String fileName = file.getName();
            // Get unique words in file
            Set<String> wordSet = wordSetFile(file.getAbsolutePath());

            // Compute real spam probability
            double probability = probabilityFunctions.computeSpamProbability(wordSet, spamModel);
            String predictedClass = probability >= 0.5 ? "Spam" : "Ham";
            results.add(new SpamResults(fileName, predictedClass, probability));
        }

        return results;
    }

    // REDUNDANT UNLESS TIME PERMITS - dont think we'll be able to implement, made by graeme :(

    /**
     * Generates and returns a hashset of white noise words based on frequency and probability using
     * both the spam and ham files to isolate and remove white noise during cleaning.
     * @return white noise list as an array list
     */
    public static ArrayList<String> generateWhiteNoiseWords() {

        //initialize whiteNoiseWords array list
        ArrayList<String> whiteNoiseWords = new ArrayList<>();

        // create two array lists of folders
        //ham-->
        ArrayList<String> hamFolders = new ArrayList<>();
        hamFolders.add("src/main/resources/data/train/ham");
        hamFolders.add("src/main/resources/data/train/ham2");
        //spam-->
        ArrayList<String> spamFolders = new ArrayList<>();
        spamFolders.add("src/main/resources/data/train/spam");

        // GET WORD FREQ FOR EACH FILE FOLDER SET
        //ham 1+2
        Map<String, Integer> hamFreqAll = new HashMap<>();
        // goes through array (2 folders)
        for (int i = 0; i < hamFolders.size(); i++) {
            String folder = hamFolders.get(i);
            Map<String, Integer> freq = getFolderWordFrequencies(folder);

            // loops through all words in each array and counts and adds the frequency of each
            for (String word : freq.keySet()) {
                int count = freq.get(word);
                int currentCount = 0;
                if (hamFreqAll.get(word) != null) {
                    currentCount = hamFreqAll.get(word);
                }
                hamFreqAll.put(word, currentCount + count);
            }
        }

        // spam
        Map<String, Integer> trainSpamFreqWN = getFolderWordFrequencies(spamFolders.get(0));

        // create hash set of allWords
        Set<String> allWords = new HashSet<>();
        allWords.addAll(hamFreqAll.keySet());
        allWords.addAll(trainSpamFreqWN.keySet());

        // create num counts for each file set
        int numHamFiles = 0;
        for (String folder : hamFolders) {
            numHamFiles += countFiles(folder);
        }
        int numSpamFiles = countFiles(spamFolders.get(0));

        //apply bayes stats model for spam probability based on frequency of use
        for (String word : allWords) {
            int spamCount = trainSpamFreqWN.getOrDefault(word, 0);
            int hamCount = hamFreqAll.getOrDefault(word, 0);

            // Calculate frequency probabilities
            double probSpam = (double) (spamCount + 1) / (numSpamFiles + 2);
            double probHam = (double) (hamCount + 1) / (numHamFiles + 2);

            // Check if word is within our white noise thresholds:
            // common in both over 50%
            if (probSpam > 0.5 && probHam > 0.5) {
                whiteNoiseWords.add(word);
            }

            // lowers accuracy

            //common in ham as neutral words that are semi-occuring
//            if (probHam < 0.55 && probHam > 0.45 ) {
//                whiteNoiseWords.add(word);
//            }
        }
        return whiteNoiseWords;
    }
}
