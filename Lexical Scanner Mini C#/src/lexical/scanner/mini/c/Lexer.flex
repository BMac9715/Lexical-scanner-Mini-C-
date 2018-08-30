/* User code */
package lexical.scanner.mini.c;

//Java Libraries

import java.util.ArrayList;

class Yytoken{
    public String token;
    public int line;
    public int column;
    public int length;
    public String type;
    public boolean error;

    Yytoken(String token, int line, int column, String type, boolean error){
        this.token = token;
        this.line = line;
        this.column = column+1;
        this.length = token.length()-1;
        this.type = type;
        this.error = error;
    }

    public String toString(){
        int aux = column + length;
        if(this.type.equals("T_Identifier")){
            if(token.length() > 31){
                String temp = this.token.substring(0,31);
                String aditional = this.token.substring(31);
                return temp + "\t\tLine "+line+"\tcols "+column+"-"+aux+"\tis "+ type + " Number of characters greater than 31 - Discarded characters {"+aditional+"}";
            }
            else{
                return token + "\t\tLine "+line+"\tcols "+column+"-"+aux+"\tis "+ type;
            }
        }
        else{
            return token + "\t\tLine "+line+"\tcols "+column+"-"+aux+"\tis "+ type;
        }   
    }

    public String isError(){
        int aux = column + length;
        return "*** Error Line " +line+ "\n*** Cols "+column+"-"+aux+" *** " + type + ": '" + token +"'";
    }
}

%%
/* Options and declarations */
%class LexicalScanner
%public
%function nextToken
%unicode
%caseless //Case sensitive
%char
%line
%column

/* Java code */

%init{ 
this.tokens = new ArrayList<Yytoken>();
%init}

%{

public ArrayList<Yytoken> tokens; /* our variable for storing token's info that will be the output */

private String typeReservedWords(String text){
    return  "T_" + text.substring(0, 1).toUpperCase() + text.substring(1);
}

private String typeNumbers(String text, String type){
    return type + " (value = " + text + ")";
}

private String isError(String token, int line, int column, int length, String error){
    int aux = column + length;
    return "*** Line " +line+ " *** Cols "+column+"-"+aux+" *** " + error + " \'" + token +"\'";
}

%}

/*Macro Definition*/

/* Reserved words */
ReservedWords = ("void")|("int")|("double")|("bool")|("string")|("class")|("interface")|("null")|("this")|("extends")|("implements")|("for")|("while")|("if")|("else")|("return")|("break")|("New")|("NewArray")

/* Identifiers */
Identifiers = [a-zA-Z]([a-zA-Z0-9_])*

/* White spaces */
LineTerminator = (\r)|(\n)|(\r\n)
Space          = (" ")|(\t)|(\t\f)

WhiteSpace     = {LineTerminator}|{Space}

/* Comments */
InputCharacter   = [^\r\n]

MultiLineComment = ("/*"~"*/")
MultiLineCommentError = ("/*")([^"*/"])*
LineComment = ("//"){InputCharacter}*{LineTerminator}?

Comments = {MultiLineComment} | {LineComment}

/* Constants */
LogicalConstants = ("true")|("false")

// Integer Constants
DecimalNumbers     = [0-9]+
HexadecimalNumbers = "0"[xX][0-9a-fA-F]+

IntegerConstants   = {DecimalNumbers} | {HexadecimalNumbers}

// Double Constants
Digits = [0-9]+
FloatNumbers = ({Digits})([\.])([0-9]*)
ExponentialNumbers = ([+-]?)({FloatNumbers})([eE][+-]?)({Digits})

DoubleConstants = {FloatNumbers} | {ExponentialNumbers}

// Strings Constants
StringConstants = (\"([^\n\\\"]|\\.)*\")
MultiLineStringError = (\"([^\n\"])*)(\n)
UnrecognizedCharacters = (\")(\r\n)

// Operators and punctuation characters
Operators = ("+")|("-")|("*")|("/")|("%")|("<")|("<=")|(">")|(">=")|("=")|("==")|("!=")|("&&")|("||")
PunctuationCharacters = ("!")|(";")|(",")|(".")|("(")|(")")|("[")|("]")|("{")|("}")|("()")|("[]")|("{}")

%%

/* Lexical rules */

{UnrecognizedCharacters}    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true)); return new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true);}
{ReservedWords}             {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false);}
{LogicalConstants}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_LogicalConstant", false)); return new Yytoken(yytext(), yyline, yycolumn, "T_LogicalConstant", false);}
{Identifiers}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_Identifier", false)); return new Yytoken(yytext(), yyline, yycolumn, "T_Identifier", false);}
{WhiteSpace}                { /* ignore */ }
{Comments}                  { /* ignore */ }
{IntegerConstants}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_IntConstant"), false)); return new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_IntConstant"), false);}
{DoubleConstants}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_DoubleConstant"), false)); return new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_DoubleConstant"), false);}
{StringConstants}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_String"), false)); return new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_String"), false);}
{Operators}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false);}
{PunctuationCharacters}     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false);}

.                           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true)); return new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true);}
{MultiLineCommentError}     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "The character '*/' can not be found", true)); return new Yytoken(yytext(), yyline, yycolumn, "The character '*/' can not be found", true);}
{MultiLineStringError}      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "The closing character '\"' was not found", true)); return new Yytoken(yytext(), yyline, yycolumn, "The closing character '\"' was not found", true);}
