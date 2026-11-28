public class Lab9P1 {
    public static void main(String[] args) {

        // TEST THE METHODS FOR PART 1

        //create the employees of the company
        Employee jordan = new Employee("Jordan", 220000, "CEO");
        Employee taylor = new Employee("Taylor", 160000, "Director");
        Employee morgan = new Employee("Morgan", 130000, "Manager");
        Employee riley = new Employee("Riley", 125000, "Manager");
        Employee avery = new Employee("Avery", 120000, "Manager");
        Employee casey = new Employee("Casey", 95000, "Developer");
        Employee jamie = new Employee("Jamie", 90000, "Developer");

        //build tree top down
        jordan.hireEmployee(taylor);
        taylor.hireEmployee(morgan);
        taylor.hireEmployee(riley);
        taylor.hireEmployee(avery);
        morgan.hireEmployee(casey);
        morgan.hireEmployee(jamie);

        //test number of employees for each level
        System.out.println("# employees under CEO: " + jordan.numOfEmployees());
        System.out.println("# employees under Taylor: " + taylor.numOfEmployees());
        System.out.println("# employees under Morgan: " + morgan.numOfEmployees());
        System.out.println();

        System.out.println("Current tree: ");
        //use depth 0 to include ceo
        jordan.printEmployees(0);
        System.out.println();
    }
}