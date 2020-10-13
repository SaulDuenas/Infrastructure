using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Data;

/***************************************************************************
 *       Clase: TSR-DB.                                                    *
 * Descripci�n: Permite establecer las funciones b�sicas para el manejo de *
 *              las conexiones a Base de Datos.                            *
 *       Autor: Ing. Israel Hinojosa S�nchez.                              *
 *       Fecha: 14/Sep/2007.                                               *
 *     Versi�n: 1.0.0                                                      *
 ***************************************************************************/
namespace Teseracto.Data
{
   public class TSR_DB
   {
      //Propiedades.
      //--Protegidas.
      protected string sServer;
      protected string sDataBase;
      protected string sUser;
      protected string sPassword;

      //--Privadas.
      private Dictionary<string, c_SP> dStoredProcedures;

      //--Publicas.
      public SqlConnection oCnn;
      public IDataReader oDatos;
      public SqlDataReader oRdrDatos;
      public string sError;

      //M�todos.
      //<Publicos>
      //----------------------------------------------------------------------------
      //    Nombre: TSR_DB.
      // Categor�a: Constructor (Sin par�metros).
      //  Objetivo: Inicializar la clase.
      //     Autor: Ing. Israel Hinojosa S�nchez.
      //     Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
	   /// <summary>
      /// Objeto de Conectividad con Oracle
      /// </summary>
      public TSR_DB()
      {
         sServer = "";
         sDataBase = "";
         sUser = "";
         sPassword = "";
         sError = "";
         oCnn = null;
         oDatos = null;
         dStoredProcedures = null;
      }

      //----------------------------------------------------------------------------
      //     Nombre: TSR_DB.
      //  Categor�a: Constructor (Con par�metros).
      //   Objetivo: Inicializar la clase, con los par�metros de conexi�n.
      // Par�metros:
      //             -Entrada-
      //                psServer: Servidor.
      //              psDataBase: Base de datos.
      //                  psUser: Usuario.
      //              psPassword: Contrase�a.
      //      Autor: Ing. Israel Hinojosa S�nchez.
      //      Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Objeto de Conectividad con Oracle 
      /// </summary>
      /// <param name="psServer">Nombre del servidor</param>
      /// <param name="psDataBase">Nombre de la base de datos</param>
      /// <param name="User">Nombre de usuario de DB</param>
      /// <param name="Password">Contrase�a del usuario</param>
      public TSR_DB(string psServer, string psDataBase, string psUser, string psPassword)
      {
         sServer = psServer;
         sDataBase = psDataBase;
         sUser = psUser;
         sPassword = psPassword;
         oCnn = null;
         dStoredProcedures = null;
      }

      //----------------------------------------------------------------------------
      //    Nombre: ~TSR_DB.
      // Categor�a: Destructor.
      //  Objetivo: Destruye los objetos utilizados por la clase.
      //     Autor: Ing. Israel Hinojosa S�nchez.
      //     Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      ~TSR_DB()
      {
         dStoredProcedures = null;
         oCnn = null;
      }

      //----------------------------------------------------------------------------
      //     Nombre: DBIniParam.
      //  Categor�a: Procedimiento de Usuario.
      //   Objetivo: Inicializar la clase, con los par�metros de conexi�n.
      // Par�metros:
      //             -Entrada-
      //                psServer: Servidor.
      //              psDataBase: Base de datos.
      //                  psUser: Usuario.
      //              psPassword: Contrase�a.
      //      Autor: Ing. Israel Hinojosa S�nchez.
      //      Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Establece los parametros de conexi�n. (No se conecta)
      /// </summary>
      /// <param name="psServer">Nombre del servidor</param>
      /// <param name="psDataBase">Nombre de la base de datos</param>
      /// <param name="User">Nombre de usuario de DB</param>
      /// <param name="Password">Contrase�a del usuario</param>
      public void DBIniParam(string psServer, string psDataBase, string psUser, string psPassword)
      {
         sServer = psServer;
         sDataBase = psDataBase;
         sUser = psUser;
         sPassword = psPassword;
         oCnn = null;
      }

