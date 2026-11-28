public class node<E> {
    E value;
    node<E> next;
    node<E> prev;

    public node(E value) {
        this.value = value;
        this.next = null;
        this.prev = null;
    }

    public E getValue(){
        return value;
    }

    public node<E> getNext(){
        return next;
    }

    public node<E> getPrev(){
        return prev;
    }

    public void setValue(E val){
        value = val;
    }

    public void setNext(node<E> next){
        this.next = next;
    }

    public void setPrev(node<E> prev){
        this.prev = prev;
    }

}