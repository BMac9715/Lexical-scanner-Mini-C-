/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package lexical.scanner.mini.c;

/**
 *
 * @author bryan
 */
public class Variable {
    public String identificador;
    public String valor;
    public String tipo;
    public String clase;
    public int line;
    public int column;
    
    public Variable(){
        this.identificador = null;
        this.valor = null;
        this.tipo = null;
        this.clase = null;
        this.line = 0;
        this.column = 0;
    }
     
}
