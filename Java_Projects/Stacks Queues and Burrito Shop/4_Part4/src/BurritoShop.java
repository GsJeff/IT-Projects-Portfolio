/*
Graeme Jeffreys
Lab 4 -part 1&2

tests use cases of the various data structures provided
 */

public class BurritoShop {

    public int tranNum;
    public int orderNum;
    public Queue burritosOrdered = new Queue();
    public Queue burritosMade = new Queue();
    public Stack dirtyPlates = new Stack();

    //constructor
    public BurritoShop() {
        this.orderNum = 0;
        this.tranNum = 0;
        this.burritosOrdered = new Queue();
        this.burritosMade = new Queue();
        this.dirtyPlates = new Stack();
    }


    //getters and setter for counts
    public int getOrderNum() {
        return orderNum;
    }
    public void setOrderNum(int orderNum) {
        this.orderNum = orderNum;
    }
    public int getTranNum() {
        return tranNum;
    }
    public void setTranNum(int tranNum) {
        this.tranNum = tranNum;
    }
    public Queue getBurritosOrdered() {
        return burritosOrdered;
    }
    public void setBurritosOrdered(Queue burritosOrdered) {
        this.burritosOrdered = burritosOrdered;
    }
    public Queue getBurritosMade() {
        return burritosMade;
    }
    public void setBurritosMade(Queue burritosMade) {
        this.burritosMade = burritosMade;
    }
    public Stack getDirtyPlates() {
        return dirtyPlates;
    }
    public void setDirtyPlates(Stack dirtyPlates) {
        this.dirtyPlates = dirtyPlates;
    }



    //return transactions and count
    public String orderCount() {
        return Integer.toString(orderNum);
    }

    public String transactionCount() {
        return Integer.toString(tranNum);
    }



    //take the order =0
    public void takeOrder (Burrito b) {
        burritosOrdered.enqueue(b);
        orderNum++;
        dirtyPlates.push("Plate");
    }

    //make the order !=0
    public void makeOrder () {
        if (burritosOrdered.isEmpty()) {
            System.out.println("no orders to make - take more orders");
        } else {
            burritosMade.enqueue(burritosOrdered.dequeue());
            orderNum--;
            tranNum++;
            dirtyPlates.push("Spoon");
        }
    }

    //ring out burrito order
    public void ringOut() {
        if (burritosMade.isEmpty()) {
            System.out.println("no orders to ring out - take more orders");
        } else {
            Burrito bRing = (Burrito) burritosMade.dequeue();
            System.out.println("Customer Charged: $" + bRing.getCost());
            tranNum--;
        }
    }

    public boolean sink() {
        if (dirtyPlates.isEmpty()) {
            return true;
        } else {
            return false;
        }
    }

    public void manageSink (int n){

        if (n == 1) {
            if (dirtyPlates.isEmpty()) {
                System.out.println("no dishes to wash");
            }
            else {
                System.out.println("A " + dirtyPlates.pop() + " was washed.");
            }

        } else if (n == 2) {
            if (dirtyPlates.isEmpty()) {
                System.out.println("no dishes to wash");
            }
            else {
                int size = dirtyPlates.getSize();
                System.out.println("The following dishes have been washed: ");

                for (int i = 0; i < size; i++) {
                    System.out.println(dirtyPlates.pop());
                }
            }
        }
    }
}