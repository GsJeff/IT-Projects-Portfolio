/*
Graeme Jeffreys
2025-10-07
Lab 5: Recursion
 */

public class RecursiveStrings {
    //Part 2
    /*
        If string str is empty then return 0, then compare the first letter to all the vowels,
        if one matches then add 1 to the count and recursively iterate back through after removing the first
        letter of the string. if there is no vowel then recursively iterate back through without adding 1 to
        the counter.
     */
    public static int countVowels(String str) {
        if (str.isEmpty()) return 0;

        char c = str.charAt(0);

        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' || c == 'A' || c == 'E' || c == 'I'
                || c == 'O' || c == 'U') {
            return 1 + countVowels(str.substring(1));
        } else {
            return countVowels(str.substring(1));
        }
    }
    /*

     */
    public static String reverse(String str) {
        return str.isEmpty() ? "" : reverse(str.substring(1)) + str.charAt(0);
    }
    /*


     */
    public static String interweaveChar(String str, char ch) {
        return str.length() <= 1 ? str : str.charAt(0) + String.valueOf(ch) + interweaveChar(str.substring(1), ch);
    }
}
