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
        return "*** Error Line " +line+ "\n*** Cols "+column+"-"+aux+" *** " + type + ": '" + token +"'";
    }
}

%%
/* Options and declarations */
%class LexicalScanner
%cupsym sym
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
Types = ("int")|("double")|("bool")|("string")
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
{Types}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.types, yyline, yycolumn, yytext());}
{Null}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sNull, yyline, yycolumn, yytext());}
{For}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.lFor, yyline, yycolumn, yytext());}
{While}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.lWhile, yyline, yycolumn, yytext());}
{If}                        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.cIf, yyline, yycolumn, yytext());}
{Else}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.cElse, yyline, yycolumn, yytext());}
{Void}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sVoid, yyline, yycolumn, yytext());}
{Class}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sClass, yyline, yycolumn, yytext());}
{Interface}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sInterface, yyline, yycolumn, yytext());}
{Extends}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sExtends, yyline, yycolumn, yytext());}
{This}                      {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sThis, yyline, yycolumn, yytext());}
{Print}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sPrint, yyline, yycolumn, yytext());}    
{Implements}                {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sImplements, yyline, yycolumn, yytext());}
{NewArray}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sNewArray, yyline, yycolumn, yytext());}
{New}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sNew, yyline, yycolumn, yytext());}
{ReadInteger}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sReadInteger, yyline, yycolumn, yytext());}
{ReadLine}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sReadLine, yyline, yycolumn, yytext());}
{Malloc}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sMalloc, yyline, yycolumn, yytext());}
{GetByte}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sGetByte, yyline, yycolumn, yytext());}
{SetByte}                   {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sSetByte, yyline, yycolumn, yytext());}
{Return}                    {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sReturn, yyline, yycolumn, yytext());}
{Break}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeReservedWords(yytext()), false)); return new Symbol(sym.sBreak, yyline, yycolumn, yytext());}
/*  Constants   */
{LogicalConstants}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_LogicalConstant", false)); return new Symbol(sym.boolConstant, yyline, yycolumn, yytext());}
{IntegerConstants}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_IntConstant"), false)); return new Symbol(sym.integerConstant, yyline, yycolumn, yytext());}
{DoubleConstants}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_DoubleConstant"), false)); return new Symbol(sym.doubleConstant, yyline, yycolumn, yytext());}
{StringConstants}           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, this.typeNumbers(yytext(), "T_String"), false)); return new Symbol(sym.stringConstant, yyline, yycolumn, yytext());}
{ArithmeticOperators}       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.ArithmeticOperators, yyline, yycolumn, yytext());}
{ComparisonOperators}       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.ComparisonOperators, yyline, yycolumn, yytext());}
{SumOperator}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.sum, yyline, yycolumn, yytext());}
{NegativeOperator}          {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.negative, yyline, yycolumn, yytext());}
{EqualityOperators}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.equality, yyline, yycolumn, yytext());}
{LogicalAnd}                {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.and, yyline, yycolumn, yytext());}
{LogicalOr}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.or, yyline, yycolumn, yytext());}
{AssignmentOperator}        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.assignment, yyline, yycolumn, yytext());}
{DenialOperator}            {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.denial, yyline, yycolumn, yytext());}
{OpeningParenthesis}        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.OpeningParenthesis, yyline, yycolumn, yytext());}
{ClosedParenthesis}         {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.ClosedParenthesis, yyline, yycolumn, yytext());}
{Parenthesis}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.Parenthesis, yyline, yycolumn, yytext());}
{OpeningBracket}            {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.OpeningBracket, yyline, yycolumn, yytext());}
{ClosedBracket}             {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.ClosedBracket, yyline, yycolumn, yytext());}
{Brackets}                  {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.Brackets, yyline, yycolumn, yytext());}
{OpeningCurlyBracket}       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.OpeningCurlyBracket, yyline, yycolumn, yytext());}
{ClosedCurlyBracket}        {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.ClosedCurlyBracket, yyline, yycolumn, yytext());}
{CurlyBrackets}             {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.CurlyBrackets, yyline, yycolumn, yytext());}
{Semicolon}                 {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.pyc, yyline, yycolumn, yytext());}
{Comma}                     {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.comma, yyline, yycolumn, yytext());}
{Dot}                       {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "\'"+ yytext()+"\'", false)); return new Symbol(sym.dot, yyline, yycolumn, yytext());}
/*  Identifiers  */
{Identifiers}               {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "T_Identifier", false)); return new Symbol(sym.ident, yyline, yycolumn, yytext());}
{WhiteSpace}                { /* ignore */ }
{Comments}                  { /* ignore */ }
/*Errors*/
.                           {this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true)); /* It's error so it doesn't return nothing */}
{MultiLineCommentError}     {this.tokens.add(new Yytoken("", yyline, yycolumn, "The character '*/' wasn't found", true)); /* It's error so it doesn't return nothing */}