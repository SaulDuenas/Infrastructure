using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;


/***************************************************************************
 *       Clase: TSR-INI.                                                   *
 * Descripci�n: Permite establecer las funciones b�sicas para el manejo de *
 *              archivos "INI" con funciones de encriptaci�n y             *
 *              desencriptaci�n.                                           *
 *       Autor: Ing. Israel Hinojosa S�nchez.                              *
 *       Fecha: 13/Sep/2007.                                               *
 *     Versi�n: 1.0.0                                                      *
 ***************************************************************************/

namespace Teseracto.IniFiles
{
    public class TSR_INI
    {
        //Propiedades.
        //--Privadas.
        private string sPathFileINI;  //Ruta y Nombre del archivo INI.

        //--API's.
        //<Declaraciones de Lectura del Archivo INI>
        [DllImport("Kernel32.dll", CharSet = CharSet.Auto)]
        private static extern int GetPrivateProfileSectionNames
        (
         string sAddBuffer,  //Direcci�n de memoria del buffer.
         int nSize,          //Tama�o del buffer.
         string sFileName    //Nombre y ruta del archivo.
        );
        //<Leer una secci�n completa>
        [DllImport("Kernel32.dll", CharSet = CharSet.Auto)]
        private static extern int GetPrivateProfileSection
        (
         string sSecName,    //Nombre de la secci�n.
         string sDirBuffer,  //Direcci�n del buffer.
         int nSize,          //Tama�o del buffer.
         string sFileName    //Nombre y ruta del archivo.
        );
        //<Leer una clave de un Archivo INI -Valor String->
        [DllImport("Kernel32.dll", CharSet = CharSet.Auto)]
        private static extern int GetPrivateProfileString
        (
         string sSecName,    //Nombre de la secci�n.
         string sKeyName,    //Nombre de la clave.
         string sDefault,    //Valor default.
         string sValBuffer,  //Valor del buffer.
         int nSize,          //Tama�o del buffer.
         string sFileName    //Nombre y ruta del Archivo.
        );
        //<Leer una clave de un Archivo INI -Valor N�merico->
        [DllImport("Kernel32.dll", CharSet = CharSet.Auto)]
        private static extern int GetPrivateProfileString
        (
         string sSecName,   //Nombre de la secci�n.
         int nKeyName,      //Valor de la clave.
         string sDefault,   //Valor default.
         string sValBuffer, //Valor del buffer.
         int nSize,         //Tama�o del buffer.
         string sFileName   //Nombre y ruta del Archivo.
        );
        //<Escribir una clave de un Archivo INI -Valor string- (tambi�n para borrar claves y secciones)>
        [DllImport("Kernel32.dll", CharSet = CharSet.Auto)]
        private static extern int WritePrivateProfileString
        (
         string sSecName,  //Nombre de la secci�n.
         string sKeyName,  //Nombre de la clave.
         string sValor,    //Valor.
         string sFileName  //Nombre y ruta del Archivo.
        );
        //<Escribir una clave de un Archivo INI -Valor n�merico- (tambi�n para borrar claves y secciones)>
        [DllImport("Kernel32.dll", CharSet = CharSet.Auto)]
        private static extern int WritePrivateProfileString
        (
         string sSecName,   //Nombre de la Secci�n.
         string sKeyName,   //Nombre de la clave.
         int nValor,        //Valor.
         string sFileName   //Nombre y ruta del Archivo.
        );
        //<Escribir una clave de un Archivo INI -Llave y Valor n�merica- (tambi�n para borrar claves y secciones)>
        [DllImport("Kernel32.dll", CharSet = CharSet.Auto)]
        private static extern int WritePrivateProfileString
        (
         string sSecName,   //Nombre de la secci�n.
         int nKeyName,      //Nombre de la clave.
         int nValor,        //Valor.
         string sFileName   //Nombre y ruta del Archivo.
        );

        //M�todos.
        //<Publicos>
        //----------------------------------------------------------------------------
        //    Nombre: TSR_INI.
        // Categor�a: Constructor (Sin par�metros).
        //  Objetivo: Inicializar la clase, con ruta y nombre del archivo INI 
        //            de la aplicaci�n que lo ejecute.
        //     Autor: Ing. Israel Hinojosa S�nchez.
        //     Fecha: 13/Sep/2007.
        //----------------------------------------------------------------------------
        public TSR_INI()
        {
            System.Reflection.Assembly InfoFile;  //Informaci�n de la aplicaci�n.
            string lsNomFileINI = "";             //Ruta y Nombre del archivo INI.

            //[1]Obtener Ruta y nombre del archivo INI.
            InfoFile = System.Reflection.Assembly.GetExecutingAssembly();
            lsNomFileINI = InfoFile.Location.Trim().Replace(".exe", ".ini");

            //[2]Inicializar propiedades.
            sPathFileINI = lsNomFileINI;
        }

