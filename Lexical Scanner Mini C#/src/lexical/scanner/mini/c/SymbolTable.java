
package lexical.scanner.mini.c;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author bryan
 */
public class SymbolTable {   
    
    private ArrayList<String> Log;
    private int ambito; 
    private ArrayList<TableBlock> symtable;
    private ArrayList<String> errors;

    public ArrayList<String> getErrors() {
        return errors;
    }

    public void setErrors(ArrayList<String> errors) {
        this.errors = errors;
    }
    private ArrayList<Integer> ambitosOcupados;
    
    public SymbolTable(){
        this.symtable = new ArrayList<>();
        this.errors = new ArrayList<String>();
        this.Log = new ArrayList<String>();
        this.ambitosOcupados= new ArrayList<Integer>();
        //Inicia en el ambito 0 --Ambito Global
        CreateNewSymTable(null,"Global", null);
        this.ambito = 0;
    }
    
    
    public void CrearLog(String path) throws IOException{
        String table = "";
        for(String element: Log){
            table += element + "\n";
        }
        
        File archivo = new File(path);
        BufferedWriter bw;
        if(!archivo.exists()) {
            bw = new BufferedWriter(new FileWriter(path));
            bw.write(table);
            bw.close();
        }
        else{
            archivo.delete();
            bw = new BufferedWriter(new FileWriter(path));
            bw.write(table);
            bw.close();
        }
    }
    
    public int getAmbito() {
        return ambito;
    }

    public void setAmbito(int ambito) {
        this.ambito = ambito;
    }
    
    public void CreateNewSymTable(String Id, String ambitName, String typeReturn){
        this.Log.add("*****************************************************************************************" +
                     "*****************************************************************************************" +
                     "*****************************************************************************************");
        this.Log.add("Ambito: " + ambitName);
        this.Log.add("Symbol" + "\t\t\t\t\t\t" + "Valor" + "\t\t\t\t\t\t" + "Clase" + "\t\t\t\t"
                + "Tipo de Dato" + "\t\t\t\t" + "Cantidad Parametros" + "\t\t\t\t" + "Parametros (Tipos)" +
                "\t\t\t\t\t\t" + "Tipo de Return" + "\t\t\t\t" + "¿Esta Inicializado?" + "\t\t\t" +
                "Ambito");
        this.symtable.add(new TableBlock(Id, ambitName, typeReturn));
        
        boolean continuar = false;
        this.ambito++;
        
        while(this.ambitosOcupados.contains(this.ambito)){
            this.ambito ++;
        }       
    }
     
    /*Agrega procedimientos y funciones*/
    public void AddNewSymbol(String Id, String value, String typeClass, 
                                String type, int parameters, 
                                String typeParameters, String typeReturn, int line, int column){
        
        boolean exists = false;

        if(this.symtable.get(this.ambito).Id.equals("Class")){
            exists = this.symtable.get(this.ambito).VerifyElement(Id); //Ambito actual
            exists = this.symtable.get(this.ambito).Id.equals(Id); //Verifico con el nombre de la clase
            //No es nececario --> exists = exists && this.symtable.get(this.ambito - 1).VerifyElement(Id);
        }      
        if(this.symtable.get(this.ambito).Id.equals("Global")){
            exists = this.symtable.get(this.ambito).VerifyElement(Id);
        }
              
        //Si es falso, quiere decir que no encontro simbolo alguno con el mismo nombre.
        if(!exists){
            //Por lo tanto lo agregamos en el ambito.
            this.symtable.get(this.ambito).AddNewElement(Id,  new ElementSymTable(Id, value, typeClass, type, parameters, typeParameters, typeReturn, this.ambito));
            this.Log.add("*****************************************************************************************" +
                     "*****************************************************************************************" +
                     "*****************************************************************************************"); 
            this.Log.add(this.symtable.get(this.ambito).GetElement(Id).toString());
        }else{
            line += 1;
            column += 1;
            this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: El ambito actual ya contiene una definicion para \'" + Id + "\'.");
        }         
    }
    
