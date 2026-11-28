package src.detector;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class SpamDetectorGUI extends JFrame {

    private final DataProcessor dataProcessor = new DataProcessor();
    private final ProbabilityFunctions probabilityFunctions = new ProbabilityFunctions();

    private DefaultTableModel model;

    // Labels need to be fields so we can update their text later
    private JLabel accuracyValue;
    private JLabel precisionValue;

    public SpamDetectorGUI() {
        this.setTitle("Spam Detector");

        int screenWidth = 800;
        int screenHeight = 600;

        this.setSize(screenWidth, screenHeight);
        this.setLocationRelativeTo(null);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        initUI();
    }

    /**
     * Updates the GUI accuracy/precision labels using BOTH clean_ham and clean_spam folders.
     * This avoids misleading results like "Ham precision = 0%" or "Spam precision = 100%"
     * that happen when you compute precision on a single-class folder.
     */
    private void updateMetricsLabels() {
        // Analyze both folders so we can count TP, FP, TN, FN properly
        List<SpamResults> hamResults =
                dataProcessor.analyzeFolder("src/main/resources/data/train/clean_ham");

        List<SpamResults> spamResults =
                dataProcessor.analyzeFolder("src/main/resources/data/train/clean_spam");

        // Compute overall metrics for the model (accuracy + precision)
        Map<String, Double> metrics =
                probabilityFunctions.calculateOverallAccuracyAndPrecision(hamResults, spamResults);

        // Convert decimals to percentages for display
        accuracyValue.setText(String.format("%.2f%%", metrics.get("accuracy") * 100));
        precisionValue.setText(String.format("%.2f%%", metrics.get("precision") * 100));
    }

    private void initUI() {

        // PRE-RUN NOTICE
        SwingUtilities.invokeLater(() -> {
            JOptionPane.showMessageDialog(
                    this,
                    """
                            Welcome to our spam detector!\s
                            Please note that while running this application, it may look like it has frozen or crashed.
                             \
                            The reason behind this is due to the dataset loading in the background with no visual confirmation
                             \
                            of loading implemented yet. Thank you for your patience :).
                             \
                            **NOTE** Once the application opens, please select a test folder you wish to view!
                             \
                           
                            
                            
                             Developers: Graeme Jeffreys, Shawn Heer, Ramiyan Gangatharan"""
            );
        });

        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout(5, 5));
        mainPanel.setBackground(Color.WHITE);

        // MENU BAR CODE
        JMenuBar menuBar = new JMenuBar();
        JMenu fileMenu = new JMenu("File");
        menuBar.add(fileMenu);

        JMenuItem DirectoryMenuItem = new JMenuItem("Open Folder");
        JMenuItem CloseAppMenuItem = new JMenuItem("Close Application");

        fileMenu.add(DirectoryMenuItem);
        fileMenu.add(CloseAppMenuItem);

        this.setJMenuBar(menuBar);

        // JPanel for the JTable
        JPanel controlPanel = new JPanel();
        controlPanel.setLayout(new BorderLayout());
        controlPanel.setBackground(Color.LIGHT_GRAY);
        mainPanel.add(controlPanel, BorderLayout.CENTER);

        // TABLE MODEL
        model = new DefaultTableModel(new String[]{"File", "Actual Class", "Spam Probability"}, 0);

        JTable table = new JTable(model);
        table.setFillsViewportHeight(true);
        table.setAutoCreateRowSorter(true);
        table.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);

        JScrollPane scrollPane = new JScrollPane(table);
        controlPanel.add(scrollPane, BorderLayout.CENTER);

        // Panel for metrics + dropdown
        JPanel numberPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 10));
        numberPanel.setBackground(Color.LIGHT_GRAY);
        numberPanel.setBorder(BorderFactory.createEmptyBorder(10, 15, 10, 15));

        JLabel accuracyLabel = new JLabel("Accuracy:");
        accuracyLabel.setFont(new Font("SansSerif", Font.BOLD, 14));

        accuracyValue = new JLabel("0.00%");
        accuracyValue.setFont(new Font("SansSerif", Font.PLAIN, 14));

        JLabel precisionLabel = new JLabel("Precision:");
        precisionLabel.setFont(new Font("SansSerif", Font.BOLD, 14));

        precisionValue = new JLabel("0.00%");
        precisionValue.setFont(new Font("SansSerif", Font.PLAIN, 14));

        numberPanel.add(accuracyLabel);
        numberPanel.add(accuracyValue);
        numberPanel.add(Box.createHorizontalStrut(20));
        numberPanel.add(precisionLabel);
        numberPanel.add(precisionValue);

        // Dropdown: only controls what folder is displayed in the TABLE
        JComboBox<String> classCombo = new JComboBox<>(new String[]{"Select Folder to Analyze..."});
        classCombo.setFont(new Font("SansSerif", Font.PLAIN, 14));
        classCombo.setSelectedIndex(0);
        classCombo.addItem("Ham Files");
        classCombo.addItem("Spam Files");
        classCombo.addItem("All File Sets");
        numberPanel.add(classCombo);

        // Compute and show overall metrics once (model performance on both datasets)
        updateMetricsLabels();

        //adds base state:
        baseStateAllFiles();

        classCombo.addActionListener(e -> {
            String selectedClass = (String) classCombo.getSelectedItem();

            switch (selectedClass) {
                case "Select Folder to Analyze..." -> {
                    // Just clears the table; overall metrics remain displayed
                     //model.setRowCount(0);
                }
                case "Ham Files" -> {
                    File selectedFile = new File("src/main/resources/data/test/ham");
                    List<SpamResults> results = dataProcessor.analyzeFolder(selectedFile.getAbsolutePath());
                    updateTable(results);
                }
                case "Spam Files" -> {
                    File selectedFile = new File("src/main/resources/data/test/spam");
                    List<SpamResults> results = dataProcessor.analyzeFolder(selectedFile.getAbsolutePath());
                    updateTable(results);
                }
                // can accomodate multiple subdirectories
                case "All File Sets" -> {
                    List<SpamResults> results = baseStateAllFilesReturn();
                    updateTable(results);
                }
                case null -> model.setRowCount(0);
                default -> throw new IllegalStateException("Unexpected value: " + selectedClass);
            }
        });

        // ----------------------------------------------------------//
        //                      DO NOT TOUCH                         //
        // --------------------------------------------------------- //
        mainPanel.add(numberPanel, BorderLayout.SOUTH);
        this.add(mainPanel);
        // ---------------------------------------------------------//

        // Folder picker: shows results in table (accuracy/precision only meaningful if folder has labels)
        DirectoryMenuItem.addActionListener(e -> {
            JFileChooser chooser = new JFileChooser("src/main/resources/data/test");
            chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);

            if (chooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
                File selectedFile = chooser.getSelectedFile();
                List<SpamResults> results = dataProcessor.analyzeFolder(selectedFile.getAbsolutePath());
                updateTable(results);

                // Optional: if your test folder is known-labeled (all spam or all ham),
                // you could compute metrics too. Otherwise leave the overall metrics.
            }
        });
    }

    /**
     * Updates the table model with a new list of spam detection results.
     */
    public void updateTable(List<SpamResults> results) {
        model.setRowCount(0);
        for (SpamResults spamResults : results) {
            model.addRow(
                    new Object[]{spamResults.getFileName(), spamResults.getPredictedClass(),
                            String.format("%.5f", spamResults.getSpamProbability())
                    }
            );
        }
    }

    /**
     * SETS DISPLAY TO SHOW ALL THE FILES
     */
    public void baseStateAllFiles() {
        File testFolder = new File("src/main/resources/data/test");

        // recursively retrieves all subfolders
        List<File> allSubfolders = new ArrayList<>();
        collectSubdirectories(testFolder, allSubfolders);

        // analyze each subfolder and append to list
        List<SpamResults> allResults = new ArrayList<>();
        for (File folder : allSubfolders) {
            List<SpamResults> results = dataProcessor.analyzeFolder(folder.getAbsolutePath());
            allResults.addAll(results);
        }

        // use invoke later to allow for update
        SwingUtilities.invokeLater(() -> updateTable(allResults));
    }

    /**
     * Helper method, used to recursively add all sub directory folders into the allsubfolders list
     * @param folder the folder containing subdirectories
     * @param subfolders the list of subfolder files
     */
    private void collectSubdirectories(File folder, List<File> subfolders) {
        if (folder.isDirectory()) {
            subfolders.add(folder); // include the current folder
            File[] files = folder.listFiles();
            if (files != null) {
                for (File f : files) {
                    if (f.isDirectory()) {
                        collectSubdirectories(f, subfolders); // recurse into subdirectory
                    }
                }
            }
        }
    }

    /**
     * SETS DISPLAY TO SHOW ALL THE FILES
     * @return returns a list of all files
     */
    public List<SpamResults> baseStateAllFilesReturn() {
        File testFolder = new File("src/main/resources/data/test");

        // recursively retrieves all subfolders
        List<File> allSubfolders = new ArrayList<>();
        collectSubdirectories(testFolder, allSubfolders);

        // analyze each subfolder and append to list
        List<SpamResults> allResults = new ArrayList<>();
        for (File folder : allSubfolders) {
            List<SpamResults> results = dataProcessor.analyzeFolder(folder.getAbsolutePath());
            allResults.addAll(results);
        }

        return allResults;
    }
}