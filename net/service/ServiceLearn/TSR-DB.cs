using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Data;

/***************************************************************************
 *       Clase: TSR-DB.                                                    *
 * Descripción: Permite establecer las funciones básicas para el manejo de *
 *              las conexiones a Base de Datos.                            *
 *       Autor: Ing. Israel Hinojosa Sánchez.                              *
 *       Fecha: 14/Sep/2007.                                               *
 *     Versión: 1.0.0                                                      *
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

      //Métodos.
      //<Publicos>
      //----------------------------------------------------------------------------
      //    Nombre: TSR_DB.
      // Categoría: Constructor (Sin parámetros).
      //  Objetivo: Inicializar la clase.
      //     Autor: Ing. Israel Hinojosa Sánchez.
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
      //  Categoría: Constructor (Con parámetros).
      //   Objetivo: Inicializar la clase, con los parámetros de conexión.
      // Parámetros:
      //             -Entrada-
      //                psServer: Servidor.
      //              psDataBase: Base de datos.
      //                  psUser: Usuario.
      //              psPassword: Contraseña.
      //      Autor: Ing. Israel Hinojosa Sánchez.
      //      Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Objeto de Conectividad con Oracle 
      /// </summary>
      /// <param name="psServer">Nombre del servidor</param>
      /// <param name="psDataBase">Nombre de la base de datos</param>
      /// <param name="User">Nombre de usuario de DB</param>
      /// <param name="Password">Contraseña del usuario</param>
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
      // Categoría: Destructor.
      //  Objetivo: Destruye los objetos utilizados por la clase.
      //     Autor: Ing. Israel Hinojosa Sánchez.
      //     Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      ~TSR_DB()
      {
         dStoredProcedures = null;
         oCnn = null;
      }

      //----------------------------------------------------------------------------
      //     Nombre: DBIniParam.
      //  Categoría: Procedimiento de Usuario.
      //   Objetivo: Inicializar la clase, con los parámetros de conexión.
      // Parámetros:
      //             -Entrada-
      //                psServer: Servidor.
      //              psDataBase: Base de datos.
      //                  psUser: Usuario.
      //              psPassword: Contraseña.
      //      Autor: Ing. Israel Hinojosa Sánchez.
      //      Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Establece los parametros de conexión. (No se conecta)
      /// </summary>
      /// <param name="psServer">Nombre del servidor</param>
      /// <param name="psDataBase">Nombre de la base de datos</param>
      /// <param name="User">Nombre de usuario de DB</param>
      /// <param name="Password">Contraseña del usuario</param>
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
      //  Categoría: Función de Usuario.
      //   Objetivo: Establecer conexión con una base de datos.
      // Parámetros:
      //             -Salida-
      //                plbOk: Validación de Conexión.
      //                        true: Conexión exitosa.
      //                       false: Hubo un problema.
      //      Autor: Ing. Israel Hinojosa Sánchez.
      //      Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Se conecta a SQL Server con los parámetros de conexión previamente establecidos
      /// </summary>
      /// <returns>true=Conexión exitosa</returns>
      public bool DBConectar()
      {
         string lsCadCnn = "";  //Cadena de conexión.
         string lsCadAux = "";  //Cadena auxiliar.
         bool lbOk = true;      //Validación de la conexión.

         //Obtiene el nombre de la aplicación
         System.Reflection.Assembly AppInfo;  //Información de la aplicación.
         AppInfo = System.Reflection.Assembly.GetExecutingAssembly();

         //Path.GetFileNameWithoutExtension(InfoFile.Location));


         //[1]Inicializar la cadena de conexión.
         lsCadAux = "Server=" + sServer + ";Database=" + sDataBase +
                       ";User Id=" + sUser + ";Pwd=******;";
         lsCadCnn = "Server=" + sServer + ";Database=" + sDataBase +
                       ";User Id=" + sUser + ";Pwd=" + sPassword + 
                       ";Application Name="+AppInfo.FullName.ToString().Split(',')[0];
         try
         {
            //[2]Establecer conexión.
            oCnn = new SqlConnection(lsCadCnn);

            //[3]Abrir conexión.
            oCnn.Open();
         }
         catch (Exception e)
         {
            sError = e.Message + "\n\nCadena de conexión: " + lsCadAux;
            lbOk = false;
         }

         //[4]Retornar valor.
         return lbOk;
      }

      //----------------------------------------------------------------------------
      //     Nombre: DBEjecutar.
      //  Categoría: Función de Usuario.
      //   Objetivo: Ejecuta una instrucción SQL, que no regresa RecordSet.
      // Parámetros:
      //             -Entrada-
      //                psQry: Instrucción SQL.
      //             -Salida-
      //                plbOk: Validación de ejecución.
      //                        true: Conexión exitosa.
      //                       false: Hubo un problema.
      //      Autor: Ing. Israel Hinojosa Sánchez.
      //      Fecha: 14/Sep/2007.
      //----------------------------------------------------------------------------
      /// <summary>
      /// Ejecuta una instrucción SQL que no regresa recordsets
      /// </summary>
      /// <param name="psQry">Instruccion SQL</param>
      /// <returns>true=Ejecutada con éxito</returns>
      public bool DBEjecutar(string psQry)
      {
         bool lbOk = true;  //Validación de ejecución.

         try
         {
            //[1]Establecer Instrucción SQL. 
            SqlCommand loCom = new SqlCommand(psQry, oCnn);

            //[2]EjecutarInstrucción.
            loCom.ExecuteNonQuery();

            //[3]Terminar comando.
            loCom.Dispose();
         }
         catch (Exception loError)
         {
            sError = loError.Message + "\n\nInstrucción SQL: " + psQry;
            lbOk = false;
         }

         //[3]Retornar valor.
         return lbOk;
      }

      //----------------------------------------------------------------------------
      //    Nombre: DBDesconectar.
      // Categoría: Función de Usuario.
      //  Objetivo: Finaliza la conexión con SQL.
      //     Autor: Ing. Israel Hinojosa Sánchez.
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
      //  Categoría: Función de Usuario.
      //   Objetivo: Ejecuta un stored procedure con parámetros.
      // Parámetros:
      //             -Entrada-
      //                 psNombreSP: Nombre del stored procedure.
      //               pnValRetorno: Valor de retorno del stored, entero.
      //               poParametros: párametros de cualquier tipo de datos.
      //             -Salida-
      //      Autor: Ing. Israel Hinojosa Sánchez.
      //      Fecha: 4/Oct/2007.
      //    Ejemplo: lbOk = DBEjecutarSP("spProcesa",lnStatProc,"@pnAccion",lnAccion).
      //----------------------------------------------------------------------------
      public bool DBEjecutarSP(string psNombreSP, out int pnValRetorno, params object[] poParametros)
      {
         bool lbOk = true;         //Validación de Operaciones.
         bool lbExisteSP = true;   //Posición del stored procedure en el diccionario.
         c_SP loSP = new c_SP();   //objeto de control clase Stored Procedure.
         int lnParam = 0;          //Índice de parámetros.
         string lsSQL = "";        //Instrucción SQL.

         //Inicia
         pnValRetorno=0;

         try
         {
            //[1]Preparar stored procedure.
            SqlCommand loCom = new SqlCommand(psNombreSP, oCnn);
            loCom.CommandType = CommandType.StoredProcedure;

            //[2]Verificar que el dicionario exista y sí no crearlo.
            if (dStoredProcedures == null) dStoredProcedures = new Dictionary<string, c_SP>();

            //[3]verificar que el stored procedure exista.
            if (dStoredProcedures.Count > 0)
               try { dStoredProcedures[psNombreSP].ToString(); }
               catch { lbExisteSP = false; }
            else
               lbExisteSP = false;

            //[4]Verificar si se requiere refrescar parámetros y que se haya localizado el stored procedure.
            if (lbExisteSP == false)
            {
               //[4.1]Refrescar parámetros.
               SqlCommandBuilder.DeriveParameters(loCom);

               //[4.2]Establecer parámetro en diccionario de stored procedures.
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

            //[5]Actualizar valores de parámetros.
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
            sError = "Instrucción SQL: [" + lsSQL + "]" + "\n\nDescrip: " + loError.Message;
         }

         //[9]Retornar valor.
         return lbOk;
      }

      //----------------------------------------------------------------------------
      //     Nombre: DBGetParametroSP.
      //  Categoría: Función de Usuario.
      //   Objetivo: Regresar valores de los parámetros de salida obtenidos en la 
      //             ejecución de un stored procedure.
      // Parámetros:
      //             -Entrada-
      //                psNombreSP: Nombre del stored procedure.
      //                  psNomVar: Nombre d ela variable de salida("@psDato").
      //             -Salida-
      //                   poValor: Objeto de Salida.
      //      Autor: Ing. Israel Hinojosa Sánchez.
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
      //  Categoría: Función de Usuario.
      //   Objetivo: Regresa un sólo un valor como resultado de un Query.
      // Parámetros:
      //             -Entrada-
      //                  psQry: Instrucción SQL.
      //             -Salida-
      //                poValor: Objeto de Salida.
      // Comentario: Devuelve nulo si hubo error ó el dato no fue localizado.
      //      Autor: Ing. Israel Hinojosa Sánchez.
      //      Fecha: 9/Oct/2007.
      //----------------------------------------------------------------------------
      public object DBQryDato(string psQry)
      {
         object poDato = null;  //Dato a obtener.

         try
         {
            //[1]Establecer Instrucción SQL. 
            SqlCommand loCom = new SqlCommand(psQry, oCnn);

            //[2]Ejecutar Instrucción.
            poDato = loCom.ExecuteScalar();
            
            
         }
         catch (Exception loError)
         {
            sError = "Instrucción SQL: [" + psQry + "]" + "\n\nDescrip: " + loError.Message;
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
      //      //[1]Establecer Instrucción SQL. 
      //       loCom = new SqlCommand(psQry, oCnn);

      //      //[2]Ejecutar Instrucción.
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
      //      sError = "Instrucción SQL: [" + psQry + "]" + "\n\nDescrip: " + loError.Message;
      //   }
      //   oRdrDatos.Close();
      //   return lRetVal;
      //}



      /***************************************************************************
       *       Clase: c_SP.                                                      *
       * Descripción: Permite establecer las funciones básicas para el manejo de *
       *              parámetros en un stored procedure.                         *
       *       Autor: Ing. Israel Hinojosa Sánchez.                                                   *
       *       Fecha: 10/Oct/2007.                                               *
       *     Versión: 1.0.0                                                      *
       ***************************************************************************/
      private class c_SP
      {
         //Propiedades.
         //--Publicas.
         public Dictionary<string, stParametro> Parametros;  //Diccionario de parámetros.
         public struct stParametro  //Estructura de las características de un parámetro.
         {
            public SqlDbType Tipo;
            public ParameterDirection Direccion;  //Dirección de datos del parámetro.
            public object Valor;                  //Valor del parámetro.
         }
         //Métodos.
         //<Publicos>
         //----------------------------------------------------------------------------
         //    Nombre: c_SP.
         // Categoría: Constructor (Sin parámetros).
         //  Objetivo: Inicializar la clase.
         //     Autor: Ing. Israel Hinojosa Sánchez.
         //     Fecha: 09/Oct/2007.
         //----------------------------------------------------------------------------
         public c_SP()
         {
            //Inicializar diccionario de parámetros.
            Parametros = new Dictionary<string, stParametro>();
         }
         //----------------------------------------------------------------------------
         //    Nombre: ~c_SP.
         // Categoría: Destructor.
         //  Objetivo: Destruye los objetos utilizados en el formulario.
         //     Autor: Ing. Israel Hinojosa Sánchez.
         //     Fecha: 14/Sep/2007.
         //----------------------------------------------------------------------------
         ~c_SP()
         {
            Parametros = null;
         }

         //----------------------------------------------------------------------------
         //     Nombre: SetParam.
         //  Categoría: Procedimiento de usuario.
         //   Objetivo: Establece las propiedades de un parámetro.
         // Parámetros:
         //             -Entrada-
         //                 psParametro: Nombre del parámetro. ("@pnDato")
         //                     poTiipo: Dirección del parámetro.
         //                     poValor: Valor del parámetro.
         //      Autor: Ing. Israel Hinojosa Sánchez.
         //      Fecha: 09/Oct/2007.
         //----------------------------------------------------------------------------
         public void AddParam(string psParametro, SqlDbType poTipo, ParameterDirection poDireccion, object poValor)
         {
            stParametro oParametro = new stParametro();  //Estructura de tipo parámetro.

            //[1]Llenar Estructura.
            oParametro.Tipo=poTipo;
            oParametro.Direccion = poDireccion;
            oParametro.Valor = poValor;

            //[2]Agregar estructura a diccionario.
            Parametros.Add(psParametro, oParametro);
         }

         //----------------------------------------------------------------------------
         //     Nombre: CambiaValParam.
         //  Categoría: Procedmiento de usuario.
         //   Objetivo: Cambia el valor de un parámetro dentro de un stored procedure.
         // Parámetros:
         //             -Entrada-
         //                psParametro: Nombre del parámetro. ("@pnDato")
         //                    poValor: Valor del parámetro.
         //      Autor: Ing. Israel Hinojosa Sánchez.
         //      Fecha: 09/Oct/2007.
         //----------------------------------------------------------------------------
         public void CambiaValParam(string psParametro, object poValor)
         {
            stParametro oParametro = new stParametro();  //Estructura de tipo parámetro.

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
