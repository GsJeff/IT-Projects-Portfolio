import java.util.Arrays;
import java.util.LinkedList;


//use quick sort to sort array
public class Lab7P2 {
    public static void printArray(Burrito[] arr) {
        if (arr.length == 0) {
            System.out.println("[EMPTY]");
        } else {
            System.out.print("[");
            boolean first = true;
            for (Burrito b : arr) {
                if (!first) {
                    System.out.print(", ");
                }
                System.out.print(b.getSize() + " " + b.getProtein());
                first = false;
            }
            System.out.print("]\n");
        }
    }

    public static void main(String[] args) {

        //CREATE OBJECTS
        Burrito burrito1 = new Burrito("small", "chicken", "white", "black", "cheese", false);
        Burrito burrito2 = new Burrito("large", "steak", "brown", "pinto", "tomatoes", true);
        Burrito burrito3 = new Burrito("medium", "carnitas", "white", "black", "lettuce", false);
        Burrito burrito4 = new Burrito("large", "sofritas", "brown", "none", "corn salsa", true);
        Burrito burrito5 = new Burrito("small", "none", "none", "none", "plain", false);
        Burrito burrito6 = new Burrito("medium", "chicken", "brown", "pinto", "cheese + sour cream", true);
        Burrito burrito7 = new Burrito("large", "steak", "white", "black", "pico de gallo", true);

        //create burrito arrays
        Burrito[] burritos = { burrito1, burrito2, burrito3, burrito4, burrito5, burrito6, burrito7 };
        Burrito[] burritoEmpty = {};
        Burrito[] burritoSingle = { burrito1 };
        Burrito[] burritoSame = { burrito1, burrito1, burrito1, burrito1, burrito1, burrito1, burrito1 };
        // print original arrays
        System.out.println("Original Arrays:");
        printArray(burritos);
        printArray(burritoEmpty);
        printArray(burritoSingle);
        printArray(burritoSame);
        System.out.println(" ");

        //quick sort all burrito arrays into new copied
        Burrito[] burritosSorted = QuickSortBurrito.quickSortBurrito(burritos);




        //print sorted array
        System.out.println("----------------------------------------");
        System.out.println("PRINT SORTED ARRAY");
        System.out.println("----------------------------------------");
        printArray(burritosSorted);

        //test cases
        //empty
        Burrito[] burritosEmptySorted = QuickSortBurrito.quickSortBurrito(burritoEmpty);
        System.out.println("----------------------------------------");
        System.out.println("PRINT SORTED EMPTY ARRAY");
        System.out.println("----------------------------------------");
        printArray(burritosEmptySorted);
        //single
        Burrito[] burritoSingleSorted = QuickSortBurrito.quickSortBurrito(burritoSingle);
        System.out.println("----------------------------------------");
        System.out.println("PRINT SORTED SINGLE ARRAY");
        System.out.println("----------------------------------------");
        printArray(burritoSingleSorted);

        //same
        Burrito[] burritoSameSorted = QuickSortBurrito.quickSortBurrito(burritoSame);
        System.out.println("----------------------------------------");
        System.out.println("PRINT SORTED SAME ARRAY");
        System.out.println("----------------------------------------");
        printArray(burritoSameSorted);
    }
}


