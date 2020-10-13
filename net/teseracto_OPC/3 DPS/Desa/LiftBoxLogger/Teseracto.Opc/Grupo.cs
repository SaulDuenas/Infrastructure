using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using Opc.Da;


namespace Teseracto.OpcClient
{

   /// <summary>
   /// Ocurre cuando los tags del grupo han sido leidos
   /// </summary>
   public delegate void GrupoActualizadoDelegate(string nombreGrupo, List<DataPoint> datapoints);
   public delegate void TagActualizadoDelegate(string nombreGrupo, DataPoint item);

   public class Grupo
   {
      //variables privadas de propiedades
      private List<DataPoint> _dataPoints;
      private string _nombre;
      private int _updateRate;

      internal Guid _clientHandle;
      internal int _serverHandle;
      private List<Item> _opcItemList;
      private ReadOnlyCollection<DataPoint> _readOnlyDataPoints;
      internal Server _server;
      private Subscription _grupoOPC;
      private bool _modoTriggers;
      private bool _activo;

      #region Constructores
      /// <summary>
      /// Crea un Grupo OPC
      /// </summary>
      /// <param name="server">Servidor OPC al que se conectará el grupo</param>
      /// <param name="nombre">Nombre del grupo (debe ser único)</param>
      public Grupo(Server server, string nombre)
         : this(server, nombre, 1000)
      {
      }

      /// <summary>
      /// Crea un Grupo OPC
      /// </summary>
      /// <param name="server">Servidor OPC al que se conectará el grupo</param>
      /// <param name="nombre">Nombre del grupo (debe ser único)</param>
      /// <param name="updateRate">periodo de actualización en milisegundos</param>
      public Grupo(Server server, string nombre, int updateRate)
      {
         //Inicializa objeto
         _dataPoints = new List<DataPoint>();
         _readOnlyDataPoints = new ReadOnlyCollection<DataPoint>(_dataPoints);
         _opcItemList = new List<Item>();
         _nombre = nombre;
         _updateRate = updateRate;
         _server = server;
         _modoTriggers = false;
         _activo = false;

         //Prepara la creación del grupo
         _clientHandle = Guid.NewGuid();
         SubscriptionState edoGrupo = new SubscriptionState();
         edoGrupo.Name = _nombre;
         edoGrupo.UpdateRate = _updateRate;
         edoGrupo.ClientHandle = _clientHandle;
         edoGrupo.Active = _activo;
         //edoGrupo.Deadband=??;

         //crea el grupo
         _grupoOPC = (Opc.Da.Subscription)_server.CreateSubscription(edoGrupo);
         _serverHandle = (int)_grupoOPC.ServerHandle;

         //Establece el Event Handler
         _grupoOPC.DataChanged += new DataChangedEventHandler(grupoOPC_DataChanged);
         _grupoOPC.SetEnabled(true);
      }
      #endregion

      #region Delegados
      public event GrupoActualizadoDelegate GrupoActualizado;
      public event TagActualizadoDelegate TagActualizado;
      #endregion

      #region Propiedades

      /// <summary>
      /// Lista de Datapoints
      /// </summary>
      public ReadOnlyCollection<DataPoint> DataPoints
      {
         get
         {
            return _readOnlyDataPoints;
         }
      }

      /// <summary>
      /// Nombre del grupo
      /// </summary>
      public string Nombre
      {
         get
         {
            throw new System.NotImplementedException();
         }
         set
         {
         }
      }

      /// <summary>
      /// Periodo de muestreo en milisegundos
      /// </summary>
      public int UpdateRate
      {
         get
         {
            throw new System.NotImplementedException();
         }
         set
         {
         }
      }

      /// <summary>
      /// Indica si el grupo está activo (haciendo polling)
      /// </summary>
      public bool Activo
      {
         get
         {
            _activo = _grupoOPC.Active;
            return _activo;
         }
         set
         {
            SubscriptionState edoGrupo = new SubscriptionState();
            edoGrupo.Active = value;
            try
            {
               _grupoOPC.ModifyState((int)Opc.Da.StateMask.Active, edoGrupo);
               _activo = _grupoOPC.Active;
            }
            catch
            {
               //TODO: Posiblemente se desconectó el servidor OPC
            }
         }
      }

      /// <summary>
      /// Indica si se deben generar eventos de TagActualizado
      /// </summary>
      public bool ModoTriggers
      {
         get
         {
            return _modoTriggers;
         }
         set
         {
            _modoTriggers = value;
         }
      }

      #endregion

