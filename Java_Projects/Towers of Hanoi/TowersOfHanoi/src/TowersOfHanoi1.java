/**
 * Lab 6 part 1 (1&2)
 * Graeme Jeffreys
 * 2025-10-21
 *
 * A class to solve the Towers of Hanoi problem.
 * This class provides the helper methods, however students must implement the actual problem
 * solution by finishing the provided stub methods.
 */
public class TowersOfHanoiLab1 {
    static int n = 3; // Default number of discs for testing
    static int towerWidth = Math.max(n, 11);
    static Tower source = new Tower(centerPad("Tower A", towerWidth));
    static Tower auxiliary = new Tower(centerPad("Tower B", towerWidth));
    static Tower destination = new Tower(centerPad("Tower C", towerWidth));

    // main method
    public static void main(String[] args) {
        printTowers();
        //setup source tower A and blank towers B & C, basically counts back from 3 to 1
        for (int i = n; i > 0; i--) {
            source.push(new Disc(i));
            printTowers(); // to visualize building the tower form base up
        }

        System.out.println("\nInitial state:");
        printTowers();

        //manual solve
        System.out.println("Solving the Hanoi Problem non-recursively: ");
        moveTopDisc(source, destination);
        moveTopDisc(source,auxiliary);
        moveTopDisc(destination, auxiliary);
        moveTopDisc(source, destination);
        moveTopDisc(auxiliary, source);
        moveTopDisc(auxiliary, destination);
        moveTopDisc(source, destination);

        System.out.println("Sample Error: ");
        moveTopDisc(destination, auxiliary);
        moveTopDisc(destination, auxiliary);

    }

    /**
     * Solves the Towers of Hanoi problem recursively.
     *
     * @param n the number of discs to move
     * @param s the source tower
     * @param d the destination tower
     * @param a the auxiliary tower
     */
    public static void moveDiscs(int n, Tower s, Tower d, Tower a) {
        // TODO: Implement this method
    }

    /**
     * Moves the top disc from one tower to another and prints the updated state.
     *
     * @param s the source tower
     * @param d the destination tower
     * @throws IllegalArgumentException if the source or destination towers are null
     */
    public static void moveTopDisc(Tower s, Tower d) {
        //check for null towers
        if (s == null || d == null) {
            throw new IllegalArgumentException("S&D towers cant be null.");
        }

        //check if move is null
        Disc move = s.pop();
        if (move == null) {
            System.out.println("Cannot move from " + s.getName() + " because it is empty.");
            return;
        }

        //push verifies if true or false, if false then put disk back
        boolean success = d.push(move);
        if (success) {
            System.out.println("Move Disc " + move.getWidth() +
                    " from " + s.getName().trim() + " to " + d.getName().trim() + ":");
        } else {
            s.push(move);
            System.out.println("Cannot move Disc " + move.getWidth() + " to " +
                    d.getName().trim() + " as it is larger than the top Disc");
        }

        printTowers();
    }

    /**
     * Centers a string within a given length, padding with spaces as necessary.
     *
     * @param input the string to center
     * @param length the desired total length
     * @return the centered string
     * @throws IllegalArgumentException if the input string is null
     */
    public static String centerPad(String input, int length) {
        if (input == null) {
            throw new IllegalArgumentException("Input string cannot be null.");
        }
        if (input.length() >= length) {
            return input;
        }

        int totalPadding = length - input.length();
        int leftPadding = totalPadding / 2;
        int rightPadding = totalPadding - leftPadding;

        return " ".repeat(leftPadding) + input + " ".repeat(Math.max(0, rightPadding));
    }

    /**
     * Prints the current state of all three towers.
     */
    public static void printTowers() {
        System.out.println();
        int max = Math.max(source.getSize(), Math.max(auxiliary.getSize(), destination.getSize()));
        Disc l = source.getTop();
        Disc c = auxiliary.getTop();
        Disc r = destination.getTop();
        for (int i = max; i > 0; i--) {
            l = printTowerDiscOrBlank(source, l, i);
            c = printTowerDiscOrBlank(auxiliary, c, i);
            r = printTowerDiscOrBlank(destination, r, i);
            System.out.println();
        }
        System.out.println(source.getName() + auxiliary.getName() + destination.getName());
        System.out.println();
    }

    /**
     * Prints a disc or blank space for a given tower.
     *
     * @param t the tower
     * @param d the disc to print
     * @param i the current level
     * @return the next disc to print
     */
    private static Disc printTowerDiscOrBlank(Tower t, Disc d, int i) {
        if (t.getSize() >= i) {
            return printDisc(d);
        } else {
            printBlanks();
            return d;
        }
    }

    /**
     * Prints a disc with padding for visual representation.
     *
     * @param disc the disc to print
     * @return the disc below the current disc
     */
    public static Disc printDisc(Disc disc) {
        if (disc == null) {
            printBlanks();
            return null;
        }
        System.out.print(centerPad("-".repeat(disc.getWidth()), towerWidth));
        return disc.getBelow();
    }

    /**
     * Prints blank spaces for visual alignment.
     */
    public static void printBlanks() {
        System.out.print(" ".repeat(towerWidth));
    }


}
