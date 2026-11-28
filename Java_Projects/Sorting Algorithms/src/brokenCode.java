public class brokenCode {

//    public static int partition(Burrito[] arr, int left, int right) {
//        Burrito pivot = arr[left];
//        int i = left + 1;
//        int j = right;
//
//        while (i <= j) {
//            //make sure left [i] hasnt exceeded right [j]
//            while (i <= j &&
//                    //if the burrito (current) is the same size as the pivot burrito
//                    // then check if the protein comes alphabetically before or equal
//                    // to the pivot. if it does then move forward since this element is correct
//                    ((arr[i].getSize().equals(pivot.getSize()) &&
//                    arr[i].getProtein().compareTo(pivot.getProtein()) <= 0)
//                    //if the element is large but the pivot is not, then the element should
//                    // move forward becuase large has priority
//                    || (arr[i].getSize().equals("large") && !pivot.getSize().equals("large")))) { // when true move forward
//                i++;
//            }
//            //make sure left [i] hasnt exceeded right [j]
//            while (i <= j &&
//                    //if current burrito is small but the pivot is not small,
//                    // then move element [j] backwards because large comes first
//                    ((arr[j].getSize().equals(pivot.getSize()) &&
//                            arr[j].getProtein().compareTo(pivot.getProtein()) > 0)
//                            || (arr[j].getSize().equals("small") && !pivot.getSize().equals("small")))) { //move the j element backwards until it finds one that needs to be swapped with i
//                j--;
//            }
//            //swap if i element is less then j
//            if (i < j) swap(arr, i, j);
//        }
//        swap(arr, left, j);
//        return j;
//    }
}
