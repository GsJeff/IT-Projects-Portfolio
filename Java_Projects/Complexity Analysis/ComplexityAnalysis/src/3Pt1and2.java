/*
Graeme Jeffreys

Lab 3 pt 1&2

Compares time complexity of multiple sorting algorithms
provided by prof/TA for int array and list of 5000

 */

import java.util.LinkedList;
import java.util.Random;

public class Lab3Pt1and2 {


    private static void ArraySorts(String type, int[] arr) {
        // use a long int start because regular int variable
        // is actually too small and gave me error
        long start = System.currentTimeMillis();
        // use long int because the # of operations exceeds the max
        // number that the int variable can hold.
        long o = 0;
        // use if comparison to use the sorting methods for arrays
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
        // is actually too small and gave me error
        long start = System.currentTimeMillis();
        long o = 0;
        // use if comparison to use the sorting methods for linked lists
        if (type.equals("Quick")) {
            o = ComplexityLab.quickSortList(list);
        } else if (type.equals("Merge")) {
            o = ComplexityLab.mergeSortList(list);
        } else if (type.equals("Insertion")) {
            o = ComplexityLab.insertionSortList(list);
        } else if (type.equals("Selection")) {
            o = ComplexityLab.selectionSortList(list);
        }
        long end = System.currentTimeMillis();
        System.out.println(type + "       List         " +
                o + "         " + (end - start));
    }

    // main method
    public static void main(String[] args) {

        // size
        int n = 5000;
        // random number upper bound limit as per lab instructions
        int upper = 100000;
        // rand var
        Random rand = new Random();

        // 4 arrays and lists
        int[] array1 = new int[n];
        int[] array2 = new int[n];
        int[] array3 = new int[n];
        int[] array4 = new int[n];
        LinkedList<Integer> list1 = new LinkedList<>();
        LinkedList<Integer> list2 = new LinkedList<>();
        LinkedList<Integer> list3 = new LinkedList<>();
        LinkedList<Integer> list4 = new LinkedList<>();

        // fill all with the same values
        for (int i = 0; i < n; i++) {
            int value = rand.nextInt(upper) + 1;
            array1[i] = value;
            array2[i] = value;
            array3[i] = value;
            array4[i] = value;
            list1.add(value);
            list2.add(value);
            list3.add(value);
            list4.add(value);
        }

        // print table & size
        System.out.println("\nSize: " + n);
        System.out.println("Sort Type    Data Struct   Operations      Run Time(ms)");
        System.out.println("-------------------------------------------------------");
        // run each sort and clone the arrays to insert into each sorting algorithm
        //
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