      #region Métodos
      public bool Leer()
      {
         DataPoint punto;
         List<DataPoint> puntosAfectados = new List<DataPoint>();
         ItemValueResult[] results = null;
         bool ok = true;

         try
         {
            //lee todos los tags del grupo
            results = (ItemValueResult[])_grupoOPC.Read(_grupoOPC.Items);
         }
         catch (Opc.ResultIDException ex)
         {
            ok = false;
            if (ex.Result == Opc.ResultID.E_FAIL)
            {
               //TODO: Linx no puede comunicarse con el PLC 
            }
            if (ex.Result == Opc.ResultID.E_NOTSUPPORTED)
            {
               //TODO: Posiblemente se cayó RSLinx, se debe reintentar la conexión
            }
         }
         catch (Exception ex)
         {
            ok = false;
            //TODO: Manejar excepción
         }

         if (ok)
         {
            //pasa los resultados a los datapoints
            foreach (ItemValueResult valor in results)
            {
               punto = _dataPoints.Find(x => x._serverHandle == (int)valor.ServerHandle);
               punto.Valor = valor.Value;
               punto.Calidad = valor.Quality.ToString();
               puntosAfectados.Add(punto);
            }
         }
         return ok;
      }



      /// <summary>
      /// Agrega un nuevo tag al grupo (deja el grupo inactivo después de la operación)
      /// </summary>
      /// <param name="topico">Tópico del Tag</param>
      /// <param name="nombre">Nombre del Tag</param>
      /// <param name="tagPath">Dirección del Tag</param>
      public void AgregarTag(string topico, string nombre, string tagPath)
      {
         Item[] itemArray = new Item[1];

         //Pone el grupo en estado inactivo (en caso necesario)
         if (this.Activo)
         {
            this.Activo = false;
         }

         //crea el datapoint
         DataPoint point = new DataPoint();
         point.Topico = topico;
         point.Nombre = nombre;
         point.TagPath = tagPath;
         point._clientHandle = Guid.NewGuid();

         //crea el opcItem
         itemArray[0] = new Item();
         itemArray[0].ItemName = "[" + topico + "]" + tagPath;
         itemArray[0].ClientHandle = point._clientHandle;

         try
         {
            //añade el opcItem al grupo OPC
            ItemResult[] addResult = _grupoOPC.AddItems(itemArray);
            //también lo añade a la colección local
            _opcItemList.Add(itemArray[0]); //TODO: creo que esta variable sobra

            //Por último, añade el Datapoint a la colección
            point._serverHandle = (int)addResult[0].ServerHandle;
            _dataPoints.Add(point);
         }
         catch (Exception ex)
         {
            //TODO: MTB Falta manejar esta excepción
         }
      }


      #endregion

      #region Eventos
      void grupoOPC_DataChanged(object subscriptionHandle, object requestHandle, ItemValueResult[] values)
      {
         DataPoint punto;
         List<DataPoint> puntosAfectados = new List<DataPoint>();
         foreach (ItemValueResult valor in values)
         {
            punto = _dataPoints.Find(x => x._clientHandle == (Guid)valor.ClientHandle);
            punto.Valor = valor.Value;
            punto.Calidad = valor.Quality.ToString();
            puntosAfectados.Add(punto);
            if (_modoTriggers && TagActualizado!=null)
               TagActualizado(_nombre, punto);
         }
         if (!_modoTriggers && GrupoActualizado!=null)
            GrupoActualizado(_nombre, puntosAfectados);
      }

      #endregion


      internal bool Regenera(Server newServer)
      {
         //Reestablece el nuevo server
         _server = newServer;
         //Borra el grupo OPC viejo
         _grupoOPC.Dispose();
         _grupoOPC = null;
         

         bool ok = true;
         bool origActivo = _activo;
         //Prepara la creación del grupo
         SubscriptionState edoGrupo = new SubscriptionState();
         edoGrupo.Name = _nombre;
         edoGrupo.UpdateRate = _updateRate;
         edoGrupo.ClientHandle = _clientHandle;
         edoGrupo.Active = false;
         //crea el grupo
         _grupoOPC = (Opc.Da.Subscription)_server.CreateSubscription(edoGrupo);
         _serverHandle = (int)_grupoOPC.ServerHandle;

         //Establece el Event Handler
         _grupoOPC.DataChanged += new DataChangedEventHandler(grupoOPC_DataChanged);
         _grupoOPC.SetEnabled(true);

         //vuelve a llenar los tags
         Item[] itemArray = new Item[1];
         itemArray[0] = new Item();
         ItemResult[] addResult;

         foreach (DataPoint punto in DataPoints)
         {
            //crea el opcItem
            itemArray[0].ItemName = "[" + punto.Topico + "]" + punto.TagPath;
            itemArray[0].ClientHandle = punto._clientHandle;

            try
            {
               //añade el opcItem al grupo OPC
               addResult = _grupoOPC.AddItems(itemArray);
               punto._serverHandle = (int)addResult[0].ServerHandle;
            }
            catch (Exception ex)
            {
               //TODO: MTB Falta manejar esta excepción
            }
         }

         //Lo deja activo como estaba antes
         this.Activo = origActivo;
         //regresa
         return ok;
      }
   }
}
