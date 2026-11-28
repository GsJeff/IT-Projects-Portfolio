import java.util.Arrays;
import java.util.LinkedList;

public class Lab7P1 {
    public static void printArray(Burrito[] arr) {
        boolean t;
        if  (arr.length == 0 || arr == null) {
            System.out.println("[EMPTY]");
        } else {
            System.out.print("[");
            t = true;
            for (Burrito b : arr) {
                if (!t) {
                    System.out.print(", ");
                }
                System.out.print(b.getSize() + " " + b.getProtein());
                t = false;
            }
            System.out.print("]\n");
        }
    }


    public static void printList(LinkedList<Burrito> list) {
        boolean t = true;
        if  (list.isEmpty()) {
            System.out.println("[EMPTY]");
        } else {
            System.out.print("[");
            t = true;
            for (Burrito b : list) {
                if (!t) {
                    System.out.print(", ");
                }
                System.out.print(b.getSize() + " " + b.getProtein());
                t = false;
            }
            System.out.print("]\n");
        }
    }

    public static void main(String[] args) {

        Burrito burrito1 = new Burrito("small", "chicken", "white", "black", "cheese", false);
        Burrito burrito2 = new Burrito("large", "steak", "brown", "pinto", "tomatoes", true);
        Burrito burrito3 = new Burrito("medium", "carnitas", "white", "black", "lettuce", false);
        Burrito burrito4 = new Burrito("large", "sofritas", "brown", "none", "corn salsa", true);
        Burrito burrito5 = new Burrito("small", "none", "none", "none", "plain", false);
        Burrito burrito6 = new Burrito("medium", "chicken", "brown", "pinto", "cheese + sour cream", true);
        Burrito burrito7 = new Burrito("large", "steak", "white", "black", "pico de gallo", true);

        //make and print array
        System.out.println("----------------------------------------");
        System.out.println("PRINT ARRAY");
        System.out.println("----------------------------------------");
        Burrito[] burritos = { burrito1, burrito2, burrito3, burrito4, burrito5, burrito6, burrito7 };
        printArray(burritos);

        //make and print linkedlist

        //MY FOR LOOP WAS REPLACED BY ASLIST METHOD OF ARRAY LIBRARY CLASS and then further
        // replaced by an initial call that just autofilled it with the array of burritos
        LinkedList<Burrito> burritoList = new LinkedList<>(Arrays.asList(burritos));

        System.out.println("----------------------------------------");
        System.out.println("PRINT LINKEDLIST");
        System.out.println("----------------------------------------");
        printList(burritoList);

        //test cases
        System.out.println("----------------------------------------");
        System.out.println("PRINT Empty");
        System.out.println("----------------------------------------");

        // check empties
        Burrito[] burritoEmpty = {};
        printArray(burritoEmpty);
        LinkedList<Burrito> burritoListEmpty = new LinkedList<>();
        printList(burritoListEmpty);
        //check with 1
        System.out.println("----------------------------------------");
        System.out.println("PRINT singles");
        System.out.println("----------------------------------------");
        burritoListEmpty.add(burrito1);
        Burrito[] burritoSingle = { burrito1 };
        printArray(burritoSingle);
        printList(burritoListEmpty);


    }
}
