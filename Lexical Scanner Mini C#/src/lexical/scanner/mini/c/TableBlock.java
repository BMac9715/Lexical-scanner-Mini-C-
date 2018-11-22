
package lexical.scanner.mini.c;

import java.util.HashMap;
/**
 *
 * @author bryan
 */
public class TableBlock {
    HashMap<String, ElementSymTable> tempSymTable;
    String AmbitType;
    String TypeReturn;
    String Id;
    
    public TableBlock(){
        this.tempSymTable = new HashMap<String, ElementSymTable>();
        this.AmbitType = null;
        this.TypeReturn = null;
        this.Id = null;
    }
    
    public TableBlock(String Id, String nameAmbit, String typeReturn){
        this.tempSymTable = new HashMap<String, ElementSymTable>();
        this.AmbitType = nameAmbit;
        this.TypeReturn = typeReturn;
        this.Id = Id;
    }
    
    public ElementSymTable GetElement(String key){
        return this.tempSymTable.get(key);
    }
    
    public boolean VerifyElement(String key){
        return this.tempSymTable.containsKey(key);
    }
    
    public void AddNewElement(String key, ElementSymTable element){
        this.tempSymTable.put(key, element);
    }
}
