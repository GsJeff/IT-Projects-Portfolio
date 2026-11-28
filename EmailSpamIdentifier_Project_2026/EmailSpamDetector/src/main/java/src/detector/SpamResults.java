package src.detector;

public class SpamResults {
    private final String fileName;
    private final String predictedClass;
    private final double spamProbability;

    /**
     * This class creates a data object of our calculations to be projected onto the GUI.
     * @param fileName name of the file/folder being analyzed.
     * @param actualClass dataset the file came from (spam/ham)
     * @param spamProbability probability coefficient of the file/folder
     */
    public SpamResults(String fileName, String actualClass, double spamProbability) {
        this.fileName = fileName;
        this.predictedClass = actualClass;
        this.spamProbability = spamProbability;
    }

    public String getFileName() {
        return fileName;
    }

    public String getPredictedClass() {
        return predictedClass;
    }
    public double getSpamProbability() {
        return spamProbability;
    }
}
