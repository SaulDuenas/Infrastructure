using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Opc.Da;

namespace Teseracto.OpcClient
{
   public class TSR_OPC
   {
      #region Variables privadas
      private Dictionary<string, Server> _servers = new Dictionary<string, Server>();
      private Dictionary<string, Grupo> _grupos = new Dictionary<string, Grupo>();
      private Server _server = null;
      private string _errorMsg = "";
      private string _opcServerName = "";
      private string _host = "";
      private string _remoteUser;
      private string _remotePassword;
      #endregion

      public delegate void OpcServerTerminadoDelegate(string motivo);
      public event OpcServerTerminadoDelegate OpcServerTerminado;
      /// <summary>
      /// Crea un objeto TSR_OPC que es un cliente OPC
      /// </summary>
      public TSR_OPC()
         : this("localhost","","")
      {
      }
      public TSR_OPC(string remoteServerName,string remoteUser,string remotePassword)
      {
         _host = remoteServerName;
         _remoteUser = remoteUser;
         _remotePassword = remotePassword;
         CargaServers();
      }

      private void CargaServers()
      {
         Opc.Server[] servers=new Opc.Server[1];
         OpcCom.ServerEnumerator en = new OpcCom.ServerEnumerator();
         if (_host == "localhost")
         {
            servers = en.GetAvailableServers(Opc.Specification.COM_DA_20);
         }
         else
         {
            /* este intento de plano no jala por cuestiones de seguridad. (CoCreateInstanceEx: Acceso denegado.) */
            //Opc.ConnectData connData=new Opc.ConnectData(new System.Net.NetworkCredential(_host+"\\"+_remoteUser,_remotePassword),new System.Net.WebProxy());
            //servers = en.GetAvailableServers(Opc.Specification.COM_DA_20,_host,connData);
            
            //voy a intentar crear el server a pata
            OpcCom.Factory mFactory = new OpcCom.Factory();
            Opc.URL mURL = new Opc.URL("opcda://" + _host + "/RSLinx Remote OPC Server");
            //Opc.Da.Server mserver = new Opc.Da.Server(mFactory, mURL);
            servers[0] = new Opc.Da.Server(mFactory, mURL);
            System.Net.NetworkCredential mCredentials = new System.Net.NetworkCredential(".\\MTB","mapache11");
            Opc.ConnectData mConnectData = new Opc.ConnectData(mCredentials);
            servers[0].Connect(mURL, mConnectData);
         }
         foreach (Server server in servers)
         {
            _servers.Add(server.Name, (Opc.Da.Server)server);
         }
      }

      /// <summary>
      /// Devuelve una lista de servidores OPC locales
      /// </summary>
      public string[] GetLocalServers()
      {
         int i = 0;
         string[] list = new string[_servers.Count];
         foreach (string srv in _servers.Keys)
         {
            list[i++] = srv;
         }
         return list;
      }

      /// <summary>
      /// Se conecta a un servidor OPC
      /// </summary>
      /// <param name="opcServerName">Nombre del servidor OPC al que se desea conactar, el servidor debe existir (usar GetLocalServers para estar seguro)</param>
      /// <returns>true si se pudo conectar, falso si no, (checar el mensaje de error en la propiedad ErrorMessage</returns>
      public bool Conectar(string opcServerName)
      {
         bool ok = true;

         //Intenta conectarse al servidor OPC
         _opcServerName = opcServerName;
         _server = _servers[_opcServerName];
         try
         {
            _server.Connect();
            _server.ServerShutdown += new Opc.ServerShutdownEventHandler(OpcServer_Shutdown);
         }
         catch (Opc.ConnectFailedException ex)
         {
            ok = false;
            _errorMsg = ex.Message + ex.InnerException.Message;
         }
         catch (Exception ex)
         {
            ok = false;
            _errorMsg = ex.Message;
         }

         if (ok)
         {
            ok = EstadoServidorOk();
            ok = ok && _server.IsConnected;
         }

         return ok;
      }

      public bool EstadoServidorOk()
      {
         bool ok = true;
         //pregunta por el estado del servidor
         ServerStatus stat = new ServerStatus();
         try
         {
            stat = _servers[_opcServerName].GetStatus();
         }
         catch (Opc.ResultIDException ex)
         {
            ok = false;
            _errorMsg = "El servidor OPC se encuentra en falla: Posiblemente esta caído";
         }
         if (ok && (stat.ServerState != Opc.Da.serverState.running))
         {
            ok = false;
            _errorMsg = "El servidor OPC se encuentra en falla: " + stat.ServerState.ToString();
         }
         return ok;
      }

      void OpcServer_Shutdown(string reason)
      {
         if (OpcServerTerminado!=null)
            OpcServerTerminado(reason);
      }

      /// <summary>
      /// Crea un grupo OPC
      /// </summary>
      public Grupo CrearGrupo(string nombre, int updateRateMs)
      {
         //Crea el nuevo grupo
         Grupo nuevoGrupo = new Grupo(_server, nombre, updateRateMs);

         //lo añade a la colección
         _grupos.Add(nombre, nuevoGrupo);

         //grupo.DataChanged += new DataChangedEventHandler(Grupo_DataChanged);

         return nuevoGrupo;
      }


      public void Desconectar()
      {

         try { _server.Disconnect(); }
         catch { }
         try { _server.Dispose(); }
         catch { }
         _server = null;

         foreach (var srv in _servers)
         {
            try { srv.Value.Disconnect(); }
            catch { }
            try { srv.Value.Dispose(); }
            catch { }
         }
         _servers.Clear();
      }

      public bool Reconectar()
      {
         Desconectar();
         CargaServers();
         bool ok = Conectar(_opcServerName);
         if (ok)
         {
            foreach (var item in _grupos)
            {
               ok = ok && item.Value.Regenera(_server);
            }
         }
         return ok;
      }

      public string ErrorMessage
      {
         get { return _errorMsg; }
      }

      public Dictionary<string, Subscription> Grupos
      {
         get
         {
            throw new System.NotImplementedException();
         }
         set
         {
         }
      }


   }
}
