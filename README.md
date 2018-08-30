# Analizador Léxico Mini C#

## Descripcion

**Mini C#** Es un escáner léxico para una parte del lenguaje de programación C#.
Su función basicamente es reconocer tokens segun el orden de lectura del archivo, en base a 
expresiones regulares el programa separará los tokens como correctos o errores, tanto tokens
como errores serán mostrados en pantalla y si el usuario lo desea se generará un archivo (.out)
que contenga tokens y errores. Las expresiones regulares fuerón implementedas en un metacompilador
que genera analizadores léxicos en basea ellas, se hizo uso del metacompilador JFLEX que implementa 
el analizador en código de JAVA.

## Requerimientos del software

Para el correcto funcionamiento del programa **Mini C#** es necesario contar con la Virtual Machine de
Java instalada en la PC:

 - Si no se tiene instalado puede descargarlo de la página oficial https://www.java.com/en/download/

## ¿Comó utilizar el software?

El algoritmo que describe el funcionamiento del software es el siguiente:
 1. Ejecutar la aplicación .Jar.
 2. Cargar un archivo con código Mini C# (.frag)
 3. Analizar el código para válidar los tokens.
 4. Se mostrará en pantalla los tokens y errores detalladamente y
 se tendrá la opción de generar un archivo (.out) con dicha información.
 
 **Nota** Es importante recalcar que previamente el analizador léxico tuvo que haber sido compilado.
 
### Ejecutar la aplicación

#### Clikeando sobre el icono de la aplicación
	
Una vez tenga la carpeta del proyecto dirigase a la carpeta _Analizador Lexico - PHP_ una vez este dentro
de esta carpeta dirigase a la carpeta _dist_ y dentro de esta carpeta encontrará el archivo llamado
_MiniPHP.jar_, para ejecutarlo pulse doble-click sobre este archivo.

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

![MiniC](https://image.ibb.co/kkuP09/MiniC.jpg)

### Cargar Archivo Mini C#

Para cargar un archivo con código de Mini C#:
1. Dirigase al boton **Cargar Archivo**
2. Presione click sobre este boton 

![MiniC-Cargar](https://image.ibb.co/hwvWf9/Mini_C_Cargar.jpg)

Se mostrará el manejador de carpetas y archivos, en esta pantalla tendra que buscar y 
seleccionar el archivo **(.frag)** deseado.

![MiniC-Cargar2](https://image.ibb.co/ii0a7p/Mini_C_Cargar2.jpg)

### Analizar Archivo Mini C#

Para analizar un archivo Mini C#:
1. Dirigase al boton **Analizar**
2. Presione click sobre este boton 

![MiniC-Analizar1](https://image.ibb.co/dffWf9/Mini_C_Analizar.jpg)

Esto inicializará el análisis del archivo cargado anteriormente y una vez este finalice
se mostrará el resultado del análisis en pantalla.

![MiniC-Mostrar](https://image.ibb.co/eA2oSp/Mini_C_Mostrar.jpg)

Si el usuario lo desea podrá guardar el resultado del análisis en un archivo con extensión ".out"
pulsando el boton **Guardar Análisis"

![MiniC-Guardar](https://image.ibb.co/hVsYtU/Mini_C_Guardar.jpg)

El programa le pedirá elegir la ubicación donde se almacenará el archivo con el resultado del 
análisis léxico.

### *Compilar Analizador Léxico

Cabe recalcar que esta función está unicamente disponible para el desarrollador, puesto que para la 
ejecución correcta del software es necesario el analizador léxico ya compilado. Por lo tanto el 
botón **Compilar Analizador** se encontrará deshabilitado.

![MiniC-Compilar](https://image.ibb.co/jdYv7p/Mini_C_Compilar.jpg)

## Manejo De Errores

Para el manejo de errores se hizo uso de la expresion '.' de JFLEX, esta expresion regular se caracteriza
por ejecutarse cuando ninguna expresion regular coincidio con el token actual por lo que esta fuera del
lenguaje se podria decir. Además también se diseñaron expresiones regulares que permiten capturar otros
errores. La acción que se realiza es de agregar el error como un token a la lista, detallando el token,
numero de linea y numero de columna donde ocurrio el error y que tipo de error es.

```
{this.tokens.add(new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true)); return new Yytoken(yytext(), yyline, yycolumn, "Unrecognized char", true);}
```

## Opinion del Autor

A mi criterio el software **Mini C#** desarrollado por mi persona, funciona de manera correcta puesto que
se realizaron distintas pruebas para verificar que no generará problemas al momento de ejecutarlo en cualquier
PC, además su correcto funcionamiento tambien abarca la exactitud léxica que posee para analizar los archivos
escritos en Mini C#, se escribieron expresiones regulares bastante grandes que tratan de abarcar la mayor cantidad
de casos posibles, se hizo una investigación profunda respecto a la herramienta JFLEX para desarrollar expresiones
regulares óptimas.

## Información del Autor
	
**Bryan Macario Coronado**

_Estudiante de ingeniería en informática y sistemas_

_Curso de Compiladores_

_Universidad Rafael Landivar_