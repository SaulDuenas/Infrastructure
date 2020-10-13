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

using System.Diagnostics;

namespace Xi.Server.Base
{
	/// <summary>
	/// This is the base class for the server - it provides tracing support in a concrete
	/// singleton implementation so any other type can get to the stored TraceSource.
	/// </summary>
	public class XiTracer
	{
		class TraceForwarder : TraceListener
		{
			public override void Write(string message)
			{
				WriteLine(message);
			}

			public override void WriteLine(string message)
			{
				TraceSource.TraceEvent(TraceEventType.Error, 0, message);
			}
		}

		/// <summary>
		/// The singleton trace source used for diagnostic reporting
		/// </summary>
		public static readonly TraceSource TraceSource = new TraceSource("XiServer");

		/// <summary>
		/// Constructor that modifies the default trace listener list.
		/// </summary>
		static XiTracer()
		{
#if DEBUG
			Debug.Listeners.Add(new TraceForwarder());
#elif TRACE
            Trace.Listeners.Add(new TraceForwarder());
#endif
		}
	}
}
