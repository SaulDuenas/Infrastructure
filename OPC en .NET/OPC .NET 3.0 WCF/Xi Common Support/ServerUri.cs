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
using Xi.Contracts.Data;

namespace Xi.Common.Support
{
	public class ServerUri
	{
		public static void ReconcileServerEntryWithServerDiscoveryUrl
			(ServerEntry serverEntry, string serverDiscoveryUrl)
		{
			UriBuilder ubServerUrl = new UriBuilder(serverDiscoveryUrl);
			serverEntry.ServerDescription.ServerDiscoveryUrl = serverDiscoveryUrl;
			bool found = false;
			foreach (var mexEp in serverEntry.MexEndpoints)
			{
				UriBuilder ubMex = new UriBuilder(mexEp.Url);
				if (ubServerUrl.Host == ubMex.Host)
				{
					found = true;
					break;
				}
			}
			if (!found) // if the server host was not found, insert an entry for it
			{
				UriBuilder ubNew = new UriBuilder(serverEntry.MexEndpoints[0].Url);
				ubNew.Host = ubServerUrl.Host;
				MexEndpointInfo mi = new MexEndpointInfo()
				{
					Description = "Auto Created by Discovery Server to use Discovery Server Host Name or IP Address)",
					EndpointName = "Mex Endpoint for " + ubServerUrl.Host,
					Url = ubNew.Uri.AbsoluteUri
				};
				serverEntry.MexEndpoints.Insert(0, mi);
			}
		}
	}
}
