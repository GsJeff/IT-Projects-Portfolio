public class Burrito {

    //Create the variables for the poperties of the class
    private String size; //large or small
    private String protein; //none, chicken, steak, carnitas, sofritas
    private String rice; // none, white, brown
    private String beans; //  none, black, brown
    private String toppings;// salsa, sour cream, cheese
    private boolean guac; // true or false


//    private double price;


    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getProtein() {
        return protein;
    }

    public void setProtein(String protein) {
        this.protein = protein;
    }

    public String getRice() {
        return rice;
    }

    public void setRice(String rice) {
        this.rice = rice;
    }

    public String getBeans() {
        return beans;
    }

    public void setBeans(String beans) {
        this.beans = beans;
    }

    public String getToppings() {
        return toppings;
    }

    public void setToppings(String toppings) {
        this.toppings = toppings;
    }

    public boolean isGuac() {
        return guac;
    }

    public void setGuac(boolean guac) {
        this.guac = guac;
    }

//    public double getPrice() {
//        return price;
//    }

//    public void setPrice(double price) {
//        this.price = price;
//    }


    public Burrito() {
        this.size = "Large";
        this.protein = "Carnitas";
        this.rice = "White Rice";
        this.beans = "Black Beans";
        this.toppings = "Salsa, Sour Cream, Cheeese";
        this.guac = true;

//        this.price = 0;
    }

    public Burrito(String size, String protein) {
        this.size = size;
        this.protein = protein;
        this.rice = "White Rice";
        this.beans = "Black Beans";
        this.toppings = "Salsa, Sour Cream, Cheeese";
        this.guac = true;
    }

    public Burrito(String size, String protein, String rice, String beans, String toppings, boolean guac) {
        this.size = size;
        this.protein = protein;
        this.rice = rice;
        this.beans = beans;
        this.toppings = toppings;
        this.guac = guac;
    }

    public double getCost() {
        // small @ 5.00, lrg @ 7.50;; chicken n steak +2.00;;
        // carniats n sofritas +3.00;; rice +1.00; beans +1.00;;
        // toppings r free;; guac is +2.00
        double price = 5.00;

        if (size.equals("Large")) {
            price = price + 2.50;
        }
        if (protein.equals("Chicken") || protein.equals("Steak")) {
            price = price + 2.00;
        } else if (protein.equals("Carnitas") || protein.equals("Sofritas")) {
            price = price + 3.00;
        }
        if (rice.equals("White Rice") || rice.equals("Brown Rice")) {
            price = price + 1.00;
        }
        if (beans.equals("Black Beans") || beans.equals("Brown Beans")) {
            price = price + 1.00;
        }
        if (guac) {
            price = price + 2.00;
        }

        return price;

    }

    @Override
    public String toString() {

        String addGuac = "";

        if (!guac) {
            addGuac = "no";
        } else {
            addGuac = "some";
        }

        double price = getCost();

        return this.size + " " + this.protein + " Burrito with " +
                this.rice + ", " + this.beans + ", " + this.toppings +
                ", and " + addGuac + " guacamole.\n" + "This burrito costs: $" + price + "\n";

    }
}