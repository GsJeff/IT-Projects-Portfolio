public class doubleLinkedList <E> {
    node<E> head;
    node<E> tail;
    int size;

    public doubleLinkedList() {
        this.head = null;
        this.tail = null;
        this.size = 0;
    }

    public int getLength() {
        return size;
    }

    public void add(E val) {
        node<E> newNode = new node<>(val);
        if (size == 0) {
            head = newNode;
            tail = newNode;
        } else {
            tail.setNext(newNode);
            newNode.setPrev(tail);
            tail = newNode;
        }
        size++;
    }

    public E get(int ind) {
        node<E> cur = head;
        int count = 0;
        while (cur != null) {
            if (count == ind) {
                return cur.getValue();
            }
            cur = cur.getNext();
            count++;
        }
        return null;
    }

    public E getHead() {
        return head.getValue();
    }

    public E getTail() {
        return tail.getValue();
    }

    public E removeFromFront() {

        if (head == null) {
            return null;
        }

        E removedVal = head.getValue();

        head = head.getNext();

        if (head != null) {
            head.setPrev(null);
        } else {
            tail = null;
        }

        size--;
        return removedVal;
    }

    public void addToFront(E val) {
        node<E> newNode = new node<>(val);

        newNode.setNext(head);
        head.setPrev(newNode);
        head = newNode;

        size++;
    }

    public E removeFromEnd() {
//        node<E> cur = tail;
//        int count = this.getLength();
//        while(cur != null){
//
//            cur.setNext(cur.getNext().getNext());
//            size--;
//
//            cur = cur.getNext();
//            count--;
//        }
//        return null;
        if (tail == null) {
            return null;
        }

        E removedVal = tail.getValue();
        tail = tail.getPrev();

        if (tail != null) {
            tail.setNext(null);
        } else {
            head = null;
        }

        size--;
        return removedVal;
    }

    public void addToEnd(E val) {
        node<E> newNode = new node<>(val);

        newNode.setPrev(tail);
        tail.setNext(newNode);
        tail = newNode;

        size++;
    }

    public String toString() {
        String result = "[";
        node<E> cur = head;
        if (cur != null) {
            while (cur.getNext() != null) {
                result += cur.getValue() + ", ";
                cur = cur.getNext();
            }
        } else {
            result += "]";
            return result;
        }
        result += cur.getValue() + "]";
        return result;
    }

    public boolean contains(E val) {
        node<E> cur = head;
        while (cur != null) {
            if (cur.getValue().equals(val)) {
                return true;
            }
            cur = cur.getNext();
        }
        return false;
    }

    public static void main(String[] args) {
        doubleLinkedList<Integer> intList = new doubleLinkedList<>();

        for (int i = 1; i <= 10; i++) {
            intList.add(i);
        }

        System.out.println("List after adding 1-10 to back: " + intList);
        System.out.println("Size: " + intList.getLength());

        intList.addToFront(0);
        intList.addToEnd(-1);

        System.out.println("List after adding -1,0 to front & end: " + intList);
        System.out.println("Size: " + intList.getLength());

        int removed = intList.removeFromFront(); // remove first (-1)
        System.out.println("Removed first element: " + removed);
        removed = intList.removeFromEnd(); // remove last (10)
        System.out.println("Removed last element: " + removed);

        System.out.println("Final list: " + intList);
        System.out.println("Final size: " + intList.getLength());

        System.out.println("Contains 5? " + intList.contains(5));

        doubleLinkedList<Burrito> burritoList = new doubleLinkedList<>();

        Burrito b1 = new Burrito();
        Burrito b2 = new Burrito("Small", "Chicken");
        Burrito b3 = new Burrito("Large", "Steak", "Brown Rice", "Brown Beans", "Cheese, Salsa", false);
        Burrito b4 = new Burrito();
        b4.setProtein("Sofritas");
        b4.setGuac(false);
        b4.setRice("Brown Rice");
        b4.setBeans("Brown Beans");

        // Add burritos to the list
        burritoList.add(b1);
        burritoList.add(b2);
        burritoList.addToFront(b3);
        burritoList.addToEnd(b4);

        System.out.println("Burrito list:");
        System.out.println(burritoList);
        System.out.println("List size: " + burritoList.getLength());

        Burrito removedFront = burritoList.removeFromFront();
        System.out.println("Removed from front: " + removedFront);

        Burrito removedEnd = burritoList.removeFromEnd();
        System.out.println("Removed from end: " + removedEnd);

        System.out.println("List after removals:");
        System.out.println(burritoList);
        System.out.println("List size: " + burritoList.getLength());

        System.out.println("Current head: " + burritoList.getHead());
        System.out.println("Current tail: " + burritoList.getTail());

        System.out.println("Contains b1? " + burritoList.contains(b1));
        System.out.println("Contains b2? " + burritoList.contains(b2));

        Burrito b5 = new Burrito("Small", "Steak");
        System.out.println("Contains b5? " + burritoList.contains(b5));

    }


}
