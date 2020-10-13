/**********************************************************************
 * Copyright © 2009, 2010 OPC Foundation, Inc. 
 *
 * All binaries built with the "OPC .NET 3.0 (WCF Edition)" source code 
 * are subject to the terms of the Express Interface Public License (Xi-PL).
 * See http://www.opcfoundation.org/License/Xi-PL/
 *
 * The source code itself is also covered by the Xi-PL except the source code 
 * cannot be redistributed in its original or modified form unless
 * it has been incorporated into a product or system sold by an OPC Foundation 
 * member that adds value to the codebase. 
 *
 * You must not remove this notice, or any other, from this software.
 *
 *********************************************************************/

using System;
using System.Configuration;
using System.Linq;
using System.Diagnostics;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Collections.ObjectModel;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.ServiceModel.Description;
using System.ServiceModel.Activation;
using System.Threading;
using System.Net.PeerToPeer;
using System.Reflection;

using Xi.Contracts;
using Xi.Contracts.Data;
using Xi.Contracts.Constants;
using Xi.Common.Support;
using Xi.Common.Support.Extensions;

namespace Xi.Server.Base
{
	/// <summary>
	/// This is the root class for Xi Servers.  It supports the Server
	/// Discovery interface allowing all servers derived from it to 
	/// be Discovery Servers.  It also includes some essential
	/// startup and stop functionality for the server.
	/// </summary>
	public partial class ServerRoot
		: XiTracer
		, IServerDiscovery
	{
		/// <summary>
		/// This property is used to obtain the number of server types 
		/// supported by this server
		/// </summary>
		public static uint NumServerTypes
		{
			get { return _NumServerTypes; }
			private set { }
		}

		/// <summary>
		/// The number of server types supported by this server. 
		/// Implementation subclasses of this base class must update this value.
		/// </summary>
		protected static uint _NumServerTypes = 0;

		private static PeerNameRegistration _pnRegister;

		/// <summary>
		/// The ServiceHost being used with this server
		/// </summary>
		public static ServiceHost ServiceHost { get; private set; }

		/// <summary>
		/// protect list updates
		/// </summary>
		private static Mutex _ServerEntriesLock;

		/// <summary> 
		/// The Uri's for base addresses to be added when initializing the ServiceHost. 
		/// Only Uri's added before the call to Initialize will be applied. 
		/// </summary> 
		public static Uri[] ServiceHostBaseAddressArray
		{
			get
			{
				_serviceHostBaseAddresses = new List<Uri>();
				// TODO:  Add the service endpoint BaseAddresses if these base addresses
				//        are not defined in the app.config.  
				return _serviceHostBaseAddresses.ToArray();

			}
		}
		internal static List<Uri> _serviceHostBaseAddresses;

		/// <summary>
		/// This constructor os called only from IIS for IIS hosted servers
		/// </summary>
		public ServerRoot()
		{
			string WcfVirtualPath;
			string WcfPhysicalPath;
			ServiceHostBase shb = null;

			OperationContext oc = OperationContext.Current;
			if (oc != null)
			{
				shb = oc.Host;
				if (shb != null)
				{
					ServiceHost = shb as ServiceHost;

					VirtualPathExtension extension = shb.Extensions.Find<VirtualPathExtension>();
					if (extension != null)    // IIS or WAS hosted
						WcfVirtualPath = extension.VirtualPath;
				}
			}
			WcfPhysicalPath = System.Web.Hosting.HostingEnvironment.ApplicationPhysicalPath;
		}

		/// <summary>
		/// This is used to create the service host object
		/// </summary>
		/// <param name="serviceType"></param>
		public static void Initialize(Type serviceType)
		{
			ServiceHost = new ServiceHost(serviceType, ServiceHostBaseAddressArray);
			_ThisServerEntry = new ServerEntry();
			_ThisServerEntry.ServerDescription = new ServerDescription();
			_ThisServerEntry.ServerDescription.HostName = System.Environment.MachineName;
		}

		/// <summary>
		/// This starts the XiServer class - one of the Create methods must be called
		/// prior to this.
		/// </summary>
		/// <param name="serverMesh">
		/// This is server mesh name as defined in EndpointDefinition
		/// XiDiscoveryServerMesh or XiServerMesh
		/// </param>
		/// <returns></returns>
		public static bool Start(string serverMesh, bool isIIShosted)
		{
			if (ServiceHost == null)
				throw new InvalidOperationException("ServiceHost has not been created.  Call Create() prior to Start()");

			if (!isIIShosted)
			{
				if (ServiceHost.State != CommunicationState.Created)
					throw new InvalidOperationException("ServiceHost has already been started or is in some improper state.");
			}

			TraceSource.TraceInformation("Server is starting.");
			try
			{
				// set the base elements of the server description to support 
				// Identify() method calls called without a context.
				NameValueCollection appSettings = ConfigurationManager.AppSettings;

				if (0 == string.Compare(PnrpMeshNames.XiDiscoveryServerMesh, serverMesh, true))
				{
					_ThisServerEntry.ServerDescription.ServerTypes = ServerType.Xi_ServerDiscoveryServer;
					_NumServerTypes++;
				}

				string vendorName = appSettings["Vendor"];
				if (null != vendorName && 0 < vendorName.Length)
				{
					_ThisServerEntry.ServerDescription.VendorName = vendorName;
					//Set the VendorNamespace to the VendorName
					_ThisServerEntry.ServerDescription.VendorNamespace = vendorName;
				}

				string userInfo = appSettings["UserInfo"];
				if (null != userInfo && 0 < vendorName.Length)
				{
					_ThisServerEntry.ServerDescription.UserInfo = userInfo;
				}

				string serverName = appSettings["Server"];
				if (null != serverName && 0 < serverName.Length)
				{
					_ThisServerEntry.ServerDescription.ServerName = serverName;
				}

				_ThisServerEntry.ServerDescription.ServiceName = "XiServices";
				string serviceName = appSettings["Service"];
				if (null != serviceName && 0 < serviceName.Length)
				{
					_ThisServerEntry.ServerDescription.ServiceName = serviceName;
				}

				string systemName = appSettings["System"];
				if (null != systemName && 0 < systemName.Length)
				{
					_ThisServerEntry.ServerDescription.SystemName = systemName;
				}

				// discover all MEX endpoints
				Collection<ServiceEndpoint> mexEndpoints = ServerRoot.ServiceHost.Description.Endpoints.FindAll(typeof(IMetadataExchange));

				_ThisServerEntry.MexEndpoints = new List<MexEndpointInfo>(mexEndpoints.Count);
				if (mexEndpoints != null) // OK to be null for Directory servers
				{
					foreach (var ep in mexEndpoints)
					{
						MexEndpointInfo mep = new MexEndpointInfo()
						{
							Description = ep.Binding.Name,
							EndpointName = ep.Name,
							Url = ReplaceLocalhostInURLwithHostname(ep.ListenUri.AbsoluteUri)
						};
						_ThisServerEntry.MexEndpoints.Add(mep);
					}
				}
				// copy a selection of endpoint setting into the server info
				_ThisServerEntry.EndpointServerSettings = CopyEndpointSettings(ServerRoot.ServiceHost.Description);

				// Set the endpoint timeout to a big value
				// Setting of the binding timeouts should probably be based off of values in the App.Config file
				Collection<ServiceEndpoint> allEndpoints = ServiceHost.Description.Endpoints;
				foreach (var ep in allEndpoints)
				{
					ep.Binding.ReceiveTimeout = new TimeSpan(20, 0, 0, 0);
					ep.Binding.SendTimeout = new TimeSpan(0, 15, 0);
				}

				if (!isIIShosted)  //don't open when IIS hosted
					ServiceHost.Open();

				// Start the Resolver Thread if this is a Discovery Server 
				if ((_ThisServerEntry.ServerDescription.ServerTypes & ServerType.Xi_ServerDiscoveryServer) > 0)
				{
					_ServerEntriesLock = new Mutex();
					_resolverThread = new Thread(ResolverThread) { Name = "Xi Discovery Resolver Thread", IsBackground = true };
					_resolverThread.Start();
				}
				else
				{
					EndpointConfigurationExList = getEndpointConfigExList();
				}
			}

			catch (Exception ex)
			{
				TraceSource.TraceEvent(TraceEventType.Error, 0, ex.Message);
				try { ServiceHost.Close(); }
				catch { /* do nothing */ }
			}

			return true;
		}

		/// <summary>
		/// This method returns a list of EndpointConfigurationEx objects for the endpoints supported by the server
		/// </summary>
		/// <returns>Returns a list of EndpointConfigurationEx objects for the endpoints supported by the server</returns>
		private static List<EndpointConfigurationEx> getEndpointConfigExList()
		{
			List<EndpointConfigurationEx> epdefs = new List<EndpointConfigurationEx>();
			foreach (var epConfig in _ThisServerEntry.EndpointServerSettings)
			{
				// do not add net pipe endpoints to the list
				UriBuilder ub = new UriBuilder(epConfig.EndpointUrl);
				if ((ub != null) && (ub.Scheme != Uri.UriSchemeNetPipe))
				{
					EndpointConfigurationEx epConfigEx = new EndpointConfigurationEx()
					{
						CloseTimeout = epConfig.CloseTimeout,
						ContractType = epConfig.ContractType,
						EndpointName = epConfig.EndpointName,
						EndpointUrl = epConfig.EndpointUrl,
						MaxBufferSize = epConfig.MaxBufferSize,
						MaxItemsInObjectGraph = epConfig.MaxItemsInObjectGraph,
						OpenTimeout = epConfig.OpenTimeout,
						ReceiveTimeout = epConfig.ReceiveTimeout,
						SendTimeout = epConfig.SendTimeout,
					};
					epdefs.Add(epConfigEx);
				}
			}
			// now add the extended data members to each
			foreach (System.ServiceModel.Description.ServiceEndpoint sep in ServerRoot.ServiceHost.Description.Endpoints)    // all configured endpoints
			{
				if (   (sep.Contract.ContractType == typeof(IResourceManagement))
				    || (sep.Contract.ContractType == typeof(IRead))
				    || (sep.Contract.ContractType == typeof(IWrite))
				    || (sep.Contract.ContractType == typeof(IPoll))
				    || (sep.Contract.ContractType == typeof(IRegisterForCallback))
				   )
				{
					EndpointConfigurationEx epConfigEx = epdefs.Find(ep => ep.EndpointUrl == sep.Address.Uri.OriginalString);
					if (epConfigEx != null)
					{
						System.ServiceModel.BasicHttpBinding bhp = sep.Binding as System.ServiceModel.BasicHttpBinding;
						System.ServiceModel.NetTcpBinding tcpb = sep.Binding as System.ServiceModel.NetTcpBinding;
						System.ServiceModel.NetNamedPipeBinding pipeb = sep.Binding as System.ServiceModel.NetNamedPipeBinding;
						if (pipeb == null)   // not NetNamedPipeBinding
						{
							epConfigEx.BindingScheme = sep.Binding.Scheme;
							epConfigEx.BindingType = sep.Binding.Name;

							if (bhp != null)   // BasicHttpBinding
							{
								epConfigEx.SecurityMode = bhp.Security.Mode.ToString();
								if (bhp.Security.Transport != null)
									epConfigEx.ClientCredentialType = bhp.Security.Transport.ClientCredentialType.ToString();
							}
							if (tcpb != null)   // netTcpBinding
							{
								epConfigEx.SecurityMode = tcpb.Security.Mode.ToString();
								if (tcpb.Security.Transport != null)
									epConfigEx.ClientCredentialType = tcpb.Security.Transport.ClientCredentialType.ToString();
							}
						}
					}
				}
			}
			return epdefs;
		}

		//-----------------------------------------------
		protected static List<EndpointConfiguration> CopyEndpointSettings(ServiceDescription svd)
		{
			List<EndpointConfiguration> cfg = new List<EndpointConfiguration>();
			int maxItemsInObjectGraphSVC = getMaxItemsInObjectGraph(svd.Behaviors);
			foreach (ServiceEndpoint sep in svd.Endpoints)    // all configured endpoints
			{
				// get the MaxItemsInObjectGraph for the endpoint from the endpoint behavior
				int maxItemsInObjectGraphEP = getMaxItemsInObjectGraph(sep.Behaviors);
				// set the MaxItemsInObjectGraph for the endpoint as the max of the service 
				// behaviors and endpoint behaviors
				if (maxItemsInObjectGraphSVC > maxItemsInObjectGraphEP)
					maxItemsInObjectGraphEP = maxItemsInObjectGraphSVC;

				if ((sep.Contract.ContractType == typeof(IResourceManagement))
					|| (sep.Contract.ContractType == typeof(IRead))
					|| (sep.Contract.ContractType == typeof(IWrite))
					|| (sep.Contract.ContractType == typeof(IPoll))
					|| (sep.Contract.ContractType == typeof(IRegisterForCallback))
				   )
				{
					EndpointConfiguration epcfg = new EndpointConfiguration();
					epcfg.EndpointName = sep.Name;
					epcfg.EndpointUrl = sep.Address.Uri.OriginalString;
					epcfg.MaxItemsInObjectGraph = maxItemsInObjectGraphEP;
					CopyBindingSettings(epcfg, sep.Binding, sep.Contract.ContractType);
					cfg.Add(epcfg);
				}
			}
			return cfg;
		}

		//-----------------------------------------------
		private static int getMaxItemsInObjectGraph(KeyedByTypeCollection<IEndpointBehavior> epBehaviors)
		{
			int maxItemsInObjectGraph = 0;
			int maxItems = 0;
			foreach (var epBehavior in epBehaviors)
			{
				Type type = epBehavior.GetType();
				string typeString = type.ToString();
				if (typeString == "System.ServiceModel.Dispatcher.DataContractSerializerServiceBehavior")
				{
					PropertyInfo[] propInfoArray = type.GetProperties();
					foreach (PropertyInfo propInfo in propInfoArray)
					{
						if (propInfo.Name == "MaxItemsInObjectGraph")
						{
							if (propInfo.CanRead)
							{
								object o = propInfo.GetValue(epBehavior, null);
								maxItems = Convert.ToInt32(o);
							}
							break;
						}
					}
				}
			}
			return maxItemsInObjectGraph;
		}


		//-----------------------------------------------
		private static int getMaxItemsInObjectGraph(KeyedByTypeCollection<IServiceBehavior> svcBehaviors)
		{
			int maxItemsInObjectGraph = 0;
			foreach (var svcBehavior in svcBehaviors)
			{
				Type type = svcBehavior.GetType();
				string typeName = type.ToString();
				if (typeName == "System.ServiceModel.Dispatcher.DataContractSerializerServiceBehavior")
				{
					PropertyInfo[] propInfoArray = type.GetProperties();
					foreach (PropertyInfo propInfo in propInfoArray)
					{
						if (propInfo.Name == "MaxItemsInObjectGraph")
						{
							if (propInfo.CanRead)
							{
								object o = propInfo.GetValue(svcBehavior, null);
								maxItemsInObjectGraph = Convert.ToInt32(o);
							}
							break;
						}
					}
					break; // break after finding and process the data contract serializer
				}
			}
			return maxItemsInObjectGraph;
		}

		//-----------------------------------------------
		protected static void CopyBindingSettings(EndpointConfiguration copy, Binding setting, Type contract)
		{
			copy.ContractType = contract.Name;
			copy.OpenTimeout = setting.OpenTimeout;
			copy.CloseTimeout = setting.CloseTimeout;
			copy.SendTimeout = setting.SendTimeout;
			copy.ReceiveTimeout = setting.ReceiveTimeout;

			System.ServiceModel.BasicHttpBinding bhBnd = setting as BasicHttpBinding;
			if (bhBnd != null)
			{
				copy.MaxBufferSize = bhBnd.MaxBufferSize;
			}
			System.ServiceModel.WSHttpBinding wshBnd = setting as WSHttpBinding;
			if (wshBnd != null)
			{
				copy.MaxBufferSize = wshBnd.MaxReceivedMessageSize;
			}
			System.ServiceModel.WSDualHttpBinding wshdBnd = setting as WSDualHttpBinding;
			if (wshdBnd != null)
			{
				copy.MaxBufferSize = wshdBnd.MaxReceivedMessageSize;
			}
			System.ServiceModel.NetNamedPipeBinding pipeBnd = setting as NetNamedPipeBinding;
			if (pipeBnd != null)
			{
				copy.MaxBufferSize = pipeBnd.MaxBufferSize;
			}
			System.ServiceModel.NetTcpBinding tcpBnd = setting as NetTcpBinding;
			if (tcpBnd != null)
			{
				copy.MaxBufferSize = tcpBnd.MaxBufferSize;
			}
			System.ServiceModel.NetPeerTcpBinding ptcpBnd = setting as NetPeerTcpBinding;
			if (ptcpBnd != null)
			{
				copy.MaxBufferSize = ptcpBnd.MaxReceivedMessageSize;
			}
		}

		/// <summary>
		/// This method registers the server with the PeerToPeer protocol (PNRP).
		/// </summary>
		/// <param name="meshName">Mesh name</param>
		/// <param name="port">Port</param>
		public static void RegisterPNRP(string meshName)
		{
			if (ServiceHost == null)
				throw new InvalidOperationException("Cannot register PNRP until ServiceHost is started.");
			ServiceEndpoint ep = ServiceHost.Description.Endpoints.Find(typeof(IServerDiscovery));
			if (ep == null)
				throw new InvalidOperationException("Cannot register PNRP without IServerDiscovery endpoint.");
			TraceSource.TraceInformation("Registering with PNRP.");
			// Save the URL in _ThisServerEntry
			string url = ReplaceLocalhostInURLwithHostname(ep.Address.Uri.AbsoluteUri);
			_ThisServerEntry.ServerDescription.ServerDiscoveryUrl = url;
			string[] urlParts = url.Split(new char[] { '/' });
			_ThisServerEntry.ServerDescription.ServiceName = urlParts[urlParts.Length - 2];
			_pnRegister = PNRPHelper.RegisterService(meshName, ep.Address.Uri.Port, url);
		}

		public static string ReplaceLocalhostInURLwithHostname(string url)
		{
			UriBuilder ub = new UriBuilder(url);
			if (string.Compare("localhost", ub.Host) == 0)
				ub.Host = System.Environment.MachineName;
			return ub.ToString();
		}

		/// <summary>
		/// This method stops the service host and PNRP registration (if any).
		/// </summary>
		public static void Stop()
		{
			if (_pnRegister != null)
				_pnRegister.Stop();

			ServiceHost host = ServiceHost;
			if (host != null)
			{
				TraceSource.TraceInformation("Server is stopping.");
				try
				{
					if (host.State != CommunicationState.Faulted)
					{
						try
						{
							host.Close();
						}
						catch (Exception ex)
						{
							TraceSource.TraceEvent(TraceEventType.Error, 0, ex.Message);
							host.Abort();
						}
					}
					else
					{
						try
						{
							host.Abort();
						}
						catch (Exception ex)
						{
							TraceSource.TraceEvent(TraceEventType.Error, 0, ex.Message);
						}
					}
				}
				finally
				{
					ServiceHost = null;
				}
			}
		}

		private class TraceCloser : IDisposable
		{
			private readonly string _methodName;
			public TraceCloser(string method)
			{
				_methodName = method;
			}
			public void Dispose()
			{
				TraceSource.TraceEvent(TraceEventType.Stop, 0, _methodName);
			}
		}

		/// <summary>
		/// This is used to log method entries in the server
		/// </summary>
		/// <param name="function">Function called</param>
		/// <param name="args">Arguments</param>
		/// <returns>TraceCloser object to log exit of method</returns>
		protected IDisposable EnterMethod(string function, params object[] args)
		{
			if (TraceSource.Switch.ShouldTrace(TraceEventType.Start))
			{
				string method = string.Format("{0}({1})", function,
											  String.Join(",", args.Select(o => (o != null) ? o.ToString() : "(null)").ToArray()));

				OperationContext ctx = OperationContext.Current;
				string ipAddress; int port;
				ctx.GetRemoteAddress(out ipAddress, out port);

				if (string.IsNullOrEmpty(ipAddress))
					ipAddress = "noTcp";

				TraceSource.TraceEvent(TraceEventType.Start, 0, "{0} by [{1}] ({3}) on {2}",
					method, ipAddress, ctx.GetBinding(), ctx.GetCurrentUser());
				return new TraceCloser(function);
			}

			return null;
		}

	}
}