      //----------------------------------------------------------------------------
      //     Nombre: DBConectar.
      //  Categor�a: Funci�n de Usuario.
      //   Objetivo: Establecer conexi�n con una base de datos.
      // Par�metros:
      //             -Salida-
      //                plbOk: Validaci�n de Conexi�n.
      //                        true: Conexi�n exitosa.
      //                       false: Hubo un problema.
      //      Autor: Ing. Israel Hinojosa S�nchez.
      //      Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Se conecta a SQL Server con los par�metros de conexi�n previamente establecidos
      /// </summary>
      /// <returns>true=Conexi�n exitosa</returns>
      public bool DBConectar()
      {
         string lsCadCnn = "";  //Cadena de conexi�n.
         string lsCadAux = "";  //Cadena auxiliar.
         bool lbOk = true;      //Validaci�n de la conexi�n.

         //Obtiene el nombre de la aplicaci�n
         System.Reflection.Assembly AppInfo;  //Informaci�n de la aplicaci�n.
         AppInfo = System.Reflection.Assembly.GetExecutingAssembly();

         //Path.GetFileNameWithoutExtension(InfoFile.Location));


         //[1]Inicializar la cadena de conexi�n.
         lsCadAux = "Server=" + sServer + ";Database=" + sDataBase +
                       ";User Id=" + sUser + ";Pwd=******;";
         lsCadCnn = "Server=" + sServer + ";Database=" + sDataBase +
                       ";User Id=" + sUser + ";Pwd=" + sPassword + 
                       ";Application Name="+AppInfo.FullName.ToString().Split(',')[0];
         try
         {
            //[2]Establecer conexi�n.
            oCnn = new SqlConnection(lsCadCnn);

            //[3]Abrir conexi�n.
            oCnn.Open();
         }
         catch (Exception e)
         {
            sError = e.Message + "\n\nCadena de conexi�n: " + lsCadAux;
            lbOk = false;
         }

         //[4]Retornar valor.
         return lbOk;
      }

      //----------------------------------------------------------------------------
      //     Nombre: DBEjecutar.
      //  Categor�a: Funci�n de Usuario.
      //   Objetivo: Ejecuta una instrucci�n SQL, que no regresa RecordSet.
      // Par�metros:
      //             -Entrada-
      //                psQry: Instrucci�n SQL.
      //             -Salida-
      //                plbOk: Validaci�n de ejecuci�n.
      //                        true: Conexi�n exitosa.
      //                       false: Hubo un problema.
      //      Autor: Ing. Israel Hinojosa S�nchez.
      //      Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Ejecuta una instrucci�n SQL que no regresa recordsets
      /// </summary>
      /// <param name="psQry">Instruccion SQL</param>
      /// <returns>true=Ejecutada con �xito</returns>
      public bool DBEjecutar(string psQry)
      {
         bool lbOk = true;  //Validaci�n de ejecuci�n.

         try
         {
            //[1]Establecer Instrucci�n SQL. 
            SqlCommand loCom = new SqlCommand(psQry, oCnn);

            //[2]EjecutarInstrucci�n.
            loCom.ExecuteNonQuery();

            //[3]Terminar comando.
            loCom.Dispose();
         }
         catch (Exception loError)
         {
            sError = loError.Message + "\n\nInstrucci�n SQL: " + psQry;
            lbOk = false;
         }

         //[3]Retornar valor.
         return lbOk;
      }

      //----------------------------------------------------------------------------
      //    Nombre: DBDesconectar.
      // Categor�a: Funci�n de Usuario.
      //  Objetivo: Finaliza la conexi�n con SQL.
      //     Autor: Ing. Israel Hinojosa S�nchez.
      //     Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Se desconecta de la base de datos
      /// </summary>
      public void DBDesconectar()
      {
         try
         {
            if (oCnn != null) oCnn.Close();
         }
         catch (Exception loError)
         {
            sError = loError.Message;
         }
      }

