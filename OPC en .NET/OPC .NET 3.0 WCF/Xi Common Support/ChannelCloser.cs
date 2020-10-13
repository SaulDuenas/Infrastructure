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
using System.ServiceModel;

namespace Xi.Common.Support
{
	/// <summary>
	/// This class is used to properly close a WCF client proxy.  It aborts or closes
	/// the proxy based on the channel status and whether an exception is encountered.
	/// It has two calling methods, one where the proxy has a short life, and the other
	/// to be used when the proxy is held over the life of a single method.
	/// </summary>
	/// <example>
	/// Usage 1: Short lived proxy
	/// void SomeMethod()
	/// {
	///     SomeWcfProxy proxy = new SomeWcfProxy();
	///     using (new ChannelCloser(proxy))
	///     {
	///        proxy.MakeCall();
	///         ...
	///     }
	/// }
	/// 
	/// Usage 2: Long lived proxy
	/// void CreateProxy()
	/// {
	///     SomeWcfProxy proxy = new SomeWcfProxy();
	///     ...
	/// }
	/// void DestroyProxy()
	/// {
	///    ChannelCloser.Close(proxy);
	/// }
	/// </example>
	public class ChannelCloser : IDisposable
	{
		private readonly ICommunicationObject _channel;

		/// <summary>
		/// Constructs a WCF channel closer object
		/// </summary>
		/// <param name="channelObj">WCF proxy object</param>
		public ChannelCloser(object channelObj)
		{
			if (!(channelObj is ICommunicationObject))
				throw new ArgumentException("Channel object must implement ICommunicationObject");
			_channel = (ICommunicationObject)channelObj;
		}

		/// <summary>
		/// Properly releases and closes the held WCF proxy
		/// </summary>
		public void Dispose()
		{
			Close(_channel);
		}

		/// <summary>
		/// This method closes the passed proxy object
		/// </summary>
		/// <param name="obj"></param>
		public static void Close(object obj)
		{
			if (obj != null)
			{
				var channelObj = obj as ICommunicationObject;
				if (channelObj == null)
					throw new ArgumentException("Channel object must implement ICommunicationObject", "obj");

				// if the channel faults you cannot Close/Dispose it - instead you have to Abort it
				if (channelObj.State == CommunicationState.Faulted)
					channelObj.Abort();
				else if (channelObj.State != CommunicationState.Closed)
				{
					try
					{
						channelObj.Close();
					}
					catch (TimeoutException)
					{
						channelObj.Abort();
					}
					catch (CommunicationException)
					{
						channelObj.Abort();
					}
				}
			}
		}
	}
}
