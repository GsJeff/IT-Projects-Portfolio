package src.detector;

import java.awt.*;
import java.io.IOException;
import java.util.*;

public class main {

    /**
     * This is the constructor that initializes and runs the spam detection application.
     * <p>
     * This constructor performs the following tasks:
     * <ul>
     *     <li>Creates objects for data processing and the GUI.</li>
     *     <li>Removes any previously cleaned data folders.</li>
     *     <li>Defines a list of "white noise" words for cleaning text.</li>
     *     <li>Cleans the training folders for both ham and spam emails and analyzes them.</li>
     *     <li>Launches the GUI on the Event Dispatch Thread to ensure Swing thread safety.</li>
     * </ul>
     *
     * @param args java things :)
     * @throws IOException if any I/O error occurs during folder cleaning or analysis
     */
    public static void main(String[] args) throws IOException {
        // CREATE OBJECTS FOR FUNCTIONS
        DataProcessor dataProcessor =  new DataProcessor();
        ProbabilityFunctions probabilityFunctions = new ProbabilityFunctions();

        // removes files in the "clean" files in each designated folder when the application is run.
        dataProcessor.removePrevClean();


        // file paths
        String hamFilePath = "src/main/resources/data/train/ham/";
        String cleanHamFilePath = "src/main/resources/data/train/clean_ham/";
        String spamFilePath = "src/main/resources/data/train/spam/";
        String cleanSpamFilePath = "src/main/resources/data/train/clean_spam/";

        // Whitenoise list --------------------------------------------- ADDITION
        ArrayList<String> whiteNoiseList = new ArrayList<>();

        whiteNoiseList = dataProcessor.generateWhiteNoiseWords();

        //displays in console the list of generated white noise words
        //System.out.println("White Noise Words:" + whiteNoiseList);


       // ai gen list of white noise as mentioned in readme
//        ArrayList<String> whiteNoiseList2 = new ArrayList<>(
//            Arrays.asList(
//            // Commmon words
//            "a","an","the","and","or","but","if","then","else","because","as","while",
//            "of","at","by","for","with","about","against","between","into","through",
//            "during","before","after","above","below","to","from","up","down","in",
//            "out","on","off","over","under",
//
//            // Pronouns
//            "i","me","my","mine","myself","you","your","yours","yourself",
//            "he","him","his","himself","she","her","hers","herself",
//            "it","its","itself","we","us","our","ours","ourselves",
//            "they","them","their","theirs","themselves",
//
//            // Auxiliary
//            "am","is","are","was","were","be","been","being",
//            "have","has","had","having",
//            "do","does","did","doing",
//            "will","would","shall","should",
//            "can","could","may","might","must",
//
//            // Conversational
//            "um","uh","like","you know","i mean","basically","actually",
//            "literally","honestly","seriously","well","so","anyway",
//            "anyways","right","okay","ok","alright",
//            "kind of","sort of","just","really","very",
//
//            // Low-signal email words
//            "hi","hello","dear","regards","sincerely",
//            "thanks","thank you","please","kindly",
//            "attached","forwarded","re","fwd"
//            )
//        );



        // clean all spam files into a new folder
        dataProcessor.cleanFolderToFolder(hamFilePath, cleanHamFilePath, whiteNoiseList);
        dataProcessor.cleanFolderToFolder(spamFilePath, cleanSpamFilePath, whiteNoiseList);

        dataProcessor.analyzeFolder(cleanHamFilePath);
        dataProcessor.analyzeFolder(cleanSpamFilePath);


        // Standard Swing thread safety boilerplate
        EventQueue.invokeLater(() -> {
            SpamDetectorGUI detectorGUI = new SpamDetectorGUI();
            detectorGUI.setVisible(true);
        });

    }

}