      //----------------------------------------------------------------------------
      //     Nombre: DBEjecutarSP.
      //  Categor�a: Funci�n de Usuario.
      //   Objetivo: Ejecuta un stored procedure con par�metros.
      // Par�metros:
      //             -Entrada-
      //                 psNombreSP: Nombre del stored procedure.
      //               pnValRetorno: Valor de retorno del stored, entero.
      //               poParametros: p�rametros de cualquier tipo de datos.
      //             -Salida-
      //      Autor: Ing. Israel Hinojosa S�nchez.
      //      Fecha: 4/Oct/2007.
      //    Ejemplo: lbOk = DBEjecutarSP("spProcesa",lnStatProc,"@pnAccion",lnAccion).
      //----------------------------------------------------------------------------
      public bool DBEjecutarSP(string psNombreSP, out int pnValRetorno, params object[] poParametros)
      {
         bool lbOk = true;         //Validaci�n de Operaciones.
         bool lbExisteSP = true;   //Posici�n del stored procedure en el diccionario.
         c_SP loSP = new c_SP();   //objeto de control clase Stored Procedure.
         int lnParam = 0;          //�ndice de par�metros.
         string lsSQL = "";        //Instrucci�n SQL.

         //Inicia
         pnValRetorno=0;

         try
         {
            //[1]Preparar stored procedure.
            SqlCommand loCom = new SqlCommand(psNombreSP, oCnn);
            loCom.CommandType = CommandType.StoredProcedure;

            //[2]Verificar que el dicionario exista y s� no crearlo.
            if (dStoredProcedures == null) dStoredProcedures = new Dictionary<string, c_SP>();

            //[3]verificar que el stored procedure exista.
            if (dStoredProcedures.Count > 0)
               try { dStoredProcedures[psNombreSP].ToString(); }
               catch { lbExisteSP = false; }
            else
               lbExisteSP = false;

            //[4]Verificar si se requiere refrescar par�metros y que se haya localizado el stored procedure.
            if (lbExisteSP == false)
            {
               //[4.1]Refrescar par�metros.
               SqlCommandBuilder.DeriveParameters(loCom);

               //[4.2]Establecer par�metro en diccionario de stored procedures.
               for (lnParam = 0; lnParam < loCom.Parameters.Count; lnParam++)
                  loSP.AddParam(loCom.Parameters[lnParam].ParameterName,
                             loCom.Parameters[lnParam].SqlDbType,
                             loCom.Parameters[lnParam].Direction,
                             loCom.Parameters[lnParam].Value);

               //[4.3]Agregar stored procedure al diccionario
               dStoredProcedures.Add(psNombreSP, loSP);
            }
            else
            {
               foreach (KeyValuePair<string, c_SP.stParametro> elem in dStoredProcedures[psNombreSP].Parametros)
	            {
                  loCom.Parameters.Add(new SqlParameter(elem.Key,elem.Value.Tipo));
                  loCom.Parameters[elem.Key].Direction = elem.Value.Direccion;
	            }
            }

            //[5]Actualizar valores de par�metros.
            lsSQL = psNombreSP + " ";
            for (lnParam = 0; lnParam < poParametros.Length; lnParam += 2)
            {
               //le pone su valor
               loCom.Parameters[poParametros[lnParam].ToString()].Value = poParametros[lnParam + 1];

               #region /* Arma Query para mensajes de error */
               if (poParametros[lnParam + 1].GetType().ToString() == "System.String")
                  if (poParametros[lnParam + 1].ToString() == "")
                     lsSQL = lsSQL + "''";
                  else
                     lsSQL = lsSQL + "'" + poParametros[lnParam + 1].ToString().Replace("'", "''") + "'";
               else
                  if (poParametros[lnParam + 1].GetType().ToString() == "System.DateTime")
                     lsSQL = lsSQL + "CONVERT(DATETIME,'" + ((DateTime)poParametros[lnParam + 1]).ToString("dd-MM-yyyy hh:mm:ss") + "',105)";
                  else
                     lsSQL = lsSQL + poParametros[lnParam + 1].ToString();
               if (lnParam + 2 < poParametros.Length) lsSQL = lsSQL + ", ";
               #endregion
               
            }

            //[6]Ejecutar Stored Procedure.
            loCom.ExecuteNonQuery();

            //[7]Asignar valor de retorno de stored procedure.
            try
            {
               pnValRetorno = (int)loCom.Parameters["@RETURN_VALUE"].Value;
            }
            catch { }

            //[8]Asignar valores de salida al diccionario.
            foreach (SqlParameter param in loCom.Parameters)
            {
               dStoredProcedures[psNombreSP].CambiaValParam(param.ParameterName, param.Value);
            }
            //for (lnParam = 0; lnParam < poParametros.Length; lnParam += 2)
            //   if (loCom.Parameters[poParametros[lnParam].ToString()].Direction == ParameterDirection.InputOutput || loCom.Parameters[poParametros[lnParam].ToString()].Direction == ParameterDirection.Output)
            //      dStoredProcedures[psNombreSP].CambiaValParam(poParametros[lnParam].ToString(), loCom.Parameters[poParametros[lnParam].ToString()].Value);
         }
         catch (Exception loError)
         {
            lbOk = false;
            sError = "Instrucci�n SQL: [" + lsSQL + "]" + "\n\nDescrip: " + loError.Message;
         }

         //[9]Retornar valor.
         return lbOk;
      }

