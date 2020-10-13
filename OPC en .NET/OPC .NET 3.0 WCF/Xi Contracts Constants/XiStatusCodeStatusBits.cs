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

namespace Xi.Contracts.Constants
{
	/// <summary>
	/// <para>The Status Bits indicate whether a value is good, bad, or uncertain, and when bad, 
	/// whether or not the bad status was assigned by the server. Server assigned bad status codes 
	/// are typically assigned when the server is unable to retrieve the value from the underlying system.</para>  
	/// <para>The Status Bits also include a description of the status that describes why a value was good,
	/// bad, or uncertain.</para>
	/// </summary>
	public enum XiStatusCodeStatusBits
	{
		#region Bad Status Bits
		/// <summary>
		/// The value is bad but no specific reason is known. 
		/// </summary>
		BadNonSpecific                      = 0x00,

		/// <summary>
		/// There is some server specific problem with the 
		/// configuration. For example the item in question has 
		/// been deleted from the configuration.
		/// </summary>
		BadConfigError                      = 0x01,

		/// <summary>
		/// The input is required to be logically connected to 
		/// something but is not. This quality may reflect that no 
		/// value is available at this time, for reasons like the 
		/// value may have not been provided by the data source.
		/// </summary>
		BadNotConnected                     = 0x02,

		/// <summary>
		/// A device failure has been detected.
		/// </summary>
		BadDeviceFailure                    = 0x03,

		/// <summary>
		/// A sensor failure had been detected (the ’Limits’ field 
		/// can provide additional diagnostic information in some 
		/// situations).
		/// </summary>
		BadSensorFailure                    = 0x04,

		/// <summary>
		/// Communications have failed. However, the last known value 
		/// is available. Note that the ‘age’ of the value may be 
		/// determined from its timestamp.
		/// </summary>
		BadLastKnownValue                   = 0x05,

		/// <summary>
		/// Communications have failed. There is no last known 
		/// value available.
		/// </summary>
		BadCommFailure                      = 0x06,

		/// <summary>
		/// The block is off scan or otherwise locked. This code 
		/// is also used when the Monitored Item or Subscription
		/// is disabled.
		/// </summary>
		BadOutOfService                     = 0x07,

		/// <summary>
		/// After Items are added to a group, it may take some time 
		/// for the server to actually obtain values for these items. 
		/// In such cases the client might perform a read (from cache), 
		/// or establish a ConnectionPoint based subscription and/or 
		/// execute a Refresh on such a subscription before the values 
		/// are available. This substatus is only available from 
		/// OPC DA 3.0 or newer servers.
		/// </summary>
		BadWaitingForInitialData            = 0x08,

		#endregion // Bad Status Bits

		#region Uncertain Status Bits
		/// <summary>
		/// There is no specific reason why the value is uncertain. 
		/// </summary>
		UncertainNonSpecific                = 0x10,

		/// <summary>
		/// Whatever was writing this value has stopped doing so. The 
		/// returned value should be regarded as ‘stale’. Note that this 
		/// differs from a BAD value with Substatus = Last Known Value. 
		/// That status is associated specifically with a detectable 
		/// communications error on a ‘fetched’ value. This error is 
		/// associated with the failure of some external source to ‘put’ 
		/// something into the value within an acceptable period of time. 
		/// Note that the ‘age’ of the value can be determined from 
		/// the timestamp. 
		/// </summary>
		UncertainLastUsableValue            = 0x11,

		/// <summary>
		/// Either the value has ‘pegged’ at one of the sensor limits 
		/// (in which case the limit field should be set to LowLimited 
		/// or HighLimited) or the sensor is otherwise known to be out 
		/// of calibration via some form of internal diagnostics (in 
		/// which case the limit field should be NotLimited). 
		/// </summary>
		UncertainSensorNotAccurate          = 0x14,

		/// <summary>
		/// The returned value is outside the limits defined for this 
		/// parameter. Note that in this case (per the Fieldbus 
		/// Specification) the ‘Limits’ field indicates which limit 
		/// has been exceeded but does NOT necessarily imply that the 
		/// value cannot move farther out of range. 
		/// </summary>
		UncertainEngineeringUnitsExceeded   = 0x15,

		/// <summary>
		/// The value is derived from multiple sources and has less 
		/// than the required number of Good sources. 
		/// </summary>
		UncertainSubNormal                  = 0x16,

		#endregion // Uncertain Status Bits

		#region Bad Server Access Status Bits
		/// <summary>
		/// The value is bad but no specific reason is known.        
		/// </summary>
		BadServerAccessNonSpecific          = 0x20,

		/// <summary>
		/// The format of the InstanceId is not valid. 
		/// </summary>
		BadServerAccessInstanceIdInvalid    = 0x21,

		/// <summary>
		/// The InstanceId refers to a object that could not be found.         
		/// </summary>
		BadServerAccessObjectUnknown        = 0x22,

		/// <summary>
		/// The InstanceId refers to element of an object and that 
		/// element could not be found.         
		/// </summary>
		BadServerAccessObjectElementUnknown = 0x23,

		/// <summary>
		/// Access to the value was denied.         
		/// </summary>
		BadServerAccessAccessDenied         = 0x24,

		#endregion // Bad Server Status Bits

		#region Good Status Bits
		/// <summary>
		/// The value is good. This is the general mask for all good values.
		/// </summary>
		GoodNonSpecific                     = 0x30,

		/// <summary>
		/// The value has been Overridden. Typically this is means the 
		/// input has been disconnected and a manually entered value has 
		/// been written to data object.
		/// </summary>
		GoodLocalOverride                   = 0x36,
		#endregion // Good Status Bits

	}
}
