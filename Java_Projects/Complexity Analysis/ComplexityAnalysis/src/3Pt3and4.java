/*
Graeme Jeffreys

Lab 3 pt 3&4

Compares time complexity of multiple sorting algorithms
provided by prof/TA for int array and list of 5000, 10000, 50000, 100000

 */

import java.util.LinkedList;
import java.util.Random;

public class Lab3Pt3and4 {

    private static void ArraySorts(String type, int[] arr) {
        // use a long int start because regular int variable
        // is actually too small and gave me error
        long start = System.currentTimeMillis();
        // use long int because the # of operations exceeds the max
        // number that the int variable can hold.
        long o = 0;

        if (type.equals("Quick")) {
            o = ComplexityLab.quickSortArray(arr, 0, arr.length - 1, 0);
        } else if (type.equals("Merge")) {
            o = ComplexityLab.mergeSortArray(arr);
        } else if (type.equals("Insertion")) {
            o = ComplexityLab.insertionSortArray(arr);
        } else if (type.equals("Selection")) {
            o = ComplexityLab.selectionSortArray(arr);
        }
        long end = System.currentTimeMillis();
        System.out.println(type + "       Array        "
                + o + "         " + (end - start));
    }

    private static void ListSorts(String type, LinkedList<Integer> list) {
        // use a long int start because regular int variable
        // is actually too small and gave me error.
        long start = System.currentTimeMillis();

        // use long int because the # of operations exceeds the max
        // number that the int variable can hold.
        long o = 0;
        if (type.equals("Quick")) {
            o = ComplexityLab.quickSortList(list);
        } else if (type.equals("Merge")) {
            o = ComplexityLab.mergeSortList(list);
        } else if (type.equals("Insertion")) {
            o = ComplexityLab.insertionSortList(list);
        } else if (type.equals("Selection")) {
            o = ComplexityLab.selectionSortList(list);
        }
        // use a long int end because regular int variable
        // is actually too small and gave me error
        long end = System.currentTimeMillis();
        System.out.println(type + "       List         "
                + o + "         " + (end - start));
    }

    // main method
    public static void main(String[] args) {

        // sizes
        int[] n = {5000, 10000, 50000, 100000};
        // random number upper bound limit as per lab instructions
        int upper = 100000;
        // rand var
        Random rand = new Random();

        // use for loop to iterate through the integer array and display each table
        // --> 1-4 elements of varying sized integers.
        for (int i = 0; i < n.length; i++) {
            int numOfElements = n[i];

            // 4 arrays + 4 linked lists
            int[] array1 = new int[numOfElements];
            int[] array2 = new int[numOfElements];
            int[] array3 = new int[numOfElements];
            int[] array4 = new int[numOfElements];
            LinkedList<Integer> list1 = new LinkedList<>();
            LinkedList<Integer> list2 = new LinkedList<>();
            LinkedList<Integer> list3 = new LinkedList<>();
            LinkedList<Integer> list4 = new LinkedList<>();

            // nested for loop to fill all with the same values
            for (int x = 0; x < numOfElements; x++) {
                int value = rand.nextInt(upper) + 1;
                array1[x] = value;
                array2[x] = value;
                array3[x] = value;
                array4[x] = value;
                list1.add(value);
                list2.add(value);
                list3.add(value);
                list4.add(value);
            }

            // print table & size
            System.out.println("\nList Size: " + numOfElements);
            System.out.println("Sort Type   Data Struct   Operations       Run Time(ms)");
            System.out.println("--------------------------------------------------------");
            // run each sort
            // quick sort
            ArraySorts("Quick", array1.clone());
            ListSorts("Quick", new LinkedList<>(list1));
            // merge sort
            ArraySorts("Merge", array2.clone());
            ListSorts("Merge", new LinkedList<>(list2));
            // insert sort
            ArraySorts("Insertion", array3.clone());
            ListSorts("Insertion", new LinkedList<>(list3));
            // selection sort
            ArraySorts("Selection", array4.clone());
            ListSorts("Selection", new LinkedList<>(list4));
        }
    }
}
