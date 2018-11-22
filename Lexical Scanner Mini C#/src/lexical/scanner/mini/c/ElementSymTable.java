
package lexical.scanner.mini.c;

/**
 *
 * @author bryan
 */
public class ElementSymTable {   
    private String IdSym;
    private String value;
    private String typeClass;
    private String type;    
    private int numParameters;
    private String typeParameters;
    private String returnType;
    private boolean isInitialized;
    private int ambito;

    public ElementSymTable()
    {
        this.IdSym = null;
        this.value = null;
        this.typeClass = null;
        this.type = null;
        this.numParameters = 0;
        this.typeParameters = null;
        this.returnType = null;
        this.isInitialized = false;
        this.ambito = 0;
    }
    
    public ElementSymTable(String Id, String value, String typeClass, 
                           String type, int parameters, 
                           String typeParameters, String typeReturn, int ambito)
    {
        this.IdSym = Id;
        this.value = value;
        this.typeClass = typeClass;
        this.type = type;
        this.numParameters = parameters;
        this.typeParameters = typeParameters;
        this.returnType = typeReturn;
        this.isInitialized = (this.value != null);
        this.ambito = ambito;
    }
    
    @Override
    public String toString(){
        return this.IdSym + "\t\t\t\t\t\t" + this.value + "\t\t\t\t\t\t" + this.typeClass + "\t\t\t\t" + this.type
                + "\t\t\t\t" + this.numParameters + "\t\t\t\t" + this.typeParameters + "\t\t\t\t\t\t" + this.returnType
                + "\t\t\t\t" + this.isInitialized + "\t\t\t" + this.ambito;
    }
    
    public String getIdSym() {
        return IdSym;
    }

    public void setIdSym(String IdSym) {
        this.IdSym = IdSym;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getTypeClass() {
        return typeClass;
    }

    public void setTypeClass(String typeClass) {
        this.typeClass = typeClass;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getNumParameters() {
        return numParameters;
    }

    public void setNumParameters(int numParameters) {
        this.numParameters = numParameters;
    }

    public String getTypeParameters() {
        return typeParameters;
    }

    public void setTypeParameters(String typeParameters) {
        this.typeParameters = typeParameters;
    }

    public String getReturnType() {
        return returnType;
    }

    public void setReturnType(String returnType) {
        this.returnType = returnType;
    }

    public boolean isIsInitialized() {
        return isInitialized;
    }

    public void setIsInitialized(boolean isInitialized) {
        this.isInitialized = isInitialized;
    }
    
    public void setAmbito(int ambito){
        this.ambito = ambito;
    }
    
    public int getAmbito(){
        return this.ambito;
    }
     
}
