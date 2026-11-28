import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) throws FileNotFoundException {

        RatingsTree myMovie = new RatingsTree();
        Scanner movies = new Scanner(new File("C:\\Users\\g-lap\\Desktop\\Data Structures - CSCI2 010U\\Lab Course\\Lab 10\\Lab10_GraemeJeffreys\\src\\movies.txt"));
        while (movies.hasNext()){
            int rating = movies.nextInt();
            String genre = movies.next();
            String title = movies.nextLine().trim();
            myMovie.insert(title, rating, genre);
        }
        movies.close();

        System.out.println();
        System.out.println("All movies, sorted by ranking:");
        Movie[] sorted = myMovie.getSortedMovies();
        for (Movie m : sorted) {
            System.out.println(m);
        }
        myMovie.printAll();
        System.out.println();


        myMovie.findMoviesAtLeast(90);
        System.out.println();
        System.out.println();
        myMovie.findMoviesLower(10);
        System.out.println("\n"
        );
        myMovie.findAllGenre("Romance");
        System.out.println();

    }
}