      //----------------------------------------------------------------------------
      //     Nombre: DBGetParametroSP.
      //  Categor�a: Funci�n de Usuario.
      //   Objetivo: Regresar valores de los par�metros de salida obtenidos en la 
      //             ejecuci�n de un stored procedure.
      // Par�metros:
      //             -Entrada-
      //                psNombreSP: Nombre del stored procedure.
      //                  psNomVar: Nombre d ela variable de salida("@psDato").
      //             -Salida-
      //                   poValor: Objeto de Salida.
      //      Autor: Ing. Israel Hinojosa S�nchez.
      //      Fecha: 8/Sep/2007.
      //----------------------------------------------------------------------------
      public object DBGetParametroSP(string psNombreSP, string psNomVar)
      {
         object poValor = null;

         //[1]Recuperar valor.
         poValor = dStoredProcedures[psNombreSP].Parametros[psNomVar].Valor;

         //[2]Retornar valor.
         return poValor;
      }

      //----------------------------------------------------------------------------
      //     Nombre: DBQryDato.
      //  Categor�a: Funci�n de Usuario.
      //   Objetivo: Regresa un s�lo un valor como resultado de un Query.
      // Par�metros:
      //             -Entrada-
      //                  psQry: Instrucci�n SQL.
      //             -Salida-
      //                poValor: Objeto de Salida.
      // Comentario: Devuelve nulo si hubo error � el dato no fue localizado.
      //      Autor: Ing. Israel Hinojosa S�nchez.
      //      Fecha: 9/Oct/2007.
      //----------------------------------------------------------------------------
      public object DBQryDato(string psQry)
      {
         object poDato = null;  //Dato a obtener.

         try
         {
            //[1]Establecer Instrucci�n SQL. 
            SqlCommand loCom = new SqlCommand(psQry, oCnn);

            //[2]Ejecutar Instrucci�n.
            poDato = loCom.ExecuteScalar();
            
            
         }
         catch (Exception loError)
         {
            sError = "Instrucci�n SQL: [" + psQry + "]" + "\n\nDescrip: " + loError.Message;
            poDato = null;
            
         }

         //[3]Retornar valor.
         return poDato;
      }



      //public bool DBQryDatos(string psQry, params object[] args)
      //{
      //   bool lRetVal=false;
      //   int i=0;
      //   oRdrDatos = null;
      //   SqlCommand loCom;
         
      //   try
      //   {
      //      //[1]Establecer Instrucci�n SQL. 
      //       loCom = new SqlCommand(psQry, oCnn);

      //      //[2]Ejecutar Instrucci�n.
      //      oRdrDatos = loCom.ExecuteReader();

      //      while (oRdrDatos.Read())
      //      {
      //         //[4]Regresamos el resultado por args
      //         for (i = 0; i <= (args.Length - 1); i++)
      //         {
      //            args.SetValue(oRdrDatos[i], i);

      //         }
               
      //      }
      //      lRetVal = true;

