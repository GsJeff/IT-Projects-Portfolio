/*
Graeme Jeffreys
2025-10-07
Lab 5: Recursion
 */

public class RecursiveNumbers {

    // Part 1
    /*
    Sets num to positive value, checks if num is less then 10 (aka single digit),
    then creates and sets sum to 0, and runs a while loop to add num mod 10 to sum and diving
    num by 10 until num is less then zero and it exits the loop.
     */
    public static int reduceToSingleDigit(int num) {
        num = Math.abs(num);
        if (num < 10) {
            return num;
        }
        int sum = 0;
        while (num > 0) {
            sum += num % 10;
            num /= 10;
        }
        return reduceToSingleDigit(sum);
    }
    /*
    Initially made into an Integer return to return null if num mod div is not equal
    to 0, but I couldn't have fun and do it in one line. So, I did it as an int as the instructions
    tell me and return a -1 instead.

    Check if num is less than zero, if so then make it positive, then it checks if num
    is equal to 1, if so then return div(2) - 1 so 1; if the num mod div is
    not equal to 0 then return -1 to show it is not a factorial of any number, and then finally
    return the method to call it recursively as num divided by div and div +1.
     */
    public static int reverseFactorial(int num, int div) {



        return (num < 0) ? Math.abs(num) : (num==1) ? div-1 : (num % div != 0) ? -1 :
                reverseFactorial(num / div, div + 1);
    }
    /*
    Check if num is less than zero, if so then make it positive. Then it checks if num is
    equal to zero and returns 0 if it is. Finally, if it is not 0 or less than 0 it returns
    num mod 10 by num mod 10 while adding it recursively back to the value of the function with
    num divided by 10 as the taken variable (by function).
     */
    public static int sumSquaresDigits(int num) {
        return (num < 0) ? Math.abs(num) : (num == 0) ? 0 :
                ((num % 10) * (num % 10)) + sumSquaresDigits(num / 10);
    }
}