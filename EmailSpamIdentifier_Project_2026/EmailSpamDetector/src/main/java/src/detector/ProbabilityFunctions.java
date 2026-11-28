package src.detector;

import java.util.*;
import javax.swing.*;
import java.util.Set;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

public class ProbabilityFunctions {

    /**
     * Generate probability model is a function that takes in maps of the spam and ham emails and determines the
     * probability of a word being spam using a static Bayes estimate. This function produces a statistic on whether a
     * file is spam or not based on how many files contain unique words determined from a training dataset of spam and
     * non-spam (ham) files.
     * @param trainHamFreq - a map of words and the frequency occurrence for each in the spam files
     * @param trainSpamFreq - a map of words and the frequency occurrence for each word in the ham files
     * @param numHamFiles - an integer number of how many ham files contain each word
     * @param numSpamFiles - an integer number of how many spam files contain each word
     * @return wordSpamProbability - a map of words with a probability rating (double) of each word determining if it
     *                               is possibly spam or not. The number will be between 0.0 and 1.0.
     */
    public Map<String, Double> generateProbabilityModel(
            Map<String, Integer> trainHamFreq,
            Map<String, Integer> trainSpamFreq,
            int numHamFiles, int numSpamFiles)
    {

        // Create map to fill with words and probability rating
        Map<String, Double> wordSpamProbability = new HashMap<>();

        // Combine all unique words to create the hashset. Includes unique words from ham and spam in training set
        Set<String> allWords = new HashSet<>();
        allWords.addAll(trainHamFreq.keySet());
        allWords.addAll(trainSpamFreq.keySet());

        for (String word : allWords) {
            // The number of spam files containing the word for both spam and ham
            int spamCount = trainSpamFreq.getOrDefault(word, 0);
            int hamCount = trainHamFreq.getOrDefault(word, 0);

            //---------------- IMPRV
            // Remove words occurring in less than 5 files - uncommon word filtering
            int totalDocsContainingWord = spamCount + hamCount;
            if (totalDocsContainingWord < 3) {
                continue;
            }

            /*
            Bayes formula
            - parts calc probability word spam, ham, and then create the probability that it IS spam
            - based on formula provided by professor
            */
            double probWordSpam = (double) (spamCount + 1) / (numSpamFiles + 2);
            double probWordHam = (double) (hamCount + 1) / (numHamFiles + 2);
            double probWordIsSpam = probWordSpam / (probWordSpam + probWordHam);

            //--------------- IMPRV
            // Remove word if 50% of the time - neutral word filtering
            if (probWordIsSpam <= 0.4 || probWordIsSpam >= 0.6) {
                wordSpamProbability.put(word, probWordIsSpam);
            }
        }
        return wordSpamProbability;
    }


    //----------FOR FILE PROBABILITY-------------
    /**
     * Determines the spam probability of a file based on its words compared to the trained map created with
     * training files.
     * @param wordsetInFiles - the set of unique words in the files being evaluated
     * @param spamProbability - the map of words from training to help evaluate the probability of spam
     * @return spam probability of the file as a double (0.0 to 1.0)
     */
    public double computeSpamProbability( Set<String> wordsetInFiles, Map<String, Double> spamProbability) {
        // Create the spam score double
        double spamScore = 0.0;

        // Loop through words to determine overall weight, and return using the math function given by prof
        for (String word : wordsetInFiles) {
            Double p = spamProbability.get(word);
            if (p == null) continue;           // word not in model
            if (p <= 0.0 || p >= 1.0) continue; // avoid log(0)

            spamScore += Math.log(1.0 - p) - Math.log(p);
        }
        return 1.0 / (1.0 + Math.exp(spamScore));
    }

    /**
     * Calculates accuracy and precision for the given sets of data. AKA spam and ham files. Please see inline comments
     * within the function to fully understand math, etc.
     * @param hamResults probabilty results of ham files being spam or not
     * @param spamResults probability results of spam files being spam or not
     * @return a map of both precision and accuracy to display in the GUI
     */
    public Map<String, Double> calculateOverallAccuracyAndPrecision(List<SpamResults> hamResults,
                                                                    List<SpamResults> spamResults) {

        /*  Creating this function was difficult and the variables are hard to understand at first glance,
            below are the actual corresponding descriptions for each variable to clarify their purpose and meaning. */

        // predicted to be spam, AND actually spam
        int truePositive = 0;
        // predicted to be Spam, BUT actually ham
        int falsePositive = 0;

        // predicted to be ham, AND actually ham
        int trueNegative = 0;
        // predicted to be ham, BUT actually spam
        int falseNegative = 0;


        // Predicted = Spam:
        // Our probability model says its spam, so we test to see if it is actually spam, if it is then
        // it is classified as a true positive, which means it is predicted to be spam, AND actually spam
        for (SpamResults r : hamResults) {
            if ("Spam".equals(r.getPredictedClass())) falsePositive++;
            else trueNegative++;
        }

        // Predicted = Ham
        // Our probability model says its ham, so we test to see if it is actually ham, if it is not ham, BUT
        // actually spam, then it is classified as a false negative, which means it is
        // predicted to be ham, BUT actually spam
        for (SpamResults r : spamResults) {
            // uses Spam Results class to pull the predicted vs actual classification of the file.
            if ("Spam".equals(r.getPredictedClass())) truePositive++;
            else falseNegative++;
        }

        // int total of classified files
        int total = truePositive + falsePositive + trueNegative + falseNegative;

        // CALCULATIONS--------------------------------

        // Accuracy: calculation based on the provided math function from prof**
        // create accuracy var
        double accuracy;
        //if the total files is 0 accuracy is 0
        if (total == 0) {
            accuracy = 0.0;
            // else do some math
        } else {
            // accuracy = (TP + TN) / total
            accuracy = (double) (truePositive + trueNegative) / total;
        }

        // Precision: calculation based on the provided math function from prof**
        // create precision var
        double precision;
        //if the combined total of TP and FP is 0 the precision is 0
        if (truePositive + falsePositive == 0) {
            precision = 0.0;
            // else do some math
        } else {
            // precision = TP / (TP + FP)
            precision = (double) truePositive / (truePositive + falsePositive);
        }

        //------------------------------------------------

        // Add both accuracy and precision to the map, and their corresponding values
        Map<String, Double> metrics = new HashMap<>();
        metrics.put("accuracy", accuracy);
        metrics.put("precision", precision);
        return metrics;
    }
}
