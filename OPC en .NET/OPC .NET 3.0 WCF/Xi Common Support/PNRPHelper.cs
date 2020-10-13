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

using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Net.PeerToPeer;

namespace Xi.Common.Support
{
	/// <summary>
	/// These methods are used to set and resolve PNRP services through the
	/// PeerToPeer protocol stack built into Windows Vista/Windows 7 and optionally
	/// available on Windows XP.
	/// </summary>
	public static class PNRPHelper
	{
		/// <summary>
		/// Locate all the registered services for a given mesh name
		/// </summary>
		/// <param name="meshName"></param>
		/// <returns></returns>
		public static List<string> ResolveServices(string meshName)
		{
			PeerNameResolver pnr = new PeerNameResolver();
			PeerNameRecordCollection pnrc = pnr.Resolve(new PeerName(meshName, PeerNameType.Unsecured));
			List<string> urls = new List<string>(); ;
			foreach (var peer in pnrc)
			{
				foreach (var ep in peer.EndPointCollection)
				{
					if (ep.AddressFamily == AddressFamily.InterNetwork)
					{
						string url = Encoding.ASCII.GetString(peer.Data);
						urls.Add(url);
					}
				}
			}
			IEnumerable<string> distinctUrls = urls.Distinct();
			urls = distinctUrls.ToList();
			return urls;
		}

		/// <summary>
		/// This registers a given port + url with a specified mesh
		/// </summary>
		/// <param name="meshName"></param>
		/// <param name="port"></param>
		/// <param name="url"></param>
		/// <returns></returns>
		public static PeerNameRegistration RegisterService(string meshName, int port, string url)
		{
			// Register with the PNRP service
			PeerNameRegistration reg = null;
			try
			{
				PeerName pName = new PeerName(meshName, PeerNameType.Unsecured);
				reg = new PeerNameRegistration(pName, port)
				{
					UseAutoEndPointSelection = true,
					Data = Encoding.ASCII.GetBytes(url)
				};
				reg.Start();
			}
			catch { reg = null; }
			return reg;
		}

	}
}
