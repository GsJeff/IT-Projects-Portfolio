/**
 * Lab 6 part 3
 * Graeme Jeffreys
 * 2025-10-21
 *
 * A class to solve the Towers of Hanoi problem.
 * This class provides the helper methods, however students must implement the actual problem
 * solution by finishing the provided stub methods.
 */
import java.sql.SQLOutput;
import java.util.*;
public class TowersOfHanoiLab3 {
    static int n = 3;
    static int towerWidth = Math.max(n, 11);
    static Tower source = new Tower(centerPad("Tower A", towerWidth));
    static Tower auxiliary = new Tower(centerPad("Tower B", towerWidth));
    static Tower destination = new Tower(centerPad("Tower C", towerWidth));
    // P3 counts the actual moves, works in tandem with countMoves
    static int moves = 0;

    // main method
    public static void main(String[] args) {

        // P3 changes size on input
        n = changeSize();

        //setup source tower A and blank towers B & C
        for (int i = n; i >= 1; i--) {
            source.push(new Disc(i));
        }

        // P3 reset moves
        moves = 0;

        //initialize
        System.out.println("\nSolving Towers of Hanoi with " + n + " discs:\n");
        printTowers();

        // P3 counts expected # of moves
        System.out.println("Expected number of moves: " + countMoves(n) + "\n");

        //calling this recursively will solve the towers at different sizes
        moveDiscs(n, source, destination, auxiliary);

        // P3 prints total moves
        System.out.println("The towers were solved in: " + moves + "\n");

    }

    /**
     * P3
     * changes n size
     */
    public static int changeSize() {
        Scanner input = new Scanner(System.in);
        System.out.println("Enter the size of the towers you would like to move: ");
        int x = input.nextInt();
        return x;
    }

    /**
     * P3
     * recursively counts the total # of moves to predict
     */
    public static int countMoves(int num) {
        if (num == 1) {
            return 1;
        } else {
            return countMoves(num - 1) + 1 + countMoves(num - 1);
        }
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
        // move discs to solve towers
        if (n == 1) {
            moveTopDisc(s, d);
        } else {
            moveDiscs(n - 1, s, a, d);
            moveTopDisc(s, d);
            moveDiscs(n - 1, a, d, s);
        }
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

            // P3 move coutner
            moves++;

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
        // P3 changes the - to +
        System.out.print(centerPad("+".repeat(disc.getWidth()), towerWidth));
        return disc.getBelow();
    }

    /**
     * Prints blank spaces for visual alignment.
     */
    public static void printBlanks() {
        System.out.print(" ".repeat(towerWidth));
    }


}