        //----------------------------------------------------------------------------
        //     Nombre: TSR_INI.
        //  Categor�a: Constructor (Con par�metros).
        //   Objetivo: Inicializar la clase, con ruta y nombre del archivo INI 
        //             especificos.
        // Par�metros:
        //             -Entrada-
        //                psPathFileINI: Ruta y nombre del archivo INI.
        //      Autor: Ing. Israel Hinojosa S�nchez.
        //      Fecha: 13/Sep/2007.
        //----------------------------------------------------------------------------
        public TSR_INI(string psPathFileINI)
        {
            sPathFileINI = psPathFileINI;
        }
        //----------------------------------------------------------------------------
        //     Nombre: BorraLlave.
        //   Objetivo: Borrar una clave de un archivo INI.
        //  Categor�a: Procedmiento de usuario.
        // Cometarios: S� psKey no se indica, se borra la secci�n insicada por 
        //             psSecci�n.
        // Par�metros:
        //             -Entrada-
        //                psSeccion: Secci�n dentro del INI.
        //                    psKey: Llave dentro de la Secci�n.
        //      Autor: Ing. Israel Hinojosa S�nchez.
        //      Fecha: 13/Sep/2007.
        //----------------------------------------------------------------------------
        public void BorraLlave(string psSeccion, string psKey)
        {
            if (psKey == "")
                WritePrivateProfileString(psSeccion, 0, 0, sPathFileINI);     //Borrar una Secci�n.
            else
                WritePrivateProfileString(psSeccion, psKey, 0, sPathFileINI);  //Borrar una Entrada.
        }

        //----------------------------------------------------------------------------
        //     Nombre: BorraSeccion.
        //   Objetivo: Borrar una seccion de un archivo INI.
        //  Categor�a: Procedmiento de usuario.
        // Par�metros:
        //             -Entrada-
        //                psSeccion: Secci�n dentro del INI.
        //      Autor: Ing. Israel Hinojosa S�nchez.
        //      Fecha: 13/Sep/2007.
        //----------------------------------------------------------------------------
        public void BorraSeccion(string psSeccion)
        {
            WritePrivateProfileString(psSeccion, 0, 0, sPathFileINI);
        }

        //----------------------------------------------------------------------------
        //     Nombre: ObtenValor.
        //   Objetivo: Devuelve el valor de una clave de un fichero INI.
        //  Categor�a: Funci�n de usuario.
        // Par�metros:
        //             -Entrada-
        //               psSeccion: Secci�n dentro del INI.
        //               psKeyName: Nombre de la llave dentro de la secci�n.
        //             -Salida-
        //                lsRetVal: Valor de retorno.
        //      Autor: Ing. Israel Hinojosa S�nchez.
        //      Fecha: 13/Sep/2007.
        //----------------------------------------------------------------------------
        public string ObtenValor(string psSeccion, string psKeyName, string psDefault)
        {
            int lnRet;        //Validaci�n del valor de retorno.
            string lsRetVal;  //Valor de Retorno.

            //[1]Inicializar valor de retorno.
            lsRetVal = new string(' ', 1500);

            //[2]Obtener valor de retorno.
            lnRet = GetPrivateProfileString(psSeccion, psKeyName, psDefault, lsRetVal, lsRetVal.Length, sPathFileINI);

            //[3]Validar retorno.
            if (lnRet == 0)
                return psDefault;
            else
                return lsRetVal.Substring(0, lnRet);
        }
        //----------------------------------------------------------------------------
        //     Nombre: EscribeValor.
        //   Objetivo: Escribe un valor en una clave dentro de un archivo INI.
        //  Categor�a: Procedimiento de usuario.
        // Par�metros:
        //             -Entrada-
        //               psSeccion: Secci�n dentro del INI.
        //               psKeyName: Nombre de la llave dentro de la secci�n.
        //                 psValor: Valor de la llave.
        //      Autor: Ing. Israel Hinojosa S�nchez.
        //      Fecha: 13/Sep/2007.
        //----------------------------------------------------------------------------
        public void EscribeValor(string psSeccion, string psKeyName, string psValor)
        {
            WritePrivateProfileString(psSeccion, psKeyName, psValor, sPathFileINI);
        }

