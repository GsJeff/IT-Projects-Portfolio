/*
Graeme Jeffreys
2025-10-07
Lab 5: Recursion
 */

import java.util.Scanner;

public class mainNumbers {
    //creates public static var to use in program
    public static int num = 0;
    public static int option = 0;

    public static void main(String[] args) {
        while (option != -1) {
            printMenu();
            switch (option) {
                case 1:
                    System.out.println("The single-digit reduction of " + num + " is: " +
                            RecursiveNumbers.reduceToSingleDigit(num));
                    break;
                case 2:
                    //check if factorial is not true
                    if (RecursiveNumbers.reverseFactorial(num, 2) == -1) {
                        System.out.println(num + " is not a factorial of any integer");
                        break;
                    }
                    //if not -1 return then do this:
                    System.out.println(num + " is a factorial of " +
                            RecursiveNumbers.reverseFactorial(num, 2));
                    break;
                case 3:
                    System.out.println("The sum of the squares of the digits of " + num + " are " +
                            RecursiveNumbers.sumSquaresDigits(num));
                    break;
                case 0:
                    option = -1;
                    break;
            }
        }
    }

    //Welcome to the Numbers Game
    //   1. Reduce to Single Digit
    //   2. Reverse Factorial
    //   3. Sum of Squares of Digits
    //   0. Exit
    //Choose an Option: 1
    public static void printMenu() {
        Scanner keyboard = new Scanner(System.in);
        System.out.println("\nWelcome to the Numbers Game\n");
        System.out.println("   1. Reduce to Single Digit");
        System.out.println("   2. Reverse Factorial");
        System.out.println("   3. Sum of Squares of Digits");
        System.out.println("   0. Close For the Day");
        System.out.print("Enter your choice: ");
        option = keyboard.nextInt();
        if (option != 0) {
            System.out.print("Enter a number: ");
            num = keyboard.nextInt();
        }
    }
}
