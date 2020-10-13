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

using Xi.Common.Support;
using Xi.Contracts;
using Xi.Contracts.Constants;
using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	/// <summary>
	/// This partial class implements the IRegisterForCallback interface
	/// </summary>
	public abstract partial class ServerBase<TContext, TList> : ServerRoot
									, IRegisterForCallback
									where TContext : ContextBase<TList>
									where TList : ListRoot
	{
		SetCallbackResult IRegisterForCallback.SetCallback(string contextId,
			uint keepAliveSkipCount, TimeSpan callbackRate)
		{
			using (EnterMethod("IRegisterForCallback.SetCallback", contextId))
			{
				try
				{
					TContext context = ContextManager<TContext, TList>.LookupContext(contextId, false);
					if (context == null)
						throw FaultHelpers.Create(XiFaultCodes.E_NOCONTEXT);

					OperationContext oc = OperationContext.Current;
					if (null == oc)
						throw FaultHelpers.Create("Failed to obtain the OperationContext");

					ICallback iCallBack = oc.GetCallbackChannel<ICallback>();

					return context.OnSetCallback(iCallBack, keepAliveSkipCount, callbackRate);
				}
				catch (FaultException<XiFault> fe)
				{
					throw fe;
				}
				catch (Exception ex)
				{
					throw FaultHelpers.Create(ex);
				}
			}
		}

	}
}
