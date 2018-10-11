# Mini C# (Analizador Léxico y Sintáctico)

## Descripcion

**Mini C#** Es un analizador léxico y sintáctico para una pequeña parte del lenguaje de programación C#.
Su función se lleva acabo en 2 etapas, la primera parte es el análisis léxico y consiste en reconocer tokens 
segun el orden de lectura del archivo, y en base a expresiones regulares el programa separará los tokens 
como correctos o errores, la segunda parte es el análisis sintáctico, recibe como entrada el resultado del 
análisis léxico y en base a las reglas gramaticales definidas en la grámatica formal definida, el cual genera un 
analizador y tabla de simbolos, para lograr estas funcines se hizo uso de las herramientas JFLEX y CUP los cuales
generan código en JAVA.

## Requerimientos del software

Para el correcto funcionamiento del programa **Mini C#** es necesario contar con la Virtual Machine de
Java instalada en la PC:

 - Si no se tiene instalado puede descargarlo de la página oficial https://www.java.com/en/download/

## ¿Comó utilizar el software?

El algoritmo que describe el funcionamiento del software es el siguiente:
 1. Ejecutar la aplicación .Jar.
 2. Cargar un archivo con código Mini C# (.frag, .txt)
 3. Analizar el código para válidar los tokens.
 4. Analizar el resultado del análisis léxico y validar si los tokens cumplen las reglas sintácticas.
 5. Se mostrará en pantalla el resultado del análisis general.
 
 **Nota** Es importante recalcar que previamente el analizador léxico tuvo que haber sido compilado.
 
### Ejecutar la aplicación

#### Clikeando sobre el icono de la aplicación
	
Una vez tenga la carpeta del proyecto dirigase a la carpeta _Lexical Scanner Mini C#_ , una vez este dentro
de esta carpeta dirigase a la carpeta _dist_ y dentro de esta carpeta encontrará el archivo llamado
_MiniC#.jar_, para ejecutarlo pulse doble-click sobre este archivo.

La ruta relativa del archivo ejecutable es:
```
\Lexical Scanner Mini C#\dist\MiniC#.jar
```
	
#### Consola
	
Debe ubicarse donde se encuentre la carpeta del programa, una vez dentro de ella ejecute el siguiente comando:
```
java -jar Lexical Scanner Mini C#\dist\MiniC#.jar
```

Una vez se ejecutado el programa se mostrará la siguiente pantalla:

![MiniC](https://image.ibb.co/jOZD69/MiniC.jpg)

### Cargar Archivo Mini C#

Para cargar un archivo con código de Mini C#:
1. Dirigase al boton **Cargar Archivo**
2. Presione click sobre este boton 

![MiniC-Cargar](https://image.ibb.co/jB9KeU/LoadFile.jpg)

Se mostrará el manejador de carpetas y archivos, en esta pantalla tendra que buscar y 
seleccionar el archivo **(.frag, .txt)** deseado.

![MiniC-Cargar2](https://image.ibb.co/mwxpeU/Explorador-Archivos-LF.jpg)

### Analizar Archivo Mini C#

Para analizar un archivo Mini C#:
1. Dirigase al boton **Analizar**
2. Presione click sobre este boton 

![MiniC-Analizar1](https://image.ibb.co/mn9Vm9/Analizar-Mini-C.jpg)

Esto inicializará el análisis del archivo cargado anteriormente y una vez este finalice
se mostrará el resultado del análisis en pantalla.

![MiniC-MostrarSE](https://image.ibb.co/eSXBtp/Mostrar-Mini-C.jpg)

![MiniC-MostrarCE](https://image.ibb.co/ewSNzU/Mostrar-CEMini-C.jpg)

### *Compilar Analizadores

Cabe recalcar que esta función está unicamente disponible para el desarrollador, puesto que para la 
ejecución correcta del software es necesario que el analizador léxico y sintáctico se encuentren ya compilados. 
Por lo tanto el botón **Compilar Analizador** se encontrará deshabilitado.

![MiniC-Compilar](https://image.ibb.co/iyCVKU/Compilar-Mini-C.jpg)

## Manejo De Errores

Para el manejo de errores léxicos, se hizo uso de la expresion '.' de JFLEX, esta expresion regular se caracteriza
por ejecutarse cuando ninguna expresion regular coincidio con el token actual por lo que esta fuera del
lenguaje se podria decir. Además se diseñaron expresiones regulares que permiten capturar errores especificos. 
La acción que se realiza consiste en agregar el error como un token a la lista, detallando el token,
numero de linea y numero de columna donde ocurrio el error y que tipo de error es.

```
{this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true));}
``
Para el manejo de errores sintácticos, se hizo uso de las herramientas de CUP, para ello definio dentro de la gramatica
formal, producciones que generaran el token error y cuando eso sucede se llama al método de error correspondiente y dentro 
de este método se agrega a una lista de errores para poder mostrarlos en pantalla más adelante, de igual forma que los 
errores léxicos, se detalla el numero de linea y numero de columna donde ocurrio el error y que tipo de error es.

```
Decl ::=  VariableDecl
		| FunctionDecl
        | ClassDecl
        | InterfaceDecl
        | error pyc
        | error ClosedCurlyBracket;
``

## Opinion del Autor

A mi criterio el software **Mini C#** desarrollado por mi persona, funciona de manera correcta puesto que
se realizaron distintas pruebas para verificar que no generará problemas al momento de ejecutarlo en cualquier
PC, además su correcto funcionamiento tambien abarca la exactitud léxica y sintáctica que posee para analizar los archivos
escritos en Mini C#, se escribieron expresiones regulares bastante grandes que tratan de abarcar la mayor cantidad
de casos posibles y se modifico la grámatica formal proporcionada para mejorar el funcionamiento de los analizadores,
además se hizo una investigación profunda respecto a las herramientas JFLEX y CUP para su correcto uso.

## Información del Autor
	
**Bryan Macario Coronado**

_Estudiante de ingeniería en informática y sistemas_

_Curso de Compiladores_

_Universidad Rafael Landivar_