        //----------------------------------------------------------------------------
        //     Nombre: ObtenerClavesValores.
        //   Objetivo: Leer una secci�n entera de un archivo INI regresando todas sus 
        //             claves y valores.
        // Cometarios: Se devolvera un arreglo de �ndice cero con las claves y valores
        //             del archivo INI Le�do.
        //             Para leer los datos:
        //               For(i = 0; i < UBound(arreglo) - 1; i+=2)
        //                 {
        //                  sClave = arreglo[i]
        //                  sValor = aerreglo[i+1]
        //                 }
        // Par�metros:
        //             -Entrada-
        //                 psSeccion: Secci�n dentro del INI.
        //             -Salida-
        //                lasSeccion: Arreglo de Secciones.
        //      Autor: TSR-IHS.
        //      Fecha: 13/Sep/2007.
        //----------------------------------------------------------------------------
        public string[] ObtenerClavesValores(string psSeccion)
        {
            string[] lasSeccion = null;
            int lnNum;
            //El tama�o m�ximo para Windows 95    
            string sBuffer = new string('0', 32767);

            //[1]Inicializar Secci�n.
            //lasSeccion = new string[];

            //[2]Obtener n�mero de elementos e inicicializar el contenido.
            lnNum = GetPrivateProfileSection(psSeccion, sBuffer, sBuffer.Length, sPathFileINI);

            //[3]Validar informaci�n recolectada.
            if (lnNum > 0)
            {
                //[4]Depurar cadena.
                sBuffer = sBuffer.Substring(0, lnNum - 1).TrimEnd();

                //[5]Separar cadena.
                lasSeccion = sBuffer.Split(new char[] { '\0', '=' });
            }

            //Devolver el arreglo.
            return lasSeccion;
        }
      

        //----------------------------------------------------------------------------
        //     Nombre: Encripta.
        //   Objetivo: Metodo que permite encriptar un dato, a trav�s de una llave.
        // Par�metros:
        //             -Entrada-
        //                 psDato: Dato a encriptar.
        //                  pnKey: Llave de encriptaci�n.
        //             -Salida-
        //                  lsCad: Cadena de datos encriptada.
        //      Autor: Ing. Israel Hinojosa S�nchez.
        //      Fecha: 01/Oct/2007.
        //----------------------------------------------------------------------------
        public string Encripta(string psDato, int pnKey)
        {
            string lsCad = "";  //Dato a encriptar.
            int lnAsc = 0;      //Valor ASCII.
            char lcChar;        //Valor caracter.
            int lnNum = 0;      //Valor temporal.

            //[1]Recorrer dato a encriptar.
            for (int i = 0; i < psDato.Length; i++)
            {
                lcChar = psDato[i];  //Obtener la letra.
                lnAsc = (int)lcChar; //Obtener ASCII.

                //[2]Validar ASSCII.
                if (lnAsc <= 32 || (lnAsc >= 127 && lnAsc <= 160) || lnAsc == 255)
                    //--Caracteres de control: No cambian.
                    lsCad = lsCad + lcChar;
                else
                    if (lnAsc >= 33 && lnAsc <= 126)
                    {
                        //--Alfabeto normal: se enrollan en este rango.
                        lnNum = ((lnAsc - 33 + pnKey) % 94) + 33;
                        lsCad = lsCad + (char)(lnNum);
                    }
                    else
                        if (lnAsc >= 161 && lnAsc <= 254)
                        {
                            //--Caracteres acentuados: se enrollan en este rango.
                            lnNum = ((lnAsc - 161 + pnKey) % 94) + 161;
                            lsCad = lsCad + (char)lnNum;
                        }
            }

            //[3]Retornar valor.
            return lsCad;
        }

        //----------------------------------------------------------------------------
        //     Nombre: Desencripta.
        //   Objetivo: Metodo que permite desencriptar un dato, a trav�s de una llave.
        // Par�metros:
        //             -Entrada-
        //                 psDato: Dato a encriptar.
        //                  pnKey: Llave de encriptaci�n.
        //             -Salida-
        //                  lsCad: Cadena de datos desencriptada.
        //      Autor: Ing. Israel Hinojosa S�nchez.
        //      Fecha: 01/Oct/2007.
        //----------------------------------------------------------------------------
        public string Desencripta(string psDato, int pnKey)
        {
            string lsCad = "";  //Dato encriptado.
            int lnAsc = 0;      //Valor ASCII.
            char lcChar;        //Valor caracter.
            int lnNum = 0;      //Valor temporal.

            //[1]Desencriptar letras.
            for (int i = 0; i < psDato.Length; i++)
            {
                lcChar = psDato[i];  //Obtener la letra.
                lnAsc = (int)lcChar; //Obtener ASCII.

                //[2]Validar ASSCII.
                //--Caracteres de control: No cambian.
                if (lnAsc <= 32 || (lnAsc >= 127 && lnAsc <= 160) || lnAsc == 255)
                    lsCad = lsCad + lcChar;
                else
                    if (lnAsc >= 33 && lnAsc <= 126)
                    {
                        //--Alfabeto normal: se enrollan en este rango.
                        lnNum = ((lnAsc - 33 + 94 - pnKey) % 94) + 33;
                        lsCad = lsCad + (char)(lnNum);
                    }
                    else
                        if (lnAsc >= 161 && lnAsc <= 254)
                        {
                            //--Caracteres acentuados: se enrollan en este rango.
                            lnNum = ((lnAsc - 161 + 94 - pnKey) % 94) + 161;
                            lsCad = lsCad + (char)lnNum;
                        }
            }
            //[2]Retornar dato Desencriptado.
            return lsCad;
        }

    }
}