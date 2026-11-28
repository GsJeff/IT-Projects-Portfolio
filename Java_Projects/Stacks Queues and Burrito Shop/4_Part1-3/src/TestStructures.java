/*
Graeme Jeffreys
Lab 4 -part 1&2

tests use cases of the various data structures provided
 */

public class TestStructures {
    public static void main(String[] args) {
        // create the queue and stack and fill
        Queue testQueue = new Queue();
        Stack testStack = new Stack();

        //make size int
        int sizeS = testStack.getSize();

        //push 5 ints into stack
        for (int i = 1; i < 6; i++) {
            testStack.push(i);
        }

        //make size int
        sizeS = testStack.getSize();
        System.out.println("Size: " + sizeS);
        //pop stack until empty
        for (int i = 0; i < sizeS; i++) {
            System.out.print(testStack.pop() + " ");
        }

        //test for empty stack
        if (testStack.isEmpty()) {
            System.out.println("\nThe stack is empty");
        }


        //push 3 ints into stack
        for (int i = 0; i < 3; i++) {
            testStack.push(i);
        }

        //reset size
        sizeS = testStack.getSize();
        //print stack size
        System.out.println("Stack size: " + testStack.getSize() );
        //enqueue stack values
        for (int i = 0; i < sizeS; i++) {
            testQueue.enqueue(testStack.pop());
        }
        //reset size
        sizeS = testStack.getSize();
        //print both queue size and stack size
        System.out.println("Queue size: " + testQueue.getSize() );
        System.out.println("Stack size: " + testStack.getSize() );
        //set size to size of queue
        int sizeQ = testQueue.getSize();
        // dequeue
        for (int i = 0; i < sizeQ; i++) {
            System.out.println(testQueue.dequeue() + " ");
        }
        // show empty
        System.out.println("Queue size: " + testQueue.getSize() );
        //test for empty queue
        if (testQueue.isEmpty()) {
            System.out.println("The queue is empty");
        }

        // test what happens to dequeue and pop an empty stack
        System.out.println(testQueue.dequeue());
        System.out.println(testStack.pop());


    }
}