    /* Para ingresar variables a la tabla*/
    public boolean AddNewSymbol(String Id, String value, String typeClass, String type, int line, int column ){      
        int tempAmbito;
        boolean exists;
        
        switch(this.symtable.get(this.ambito).AmbitType){
            case "Global": //Global
                exists = this.symtable.get(this.ambito).VerifyElement(Id);
                //Si es falso, quiere decir que no encontro simbolo alguno con el mismo nombre.
                if(!exists){
                    //Por lo tanto lo agregamos en el ambito.
                    this.symtable.get(this.ambito).AddNewElement(Id, new ElementSymTable(Id, value, typeClass, type, 0, null, null, this.ambito));
                    this.Log.add(this.symtable.get(this.ambito).GetElement(Id).toString());
                    return true;
                }else{
                    line += 1;
                    column += 1;
                    this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: El ambito actual ya contiene una definicion para \'" + Id + "\'.");
                    return false;
                } 
            case "Class": //Clase               
                //Reviso con el nombre de la clase y con el ambito anterior (Global)
                exists = this.symtable.get(this.ambito).VerifyElement(Id) || this.symtable.get(this.ambito).Id.equals(Id);
                
                //Si es falso, quiere decir que no encontro simbolo alguno con el mismo nombre.
                if(!exists){
                    //Por lo tanto lo agregamos en el ambito.
                    this.symtable.get(this.ambito).AddNewElement(Id, new ElementSymTable(Id, value, typeClass, type, 0, null, null, this.ambito));
                    this.Log.add(this.symtable.get(this.ambito).GetElement(Id).toString());
                    return true;
                }else{
                    line += 1;
                    column += 1;
                    this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: El ambito actual ya contiene una definicion para \'" + Id + "\'.");
                    return false;
                }
            case "Function": //Funcion
                exists = this.symtable.get(this.ambito).VerifyElement(Id) || this.symtable.get(this.ambito).Id.equals(Id);;

                //Si es falso, quiere decir que no encontro simbolo alguno con el mismo nombre.
                if(!exists){
                    //Por lo tanto lo agregamos en el ambito.
                    this.symtable.get(this.ambito).AddNewElement(Id, new ElementSymTable(Id, value, typeClass, type, 0, null, null, this.ambito));
                    this.Log.add(this.symtable.get(this.ambito).GetElement(Id).toString());
                    return true;
                }else{
                    line += 1;
                    column += 1;
                    this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: El ambito actual ya contiene una definicion para \'" + Id + "\'.");
                    return false;
                } 
            case "Stmt": //Stmt
                exists = false;
                tempAmbito = this.ambito;
                while(!(this.symtable.get(tempAmbito).AmbitType.equals("Global")) && !(this.symtable.get(tempAmbito).AmbitType.equals("Class")) && tempAmbito >= 0 && !exists){
                    exists = this.symtable.get(tempAmbito).VerifyElement(Id);
                    tempAmbito --;
                    while(this.ambitosOcupados.contains(tempAmbito)){
                        tempAmbito--;
                    }
                }
                //Si es falso, quiere decir que no encontro simbolo alguno con el mismo nombre.
                if(!exists){
                    //Por lo tanto lo agregamos en el ambito.
                    this.symtable.get(this.ambito).AddNewElement(Id, new ElementSymTable(Id, value, typeClass, type, 0, null, null, this.ambito));
                    this.Log.add(this.symtable.get(this.ambito).GetElement(Id).toString());
                    return true;
                }else{
                    line += 1;
                    column += 1;
                    this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: El ambito actual ya contiene una definicion para \'" + Id + "\'.");
                    return false;
                }     
        }
        
        return false;
    }

    /* Para ingresar clases e interfaces a la tabla */
    public void AddNewSymbol(String Id, String typeClass, int line, int column, int ReferenceAmbit){
        
        //Al ser una clase, solo necesito validar que no se encuentre en su propio ambito.
        boolean exists = this.symtable.get(this.ambito).VerifyElement(Id);

        //Si es falso, quiere decir que no encontro simbolo alguno con el mismo nombre.
        if(!exists){
            //Por lo tanto lo agregamos en el ambito.
            this.symtable.get(this.ambito).AddNewElement(Id, new ElementSymTable(Id, null, typeClass, typeClass, 0, null, null, ReferenceAmbit));
            this.Log.add("*****************************************************************************************" +
                     "*****************************************************************************************" +
                     "*****************************************************************************************"); 
            this.Log.add(this.symtable.get(this.ambito).GetElement(Id).toString());
        }else{
            line += 1;
            column += 1;
            this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: El ambito actual ya contiene una definicion para \'" + Id + "\'.");
        }  
    }
    
    public boolean AddNewSymbol(String Id, String typeClass, int line, int column){
        
        //Al ser una clase, solo necesito validar que no se encuentre en su propio ambito.
        boolean exists = this.symtable.get(this.ambito).VerifyElement(Id);

        //Si es falso, quiere decir que no encontro simbolo alguno con el mismo nombre.
        if(!exists){
            //Por lo tanto lo agregamos en el ambito.
            this.symtable.get(this.ambito).AddNewElement(Id, new ElementSymTable(Id, null, typeClass, typeClass, 0, null, null, this.ambito));
            this.Log.add(this.symtable.get(this.ambito).GetElement(Id).toString());
            return true;
        }else{
            line += 1;
            column += 1;
            this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: El ambito actual ya contiene una definicion para \'" + Id + "\'.");
            return false;
        }  
    }
    
