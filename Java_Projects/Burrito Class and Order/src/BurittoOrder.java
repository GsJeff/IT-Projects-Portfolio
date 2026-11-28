public class BurittoOrder {

    /**
     * Main method: does this n that
     *
     * @param args command line arguments (not used)
     */
    public static void main(String[] args) {

        // default burrito with no toppings
        Burrito burrito1 = new Burrito();
        burrito1.setSize(burrito1.getSize());
        burrito1.setProtein(burrito1.getProtein());
        burrito1.setRice(burrito1.getRice());
        burrito1.setBeans(burrito1.getBeans());
        burrito1.setToppings("No Toppings");


        Burrito burrito2 = new Burrito("Small", "Chicken");

        Burrito burrito3 = new Burrito("Small", "Steak", "Brown Rice", "Brown Beans",
                "lettuce and cheese", true);

        Burrito burrito4 = new Burrito("Large", "Chicken");
        Burrito burrito5 = new Burrito("Large", "Carnitas");
        Burrito burrito6 = new Burrito("Small", "Carnitas");


        System.out.println(burrito1.toString());
        System.out.println(burrito2.toString());
        System.out.println(burrito3.toString());
        System.out.println(burrito4.toString());
        System.out.println(burrito5.toString());
        System.out.println(burrito6.toString());
    }
}
