import java.util.Arrays;
import java.util.LinkedList;


//use quick sort to sort array
public class Lab7P3 {
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
                System.out.print(b.getSize() + " " + b.getProtein() + " " + b.getCost());
                t = false;
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

        //create burrito arrays for importing into lists
        Burrito[] burritos = { burrito1, burrito2, burrito3, burrito4, burrito5, burrito6, burrito7 };
        Burrito[] burritoSame = { burrito1, burrito1, burrito1, burrito1, burrito1, burrito1, burrito1 };

        // create linkedlists
        LinkedList<Burrito> list = new LinkedList<>(Arrays.asList(burritos));

        LinkedList<Burrito> emptyList = new LinkedList<>();

        LinkedList<Burrito> singleList = new LinkedList<>();
        singleList.add(burrito2);

        LinkedList<Burrito> sameList = new LinkedList<>(Arrays.asList(burritoSame));

        // show lists
        System.out.println("Original Lists:");
        System.out.println("Regular List: ");
        printList(list);
        System.out.println();

        System.out.println("Empty List: " );
        printList(emptyList);
        System.out.println();

        System.out.println("Single List: ");
        printList(singleList);
        System.out.println();

        System.out.println("Same List: ");
        printList(sameList);

        LinkedList<Burrito> sortedList = (LinkedList<Burrito>) BurritoMergeSort.sort(list, 0, list.size() - 1);
        LinkedList<Burrito> sortedEmptyList = (LinkedList<Burrito>) BurritoMergeSort.sort(emptyList, 0, emptyList.size() - 1);
        LinkedList<Burrito> sortedSingleList = (LinkedList<Burrito>) BurritoMergeSort.sort(singleList, 0, singleList.size() - 1);
        LinkedList<Burrito> sortedSameList = (LinkedList<Burrito>) BurritoMergeSort.sort(sameList, 0, sameList.size() - 1);

        System.out.println("----------------------------------------");
        System.out.println("PRINT SORTED LIST");
        System.out.println("----------------------------------------");
        printList(sortedList);


        //test cases
        //empty
        System.out.println("----------------------------------------");
        System.out.println("PRINT SORTED EMPTY ARRAY");
        System.out.println("----------------------------------------");
        printList(sortedEmptyList);
        //single
        System.out.println("----------------------------------------");
        System.out.println("PRINT SORTED SINGLE ARRAY");
        System.out.println("----------------------------------------");
        printList(sortedSingleList);

        //same
        System.out.println("----------------------------------------");
        System.out.println("PRINT SORTED SAME ARRAY");
        System.out.println("----------------------------------------");
        printList(sortedSameList);
    }
}