    public void AddValueToElement(String key, String value, String dType, int line, int column){
        boolean exists = false;
        int tempAmbito = this.ambito;
        while(tempAmbito >= 0 && !exists){
            exists = this.symtable.get(tempAmbito).VerifyElement(key);
            tempAmbito --;
        }
        
        ElementSymTable temp = this.symtable.get(tempAmbito+1).GetElement(key);
        
        if(dType.equals(temp.getType())){
            if(temp.getTypeClass().equals("Const"))
            {
                if(!temp.isIsInitialized()){
                    temp.setValue(value);
                    temp.setIsInitialized(true);
                    this.symtable.get(tempAmbito+1).tempSymTable.replace(key, temp);
                    this.Log.add(this.symtable.get(tempAmbito+1).GetElement(key).toString());
                }
                else{
                    this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: El valor de la constante \'" + key + "\' ya ha sido establecido y no se puede modificar.");
                }
            }else{
                temp.setValue(value);
                temp.setIsInitialized(true);
                this.symtable.get(tempAmbito+1).tempSymTable.replace(key, temp);
                this.Log.add(this.symtable.get(tempAmbito+1).GetElement(key).toString());
            }           
        }
        else{
            if(temp.getType().equals("double") &&  dType.equals("int"))
            {
                if(temp.getTypeClass().equals("Const")){
                   if(!temp.isIsInitialized()){
                        temp.setValue(value);
                        temp.setIsInitialized(true);
                        this.symtable.get(tempAmbito+1).tempSymTable.replace(key, temp);
                        this.Log.add(this.symtable.get(tempAmbito+1).GetElement(key).toString());
                   }else{
                        this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: El valor de la constante \'" + key + "\' ya ha sido establecido y no se puede modificar.");
                   }
                }else{
                    temp.setValue(value);
                    temp.setIsInitialized(true);
                    this.symtable.get(tempAmbito+1).tempSymTable.replace(key, temp);
                    this.Log.add(this.symtable.get(tempAmbito+1).GetElement(key).toString()); 
                }              
            }
            else{
                this.errors.add("*** Error. Linea: " + line + " Columna: " + column + ". *** Mensaje Error:No se puede asignar el valor, pues no son el mismo tipo de dato.");
            }
        }      
    }
    
    public String GetValueToElement(String key){
        String result = null;
        
        boolean exists = false;
        int tempAmbito = this.ambito;
        while(tempAmbito >= 0 && !exists){
            exists = this.symtable.get(tempAmbito).VerifyElement(key);
            tempAmbito --;
        }
        
        if(exists){
            result = this.symtable.get(tempAmbito + 1).GetElement(key).getValue();
        }       
        return result;
    }
    
    public void CreateInstancia(String key, int refAmbito, int line, int column){
        TableBlock aux = this.symtable.get(refAmbito);
        
        for (ElementSymTable element : aux.tempSymTable.values()) {
            this.AddNewSymbol(key + "." + element.getIdSym(), null, element.getTypeClass(), element.getType(), element.getNumParameters(), element.getTypeParameters(), element.getReturnType(), line, column);
        }     
    }
   
    public boolean VerifyFunction(String id, String ambit){
        boolean result = false;
        
        return result;
    }
    
    public String GetValueToElement(String key, int ambito){
        return this.symtable.get(ambito).GetElement(key).getValue();
    }
    
    public String GetTypeClassToElement(String key, int ambito){
        return this.symtable.get(ambito).GetElement(key).getTypeClass();
    }
    
    public String GetTypeToElement(String key, int ambito){
        return this.symtable.get(ambito).GetElement(key).getType();
    }
   
    public int GetLocalAmbit(String key, int ambito){
        return this.symtable.get(ambito).GetElement(key).getAmbito();
    }
    
    public boolean VerifyElement(String key){
        boolean exists = false;
        int tempAmbito = this.ambito;
        while(tempAmbito >= 0 && !exists){
            exists = this.symtable.get(tempAmbito).VerifyElement(key);
            tempAmbito --;
            while(this.ambitosOcupados.contains(tempAmbito)){
                tempAmbito --;
            }
        }
        return exists;
    }
    
    public int GetAmbito(String key){
        boolean exists = false;
        int tempAmbito = this.ambito;
        while(tempAmbito >= 0 && !exists){
            exists = this.symtable.get(tempAmbito).VerifyElement(key);    
            if(exists){
                break;
            }else{
                tempAmbito --;
                while(this.ambitosOcupados.contains(tempAmbito)){
                    tempAmbito --;
                } 
            }         
        }
        return tempAmbito;
    }
    
    public void DeleteAmbitFunction(){
        //Elimino el ambito donde se construyo la función
        this.symtable.remove(this.ambito);
        this.ambito --;
        while(this.ambitosOcupados.contains(this.ambito)){
            this.ambito--;
        }
    }
    
    public int DeleteAmbitClass(){
        //Bloqueo el ambito para poder usarlo despues
        this.ambitosOcupados.add(this.ambito);
        
        int localAmbit = this.ambito;
        
        this.ambito--;
        while(this.ambitosOcupados.contains(this.ambito)){
            this.ambito--;
        }
        return localAmbit;
    }
    
    public boolean VerifyClass(int tipo, String id){
        boolean result = false;
        
        switch(tipo){
            case 1:
                return (this.symtable.get(0).GetElement(id).getTypeClass().equals("Class"));
               
            case 2:
                return (this.symtable.get(0).GetElement(id).getTypeClass().equals("Interface"));
        }       
        return result;
    }
    
    public void AddError(String msg, int line, int column){
        line += 1;
        column += 1;
        this.errors.add("*** Error. Linea: " + line + " Columna: " + column +". *** Mensaje Error: " + msg);
    }

    public void BloquearAmbito(int ambito){
        this.ambitosOcupados.add(ambito);
    }
}
