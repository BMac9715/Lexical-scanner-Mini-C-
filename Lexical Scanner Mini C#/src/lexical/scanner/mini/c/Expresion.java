
package lexical.scanner.mini.c;

/**
 *
 * @author bryan
 */
public class Expresion {
    String id;
    String dType;
    String type;
    String value;
    boolean exists;
    int ambit;
    
    public Expresion(){
        this.id = null;
        this.type = null;
        this.dType = null;
        this.value = null;
        this.exists = false;
        this.ambit = 0;
    }
}
