using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Oracle.DataAccess.Client;
using Oracle.DataAccess.Types;

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
   public class TSR_ORA
   {
      //Propiedades.
      //--Protegidas.
      protected string sTnsName;
      protected string sUser;
      protected string sPassword;

      //--Privadas.
      private Dictionary<string, c_SP> dStoredProcedures;

      //--Publicas.
      public OracleConnection oCnn;
      public IDataReader oDatos;
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
      public TSR_ORA()
      {
         sTnsName = "";
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
      /// <param name="TnsName">Nombre del servidor oracle en tnsnames.ora</param>
      /// <param name="User">Nombre de usuario de DB</param>
      /// <param name="Password">Contraseña del usuario</param>
      public TSR_ORA(string TnsName, string User, string Password)
      {
         sTnsName = TnsName;
         sUser = User;
         sPassword = Password;
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
      ~TSR_ORA()
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
      /// <param name="TnsName">Nombre del servidor oracle en tnsnames.ora</param>
      /// <param name="User">Nombre de usuario de DB</param>
      /// <param name="Password">Contraseña del usuario</param>
      public void DBIniParam(string TnsName, string User, string Password)
      {
         sTnsName = TnsName;
         sUser = User;
         sPassword = Password;
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
      /// Se conecta a Oracle con los parámetros de conexión previamente establecidos
      /// </summary>
      /// <returns>true=Conexión exitosa</returns>
      public bool DBConectar()
      {
         string lsCadCnn = "";  //Cadena de conexión.
         string lsCadAux = "";  //Cadena auxiliar.
         bool lbOk = true;      //Validación de la conexión.

         //[1]Inicializar la cadena de conexión.
         lsCadAux = "Data Source=" + sTnsName + 
                       ";User Id=" + sUser + ";Password=******;";
         lsCadCnn = "Data Source=" + sTnsName + 
                       ";User Id=" + sUser + ";Password=" + sPassword + ";";
         try
         {
            //[2]Establecer conexión.
            oCnn = new OracleConnection(lsCadCnn);

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
            OracleCommand loCom = new OracleCommand(psQry, oCnn);

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
      //    Ejemplo: lbOk = DBEjecutarSP("spProcesa","@pnAccion",lnAccion).
      //----------------------------------------------------------------------------
      /// <summary>
      /// Ejecuta un Procedimiento Almacenado de Oracle, con parámetros de entrada y salida
      /// </summary>
      /// <param name="NombreSP">Nombre del SP</param>
      /// <param name="DummyRetVal">Valor de Retorno, SIEMPRE regresa 0</param>
      /// <param name="Parametros">Lista de parejas Parametro-valor</param>
      /// <returns>true= se ejecutó con éxito.</returns>
      public bool DBEjecutarSP(string NombreSP, out int DummyRetVal, params object[] Parametros)
      {
         bool lbOk = true;         //Validación de Operaciones.
         bool lbExisteSP = true;   //Posición del stored procedure en el diccionario.
         c_SP loSP = new c_SP();   //objeto de control clase Stored Procedure.
         int lnParam = 0;          //Índice de parámetros.
         string lsSQL = "";        //Instrucción SQL.

         try
         {
            sError="";
            //[1]Preparar stored procedure.
            OracleCommand loCom = new OracleCommand(NombreSP, oCnn);
            loCom.CommandType = CommandType.StoredProcedure;

            //[2]Verificar que el dicionario exista y sí no crearlo.
            if (dStoredProcedures == null) dStoredProcedures = new Dictionary<string, c_SP>();

            //[3]verificar que el stored procedure exista.
            if (dStoredProcedures.Count > 0)
               try { dStoredProcedures[NombreSP].ToString(); }
               catch { lbExisteSP = false; }
            else
               lbExisteSP = false;

            //[4]Verificar si se requiere refrescar parámetros y que se haya localizado el stored procedure.
            if (lbExisteSP == false)
            {
               //[4.1]Refrescar parámetros.
               OracleCommandBuilder.DeriveParameters(loCom);

               //[4.2]Establecer parámetro en diccionario de stored procedures.
               for (lnParam = 0; lnParam < loCom.Parameters.Count; lnParam++)
                     loSP.AddParam(loCom.Parameters[lnParam].ParameterName,
                                   loCom.Parameters[lnParam].OracleDbType,
                                   loCom.Parameters[lnParam].Direction,
                                   loCom.Parameters[lnParam].Value);

               //[4.3]Agregar stored procedure al diccionario
               dStoredProcedures.Add(NombreSP, loSP);
            }
            else
            {
               foreach (KeyValuePair<string, c_SP.stParametro> elem in dStoredProcedures[NombreSP].Parametros)
	            {
                  loCom.Parameters.Add(new OracleParameter(elem.Key, elem.Value.Tipo,elem.Value.Direccion));
	            }
            }

            //[5]Actualizar valores de parámetros.
            lsSQL = NombreSP + " ";
            OracleParameter p;
            DateTime auxDate;
            for (lnParam = 0; lnParam < Parametros.Length; lnParam += 2)
            {
               p=loCom.Parameters[Parametros[lnParam].ToString()];

               //*** Le pone su valor
               //es fecha?
               if ((p.OracleDbType==OracleDbType.Date) && 
                    Parametros[lnParam + 1].GetType()==typeof(string))
               {
                  if (DateTime.TryParse((string)Parametros[lnParam + 1], out auxDate))
                     p.Value=auxDate;
                  else
                     p.Value = Parametros[lnParam + 1];
               }
               else
               {
                  p.Value = Parametros[lnParam + 1];
               }


               #region /* Arma Query para mensajes de error */
               if (Parametros[lnParam + 1].GetType().ToString() == "System.String")
                  if (Parametros[lnParam + 1].ToString() == "")
                     lsSQL = lsSQL + "''";
                  else
                     lsSQL = lsSQL + "'" + Parametros[lnParam + 1].ToString().Replace("'", "''") + "'";
               else
                  if (Parametros[lnParam + 1].GetType().ToString() == "System.DateTime")
                     lsSQL = lsSQL + "CONVERT(DATETIME,'" + ((DateTime)Parametros[lnParam + 1]).ToString("dd-MM-yyyy hh:mm:ss") + "',105)";
                  else
                     lsSQL = lsSQL + Parametros[lnParam + 1].ToString();
               if (lnParam + 2 < Parametros.Length) lsSQL = lsSQL + ", ";
               #endregion
            }

            //[6]Ejecutar Stored Procedure.
            loCom.ExecuteNonQuery();

            //[7]Asignar valor de retorno de stored procedure.

            //[8]Asignar valores de salida al diccionario.
            foreach (OracleParameter param in loCom.Parameters)
            {
               dStoredProcedures[NombreSP].CambiaValParam(param.ParameterName, param.Value);
            }
         }
         catch (Exception loError)
         {
            lbOk = false;
            sError = loError.Message + "\n\nInstrucción SQL: " + lsSQL;
         }

         //[9]Retornar valor.
         DummyRetVal=0;
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
      /// <summary>
      /// Devuelve los valores de los parámetros de salida tras la ejecución de un SP
      /// </summary>
      /// <param name="NombreSP">Nombre del SP recien ejecutado</param>
      /// <param name="NomParam">Nombre del parámetro (de salida)</param>
      /// <returns>Valor del parámetro</returns>
      public object DBGetParametroSP(string NombreSP, string NomParam)
      {
         object poValor = null;

         //[1]Recuperar valor.
         poValor = dStoredProcedures[NombreSP].Parametros[NomParam].Valor;

         //[2]Retornar valor.
         return poValor;
      }

      public object DBGetParametroSP(string NombreSP, string NomParam, 
                                 out bool Existe,
                                 out ParameterDirection Direccion,
                                 out OracleDbType Tipo)
      {
         //Inicia
         object poValor = null;
         Existe=true;

         try
         {
            //Recupera valores del Parámetro
            poValor = dStoredProcedures[NombreSP].Parametros[NomParam].Valor;
            Direccion=dStoredProcedures[NombreSP].Parametros[NomParam].Direccion;
            Tipo=dStoredProcedures[NombreSP].Parametros[NomParam].Tipo;
         }
         catch
         {
            Existe=false;
            Direccion=ParameterDirection.Input;
            Tipo=OracleDbType.Int32;
         }
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
      /// <summary>
      /// Obtiene un solo dato de SQL mediante un Query
      /// </summary>
      /// <param name="psQry">Query que devuelve un solo dato</param>
      /// <returns>Valor del dato</returns>
      public object DBQryDato(string psQry)
      {
         object poDato = null;  //Dato a obtener.

         try
         {
            //[1]Establecer Instrucción SQL. 
            OracleCommand loCom = new OracleCommand(psQry, oCnn);

            //[2]Ejecutar Instrucción.
            poDato = loCom.ExecuteScalar();
         }
         catch (Exception loError)
         {
            sError = loError.Message + "\n\nInstrucción SQL: " + psQry;
            poDato = null;
         }

         //[3]Retornar valor.
         return poDato;
      }


      /***************************************************************************
       *       Clase: c_SP.                                                      *
       * Descripción: Permite establecer las funciones básicas para el manejo de *
       *              parámetros en un stored procedure.                         *
       *       Autor: Ing. Israel Hinojosa Sánchez.                              *
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
            public OracleDbType Tipo;
            public object Valor;                  //Valor del parámetro.
            public ParameterDirection Direccion;  //Dirección de datos del parámetro.
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
         public void AddParam(string psParametro, OracleDbType poTipo, ParameterDirection poDireccion, object poValor)
         {
            stParametro oParametro = new stParametro();  //Estructura de tipo parámetro.

            //[1]Llenar Estructura.
            oParametro.Tipo= poTipo;
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

            //[3]Borrar estructura anterior.
            Parametros.Remove(psParametro);

            //[4]Ingresar nueva estructura.
            Parametros.Add(psParametro, oParametro);
         }
      }
   }
}
