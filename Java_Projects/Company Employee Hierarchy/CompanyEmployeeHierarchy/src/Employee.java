import java.util.LinkedList;

/**
 * Represents an employee in a company.
 */
public class Employee {
    static Employee dnr;
    private final String name;
    private double salary;
    private String position;
    private Employee supervisor;
    private final LinkedList<Employee> employees;

    /**
     * Constructs an employee with the specified name, salary, and position.
     *
     * @param name     the name of the employee
     * @param salary   the salary of the employee
     * @param position the position of the employee
     */
    public Employee(String name, double salary, String position) {
        this.name = name;
        this.salary = salary;
        this.position = position;
        this.supervisor = null;
        this.employees = new LinkedList<>();
    }

    /**
     * Gets the name of the employee.
     *
     * @return the name of the employee
     */
    public String getName() {
        return name;
    }

    /**
     * Gets the salary of the employee.
     *
     * @return the salary of the employee
     */
    public double getSalary() {
        return salary;
    }

    /**
     * Gets the position of the employee.
     *
     * @return the position of the employee
     */
    public String getPosition() {
        return position;
    }

    /**
     * Gets the supervisor of the employee.
     *
     * @return the supervisor of the employee
     */
    public Employee getSupervisor() {
        return supervisor;
    }

    /**
     * Gets the list of employees supervised by this employee.
     *
     * @return the list of employees supervised by this employee
     */
    public LinkedList<Employee> getEmployees() {
        return employees;
    }

    /**
     * Sets the salary of the employee.
     *
     * @param salary the new salary of the employee
     */
    public void setSalary(double salary) {
        this.salary = salary;
    }

    /**
     * Sets the position of the employee.
     *
     * @param position the new position of the employee
     */
    public void setPosition(String position) {
        this.position = position;
    }

    /**
     * Sets the supervisor of the employee.
     *
     * @param supervisor the new supervisor of the employee
     */
    public void setSupervisor(Employee supervisor) {
        this.supervisor = supervisor;
    }


    //---------------------------------------------------------------------------------------------------------------
    /**
     * Hires a new employee under this employee's supervision.
     *
     * @param employee the employee to be hired
     */
    public void hireEmployee(Employee employee) {
        // TODO: complete this method for PART 1
        //set this new employee as an employee and then set their supervisor
        this.employees.add(employee);
        employee.setSupervisor(this);
    }

    /**
     * Calculates the total number of employees supervised by this employee.
     * (Hint: count the nodes in your tree from this point on - DFS)
     *
     * @return the total number of employees supervised by this employee
     */
    public int numOfEmployees() {
        // TODO: complete this method for PART 1
        int count = employees.size();
        //iterates through tree and counts employees for the supervisor/manager/ceo/etc
        for (Employee e : employees) {
            count += e.numOfEmployees();
        }
        return count;
    }

    /**
     * Prints the employees supervised by this employee. Display it nicely with
     * correct formatting. The depth will help you space it out.
     * (Hint: you want to visit all employees in a specific order)
     *
     * Example:
     * A
     *      B
     *      C
     *          D
     *          E
     *      F
     *
     * @param depth the depth of the employee in the hierarchy
     */
    public void printEmployees(int depth) {
        // TODO: implement this method for PART 1
        for (int i = 0; i < depth; i++) {
            System.out.print("    "); //tab = 4 spaces
        }
        System.out.println(this.position + ", " + this.name +" ($"+ this.salary+")");
        //print the supervisors using recursion while increasing the depth.
        //^^ this is to print from ceo down or supervisor down and avoid
        //printing the upper end of hierarchy past the established boundary "depth"
        for (Employee e : employees) {
            e.printEmployees(depth + 1);
        }
    }

    /**
     * Simulates the employee leaving the company and promoting the necessary
     * replacements.
     */
    public void leaveCompany() {
        if (this.getSupervisor() == null) {
            System.out.println("The CEO cannot leave the company!");
            return;
        }
        promoteSeniorEmployee(this);
        this.getSupervisor().getEmployees().remove(this);
    }

    /**
     * Promotes the senior-most employee in the hierarchy under the specified supervisor.
     * This method recursively promotes the first employee found in the supervisor's direct reports,
     * adjusting their position, supervisor, and salary, and reassigning their subordinates to the promoted employee.
     * If the promoted employee has subordinates, the method recursively promotes them as well.
     *
     * The order of seniority MUST be maintained. Seniority is noted by position on a team (i.e. the index of their
     * position in the employees list). So when someone is promoted, they should join the end of the supervisor's list,
     * not take the place of the person they replace. Also, when someone gets promoted over their peers, their peers
     * should be added to their list of employees before their newly promoted replacement.
     *
     * Example: Bob supervises Chris, Danielle, and Eric; Chris supervises Frances and Gerry; the structure would be:
     *      Bob
     *          Chris
     *              Frances
     *              Gary
     *          Danielle
     *          Eric
     *
     *  But after Bob leaves, and we apply the promotions, it would be:
     *      Chris
     *          Danielle
     *          Eric
     *          Frances
     *              Gary
     *
     * @param employee The supervisor whose senior-most employee is to be promoted.
     */
    public void promoteSeniorEmployee(Employee employee) {
        //test if ceo
        if (employee.getSupervisor() == null) {
            System.out.println("The CEO cannot leave the company!");
            //test if no subs
        } else if(employee.numOfEmployees() == 0) {
            //employee.getSupervisor().getEmployees().remove(employee);
            return;
            //if subs then make next first sub the boss and assign the subs to them
        } else if (!employee.getEmployees().isEmpty()) {
            //get list of subs
            LinkedList<Employee> subs = new LinkedList<>(employee.getEmployees());
            //remove the first and set to next
            Employee next = subs.removeFirst();

            employee.getSupervisor().getEmployees().remove(employee);
            //get prev pos and set as new pos for next
            String position = employee.getPosition();
            String name = next.getName();
            next.setPosition(position);

            // set new supervisor for next
            next.setSupervisor(employee.getSupervisor());
            Employee supervisor = next.getSupervisor();
            supervisor.getEmployees().add(next);

            if (!subs.isEmpty()) {
                for (Employee e : subs) {
                    e.setSupervisor(next);
                }
            }

            if (next.numOfEmployees() == 0) {
                employee.getSupervisor().getEmployees().remove(employee);
                return;
                //if subs then make next first sub the boss and assign the subs to them
            } else {
                //set subs for next
                for (Employee e : employee.getEmployees()) {
                    e.setSupervisor(next);
                    next.getEmployees().add(e);
                }
            }

            employee.getSupervisor().getEmployees().remove(employee);

            System.out.println(next.getEmployees());
            if(next.numOfEmployees() > 0) {
                promoteSeniorEmployee(next);
            }
        }
    }

}
