import java.util.Arrays;
import java.util.List;

public class QuickSortBurrito {

    public static Burrito[] quickSortBurrito(Burrito [] arr){
        if (arr == null || arr.length <= 1) {
            //had to surround with null compare to ensure that it doesnt throw exception
            if (arr != null) {
                return arr.clone();
            } else {
                System.out.println("null array");
            }
        }

        //preset to null
        Burrito[] c = null;
        //had to surround with null compare to ensure that it doesnt throw exception
        if (arr != null) {
            c = arr.clone();
        }
        // check if c is null to avoid error thrown
        if (c != null) {
            quickSort(c, 0, c.length - 1);
        }
        return c;
    }

    public static void quickSort(Burrito [] arr, int left, int right) {
        if (left < right) {
            int pivot = partition(arr, left, right);
            quickSort(arr, left, pivot - 1);
            quickSort(arr, pivot + 1, right);
        }
    }

    public static int compareBurrito(Burrito a, Burrito b) {
        List<String> order = Arrays.asList("large", "medium", "small");
        int sizeComp = Integer.compare(order.indexOf(a.getSize()), order.indexOf(b.getSize()));
        if (sizeComp != 0) return sizeComp;
        return a.getProtein().compareTo(b.getProtein());
    }

    public static int partition(Burrito[] arr, int left, int right) {
        Burrito pivot = arr[left];
        int i = left + 1;
        int j = right;

        while (i <= j) {
            while (i <= j && compareBurrito(arr[i], pivot) <= 0) {
                i++;
            }
            while (i <= j && compareBurrito(arr[j], pivot) > 0) {
                j--;
            }

            if (i < j) swap(arr, i, j);
        }
        swap(arr, left, j);
        return j;
    }

    // Utility function to swap two elements in an array
    public static void swap(Burrito[] arr, int i, int j) {
        Burrito temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

}