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
using System.Diagnostics;

using Xi.Contracts.Constants;

namespace Xi.Server.Base
{
	public class XiDiscoveryMain
	{
		/// <summary>
		/// 
		/// </summary>
		public enum MainProgramType
		{
			NoAction,
			ConsoleModeDiscoveryServer, 
			ServiceModeDiscoveryServer
		};

		private MainProgramType _mainType;

		/// <summary>
		/// 
		/// </summary>
		public EventLog EventLog { get { return _eventLog; } }
		private EventLog _eventLog = null;
		/// <summary>
		/// 
		/// </summary>
		/// <param name="mainType"></param>
		public XiDiscoveryMain(MainProgramType mainType)
		{
			_mainType = mainType;
			SetEventLog();
		}

		private void SetEventLog()
		{
			if (null != _eventLog) return;

			EventLog[] eventLogs = EventLog.GetEventLogs();
			_eventLog = eventLogs[0];
			_eventLog.Source = "OPC Xi Discovery Server";
			Debug.Assert(null != eventLogs && null != _eventLog);
			Debug.Assert(0 == string.Compare("Application", _eventLog.Log, true));
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="str"></param>
		public void WriteLine(string str)
		{
			switch (_mainType)
			{
				case MainProgramType.ConsoleModeDiscoveryServer:
					Console.WriteLine(str);
					break;

				case MainProgramType.ServiceModeDiscoveryServer:
					_eventLog.WriteEntry(str);
					break;

				default:
					break;
			}
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="str"></param>
		public void ConsoleWriteLine(string str)
		{
			switch (_mainType)
			{
				case MainProgramType.ConsoleModeDiscoveryServer:
					Console.WriteLine(str);
					break;

				case MainProgramType.ServiceModeDiscoveryServer:
					break;

				default:
					break;
			}
		}

		// ####################################################################################

		/// <summary>
		/// 
		/// </summary>
		public void OnStartDiscoveryServer()
		{
			Debug.Assert(_mainType != MainProgramType.NoAction);
			WriteLine("OPC Xi Discovery Server Starting");

			ServerRoot.Initialize(typeof(ServerRoot));

			ServerRoot.TraceSource.Listeners.Add(new ConsoleTraceListener());
			ServerRoot.TraceSource.Switch.Level = SourceLevels.All;

			ServerRoot.Start(PnrpMeshNames.XiDiscoveryServerMesh, false);

			try
			{
				ServerRoot.RegisterPNRP(PnrpMeshNames.XiDiscoveryServerMesh);
			}
			catch
			{
				WriteLine("PNRP register failed!");
			}

			WriteLine("Xi Discovery Service Running");
		}

		/// <summary>
		/// 
		/// </summary>
		public void OnStopDiscoveryServer()
		{
			ServerRoot.Stop();
			WriteLine("Xi Discovery Service Stopped");
		}
	}
}
