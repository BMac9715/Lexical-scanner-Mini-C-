/* User code */
package lexical.scanner.mini.c;

//Java Libraries

import java.util.ArrayList;
import java_cup.runtime.Symbol;

class Yytoken{
    public String token;
    public int line;
    public int column;
    public int length;
    public String type;
    public boolean error;

    Yytoken(String token, int line, int column, String type, boolean error){
        this.token = token;
        this.line = line+1;
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
        return "*** Error Léxico. Linea: " +line+ " Columnas: "+column+"-"+aux+" *** Mensaje Error: " + type + " \'" + token +"\'";
    }
}

%%
/* Options and declarations */
%class LexicalScanner
%cup
%public
%unicode
//%caseless //Case sensitive
%char
%line
%column

/* Java code */

%init{ 
this.tokens = new ArrayList<Yytoken>();
%init}

%{

private Symbol symbol(int type){
    return new Symbol(type, yyline, yycolumn, yytext());
}

private Symbol symbol(int type, Object value){
    return new Symbol(type, yyline, yycolumn, value);
}

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
Int = ("int")
Double = ("double")
Bool = ("bool")
String = ("string")
Null = ("null")
For = ("for")
While = ("while")
If = ("if")
Else = ("else")
Void = ("void")
Class = ("class")
Interface = ("interface")
Extends = ("extends")
This = ("this")
Print = ("Print")
Implements = ("implements")
NewArray = ("NewArray")
New = ("New")
ReadInteger = ("ReadInteger")
ReadLine = ("ReadLine")
Malloc = ("Malloc")
GetByte = ("GetByte")
SetByte = ("SetByte")
Return = ("return")
Break = ("break")

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
UnrecognizedCharacters = (\")

// Operators
ArithmeticOperators = ("*")|("/")|("%")
SumOperator = ("+")
NegativeOperator = ("-")
ComparisonOperators = ("<")|("<=")|(">")|(">=")
EqualityOperators = ("==")|("!=")
LogicalAnd = ("&&")
LogicalOr = ("||")
AssignmentOperator = ("=")
DenialOperator = ("!")

// Punctuation characters
OpeningParenthesis = ("(")
ClosedParenthesis = (")")
Parenthesis = ("()")
OpeningBracket = ("[")
ClosedBracket = ("]")
Brackets = ("[]")
OpeningCurlyBracket = ("{")
ClosedCurlyBracket = ("}")
CurlyBrackets = ("{}")
Semicolon = (";")
Comma = (",")
Dot= (".")

%%

/*  Lexical rules    */

{UnrecognizedCharacters}    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true)); /* It's error so it doesn't return nothing */}
/*  Reserved Words  */
{Int}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.INT);}
{Double}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.DOUBLE);}
{Bool}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.BOOL);}
{String}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.STRING);}
{Null}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sNull);}
{For}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.lFor);}
{While}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.lWhile);}
{If}                        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.cIf);}
{Else}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.cElse);}
{Void}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sVoid);}
{Class}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sClass);}
{Interface}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sInterface);}
{Extends}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sExtends);}
{This}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sThis);}
{Print}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sPrint);}    
{Implements}                {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sImplements);}
{NewArray}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sNewArray);}
{New}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sNew);}
{ReadInteger}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sReadInteger);}
{ReadLine}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sReadLine);}
{Malloc}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sMalloc);}
{GetByte}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sGetByte);}
{SetByte}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sSetByte);}
{Return}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sReturn);}
{Break}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return symbol(sym.sBreak);}
/*  Constants   */
{LogicalConstants}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_LogicalConstant", false)); return symbol(sym.boolConstant);}
{IntegerConstants}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_IntConstant"), false)); return symbol(sym.integerConstant);}
{DoubleConstants}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_DoubleConstant"), false)); return symbol(sym.doubleConstant);}
{StringConstants}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_String"), false)); return symbol(sym.stringConstant);}
{ArithmeticOperators}       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ArithmeticOperators);}
{ComparisonOperators}       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ComparisonOperators);}
{SumOperator}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.sum);}
{NegativeOperator}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.negative);}
{EqualityOperators}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.equality);}
{LogicalAnd}                {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.and);}
{LogicalOr}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.or);}
{AssignmentOperator}        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.assignment);}
{DenialOperator}            {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.denial);}
{OpeningParenthesis}        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.OpeningParenthesis);}
{ClosedParenthesis}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ClosedParenthesis);}
{Parenthesis}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.Parenthesis);}
{OpeningBracket}            {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.OpeningBracket);}
{ClosedBracket}             {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ClosedBracket);}
{Brackets}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.Brackets);}
{OpeningCurlyBracket}       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.OpeningCurlyBracket);}
{ClosedCurlyBracket}        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.ClosedCurlyBracket);}
{CurlyBrackets}             {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.CurlyBrackets);}
{Semicolon}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.pyc);}
{Comma}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.comma);}
{Dot}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return symbol(sym.dot);}
/*  Identifiers  */
{Identifiers}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_Identifier", false)); return symbol(sym.ident);}
{WhiteSpace}                { /* ignore */ }
{Comments}                  { /* ignore */ }
/*Errors*/
.                           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true)); /* It's error so it doesn't return nothing */}
{MultiLineCommentError}     {this.tokens.add(new Yytoken("", yyline, yycolumn, "The character '*/' wasn't found", true)); /* It's error so it doesn't return nothing */}