      //   }
      //   catch (Exception loError)
      //   {
      //      oRdrDatos.Close();
      //      sError = "Instrucci�n SQL: [" + psQry + "]" + "\n\nDescrip: " + loError.Message;
      //   }
      //   oRdrDatos.Close();
      //   return lRetVal;
      //}



      /***************************************************************************
       *       Clase: c_SP.                                                      *
       * Descripci�n: Permite establecer las funciones b�sicas para el manejo de *
       *              par�metros en un stored procedure.                         *
       *       Autor: Ing. Israel Hinojosa S�nchez.                                                   *
       *       Fecha: 10/Oct/2007.                                               *
       *     Versi�n: 1.0.0                                                      *
       ***************************************************************************/
      private class c_SP
      {
         //Propiedades.
         //--Publicas.
         public Dictionary<string, stParametro> Parametros;  //Diccionario de par�metros.
         public struct stParametro  //Estructura de las caracter�sticas de un par�metro.
         {
            public SqlDbType Tipo;
            public ParameterDirection Direccion;  //Direcci�n de datos del par�metro.
            public object Valor;                  //Valor del par�metro.
         }
         //M�todos.
         //<Publicos>
         //----------------------------------------------------------------------------
         //    Nombre: c_SP.
         // Categor�a: Constructor (Sin par�metros).
         //  Objetivo: Inicializar la clase.
         //     Autor: Ing. Israel Hinojosa S�nchez.
         //     Fecha: 09/Oct/2007.
         //----------------------------------------------------------------------------
         public c_SP()
         {
            //Inicializar diccionario de par�metros.
            Parametros = new Dictionary<string, stParametro>();
         }
         //----------------------------------------------------------------------------
         //    Nombre: ~c_SP.
         // Categor�a: Destructor.
         //  Objetivo: Destruye los objetos utilizados en el formulario.
         //     Autor: Ing. Israel Hinojosa S�nchez.
         //     Fecha: 14/Sep/2007.
         //----------------------------------------------------------------------------
         ~c_SP()
         {
            Parametros = null;
         }

         //----------------------------------------------------------------------------
         //     Nombre: SetParam.
         //  Categor�a: Procedimiento de usuario.
         //   Objetivo: Establece las propiedades de un par�metro.
         // Par�metros:
         //             -Entrada-
         //                 psParametro: Nombre del par�metro. ("@pnDato")
         //                     poTiipo: Direcci�n del par�metro.
         //                     poValor: Valor del par�metro.
         //      Autor: Ing. Israel Hinojosa S�nchez.
         //      Fecha: 09/Oct/2007.
         //----------------------------------------------------------------------------
         public void AddParam(string psParametro, SqlDbType poTipo, ParameterDirection poDireccion, object poValor)
         {
            stParametro oParametro = new stParametro();  //Estructura de tipo par�metro.

            //[1]Llenar Estructura.
            oParametro.Tipo=poTipo;
            oParametro.Direccion = poDireccion;
            oParametro.Valor = poValor;

            //[2]Agregar estructura a diccionario.
            Parametros.Add(psParametro, oParametro);
         }

         //----------------------------------------------------------------------------
         //     Nombre: CambiaValParam.
         //  Categor�a: Procedmiento de usuario.
         //   Objetivo: Cambia el valor de un par�metro dentro de un stored procedure.
         // Par�metros:
         //             -Entrada-
         //                psParametro: Nombre del par�metro. ("@pnDato")
         //                    poValor: Valor del par�metro.
         //      Autor: Ing. Israel Hinojosa S�nchez.
         //      Fecha: 09/Oct/2007.
         //----------------------------------------------------------------------------
         public void CambiaValParam(string psParametro, object poValor)
         {
            stParametro oParametro = new stParametro();  //Estructura de tipo par�metro.

            //[1]Recuperar estructura.
            oParametro = (stParametro)Parametros[psParametro];

            //[2]Cambiar valor.
            oParametro.Valor = poValor;

            //Guarda el valor modificado
            Parametros[psParametro]=oParametro;

            ////[3]Borrar estructura anterior.
            //Parametros.Remove(psParametro);

            ////[4]Ingresar nueva estructura.
            //Parametros.Add(psParametro, oParametro);
         }
      }
   }
}
