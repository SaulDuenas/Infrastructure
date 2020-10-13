using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Teseracto.OpcClient
{
   public class DataPoint
   {
      internal Guid _clientHandle;
      internal int _serverHandle;

      private string _nombre;
      private object _valor;
      private string _calidad;
      private string _topico;
      private string _tagPath;
      

      public string Nombre
      {
         get { return _nombre; }
         set { _nombre = value; }
      }



      public object Valor
      {
         get { return _valor; }
         set { _valor = value; }
      }


      public string Calidad 
      { 
         get {return _calidad;}
         internal set { _calidad = value; } 
      }

      public string Topico
      {
         get { return _topico; }
         set { _topico = value; }
      }

      public string TagPath
      {
         get { return _tagPath; }
         internal set { _tagPath = value; }
      }
   }
}
