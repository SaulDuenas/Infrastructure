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
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace Xi.Contracts.Data
{
	/// <summary>
	/// <para>This class contains three sets of arrays that are used to 
	/// transfer data values.  Each set is composed of an array of values, an 
	/// array of status codes, and an array of timestamps. Each set is 
	/// differentiated by the data type of the values that it holds.</para>
	/// <para>This class also contains a list of ErrorInfo. This list contains 
	/// error information as a result of:</para>
	/// <para>(1) a server alias not being found in the server.</para>
	/// <para>(2) an additional HRESULT associated with a value that the 
	/// server wishes to return.</para>
	/// <para>(1) text descriptions of errors (error messages) when requested by 
	/// the client when Initiating or Reinitiating the Context using the 
	/// EnableErrorInfo ContextOptions.  Error Messages are not permitted if 
	/// this option is not set.</para>
	/// <para>This approach was developed to optimize data transfers:</para>
	/// <para> - The value array in the first set is defined as an array 64-bit 
	/// floating point values. </para>  
	/// <para> - The value array in the second set is defined as an array 64-bit 
	/// integers. </para>  
	/// <para> - The value array in the third set is defined as an array of objects.
	/// It is used to transfer all other data types. </para>  
	/// <para>This class also contains optional error information to allow servers to 
	/// include an additional error code with a specific status code, and/or to also 
	/// provide a text description of the error. The additional error code can be 
	/// included by the server as desirec, while the error description is only used 
	/// when the Context is opened with ContextOptions set to DebugErrorMessages, 
	/// and must be null otherwise.  ContextOptions is set using the Initiate() 
	/// and ReInitiate() methods.</para>
	/// <para>The AdditionalDetailDesc property of the StatusCode FlagsByte, when 
	/// set to 7, is used to specify the existence of an additional error code. 
	/// Normally, the value of this field will be the facility code of an HRESULTor a 
	/// value that indicates that the AdditionalDetail property of the XiStatusCode 
	/// contains a server-specifc value. (see the XiStatusCode definition for more 
	/// detail.</para>
	/// <para>For any given value in an array of values, the associated status, 
	/// timestamp, and error message are located at the same index in their 
	/// respective arrays. For example, for the fourth value in a Value array, the 
	/// status, timestamp, and error message are the fourth entries in their 
	/// respective arrays.</para>
	/// </summary>
	[DataContract(Namespace = "urn:xi/data")]
	// one dimensional arrays of basic types
	[KnownType(typeof(float[]))]
	[KnownType(typeof(double[]))]
	[KnownType(typeof(byte[]))]
	[KnownType(typeof(sbyte[]))]
	[KnownType(typeof(short[]))]
	[KnownType(typeof(ushort[]))]
	[KnownType(typeof(int[]))]
	[KnownType(typeof(uint[]))]
	[KnownType(typeof(long[]))]
	[KnownType(typeof(ulong[]))]
	[KnownType(typeof(bool[]))]
	[KnownType(typeof(string[]))]
	[KnownType(typeof(object[]))]
	[KnownType(typeof(System.DateTime[]))]
	[KnownType(typeof(System.TimeSpan[]))]
	[KnownType(typeof(System.Decimal[]))]
	// two dimensional arrays of basic types
	[KnownType(typeof(float[][]))]
	[KnownType(typeof(double[][]))]
	[KnownType(typeof(byte[][]))]
	[KnownType(typeof(sbyte[][]))]
	[KnownType(typeof(short[][]))]
	[KnownType(typeof(ushort[][]))]
	[KnownType(typeof(int[][]))]
	[KnownType(typeof(uint[][]))]
	[KnownType(typeof(long[][]))]
	[KnownType(typeof(ulong[][]))]
	[KnownType(typeof(bool[][]))]
	[KnownType(typeof(string[][]))]
	[KnownType(typeof(object[][]))]
	[KnownType(typeof(System.DateTime[][]))]
	[KnownType(typeof(System.TimeSpan[][]))]
	[KnownType(typeof(System.Decimal[][]))]
	// Xi types
	[KnownType(typeof(TypeId))]
	[KnownType(typeof(ServerStatus))]
	[KnownType(typeof(StringTableEntry))]
	[KnownType(typeof(StringTableEntry[]))]
	public class DataValueArrays
	{
		/// <summary>
		/// The array of status codes. Status code values are defined by 
		/// the XiStatusCode class.
		/// </summary>
		[DataMember] public uint[] DoubleStatusCodes;

		/// <summary>
		/// The array of timestamps.  All timestamps are UTC.
		/// </summary>
		[DataMember] public DateTime[] DoubleTimeStamps;

		/// <summary>
		/// The array of values. 
		/// Used to transfer single and double floating point values.
		/// </summary>
		[DataMember] public double[] DoubleValues;

		/// <summary>
		/// The array of status codes. Status code values are defined by 
		/// the XiStatusCode class.
		/// </summary>
		[DataMember] public uint[] UintStatusCodes;

		/// <summary>
		/// The array of timestamps.  All timestamps are UTC.
		/// </summary>
		[DataMember] public DateTime[] UintTimeStamps;

		/// <summary>
		/// The array of integer values.
		/// Used to transfer byte, sbyte, short, ushort, int and uint values.
		/// </summary>
		[DataMember] public uint[] UintValues;

		/// <summary>
		/// The array of status codes. Status code values are defined by 
		/// the XiStatusCode class.
		/// </summary>
		[DataMember] public uint[] ObjectStatusCodes;

		/// <summary>
		/// The array of timestamps.  All timestamps are UTC.
		/// </summary>
		[DataMember] public DateTime[] ObjectTimeStamps;

		/// <summary>
		/// The array of values.
		/// Used to transfer type that do not conform to the integer or float values.
		/// </summary>
		[DataMember] public object[] ObjectValues;

		/// <summary>
		/// <para>The error message to be returned when the Context has been 
		/// opened with ContextOptions set to DebugErrorMessages. This list is 
		/// always null if the Context was not opened with ContextOptions set 
		/// to DebugErrorMessages.</para>
		/// <para>When ContextOptions is set to DebugErrorMessages, the server 
		/// can provide an error message that provides additional information about 
		/// bad values.  If additional error information is not provided for any 
		/// values, then the list is set to null.</para>
		/// </summary>
		[DataMember] public List<ErrorInfo> ErrorInfo;

		/// <summary>
		/// This constructor creates a DataValuesArrays object with arrays of the 
		/// specified sizes.  All entries in each array are set to their initial 
		/// values.
		/// </summary>
		/// <param name="doubleArraySize">
		/// The size of the arrays associated with double values.
		/// </param>
		/// <param name="uintArraySize">
		/// The size of the arrays associated with long values.
		/// </param>
		/// <param name="objectArraySize">
		/// The size of the arrays associated with object values.
		/// </param>
		public DataValueArrays(int doubleArraySize, int uintArraySize, int objectArraySize)
		{
			if (0 == doubleArraySize)
			{
				DoubleStatusCodes = null;
				DoubleTimeStamps = null;
				DoubleValues = null;
			}
			else
			{
				DoubleStatusCodes = new uint[doubleArraySize];
				DoubleTimeStamps = new DateTime[doubleArraySize];
				DoubleValues = new double[doubleArraySize];
			}
			if (0 == uintArraySize)
			{
				UintStatusCodes = null;
				UintTimeStamps = null;
				UintValues = null;
			}
			else
			{
				UintStatusCodes = new uint[uintArraySize];
				UintTimeStamps = new DateTime[uintArraySize];
				UintValues = new uint[uintArraySize];
			}
			if (0 == objectArraySize)
			{
				ObjectStatusCodes = null;
				ObjectTimeStamps = null;
				ObjectValues = null;
			}
			else
			{
				ObjectStatusCodes = new uint[objectArraySize];
				ObjectTimeStamps = new DateTime[objectArraySize];
				ObjectValues = new object[objectArraySize];
			}
			ErrorInfo = null;
		}

		/// <summary>
		/// This constructor creates a DataValuesArrays object from existing arrays 
		/// passed in as parameters.
		/// </summary>
		/// <param name="doubleStatusCodes">
		/// The status code array for double values.
		/// </param>
		/// <param name="doubleTimeStamps">
		/// The timestamp array for double values.
		/// </param>
		/// <param name="doubleValues">
		/// The array of double values.
		/// </param>
		/// <param name="uintStatusCodes">
		/// The status code array for long values.
		/// </param>
		/// <param name="uintTimeStamps">
		/// The timestamp array for long values.
		/// </param>
		/// <param name="uintValues">
		/// The array of uint values.
		/// </param>
		/// <param name="objectStatusCodes">
		/// The status code array for object values.
		/// </param>
		/// <param name="objectTimeStamps">
		/// The timestamp array for object values.
		/// </param>
		/// <param name="objectValues">
		/// The array of object values.
		/// </param>
		public DataValueArrays(
			ref uint[] doubleStatusCodes, ref DateTime[] doubleTimeStamps, ref double[] doubleValues,
			ref uint[] uintStatusCodes, ref DateTime[] uintTimeStamps, ref uint[] uintValues,
			ref uint[] objectStatusCodes, ref DateTime[] objectTimeStamps, ref object[] objectValues)
		{
			DoubleStatusCodes = doubleStatusCodes;
			DoubleTimeStamps = doubleTimeStamps;
			DoubleValues = doubleValues;
			UintStatusCodes = uintStatusCodes;
			UintTimeStamps = uintTimeStamps;
			UintValues = uintValues;
			ObjectStatusCodes = objectStatusCodes;
			ObjectTimeStamps = objectTimeStamps;
			ObjectValues = objectValues;
			ErrorInfo = null;
		}

		/// <summary>
		/// This method clears the DataValuesArrays object by setting each 
		/// of its arrays and its ErrorInfo list to null.
		/// </summary>
		public void Clear()
		{
			DoubleStatusCodes = null;
			DoubleTimeStamps = null;
			DoubleValues = null;
			UintStatusCodes = null;
			UintTimeStamps = null;
			UintValues = null;
			ObjectStatusCodes = null;
			ObjectTimeStamps = null;
			if (null != ObjectValues)
				Array.Clear(ObjectValues, 0, ObjectValues.Length);
			ObjectValues = null;
			if (null != ErrorInfo)
				ErrorInfo.Clear();
			ErrorInfo = null;
		}

		/// <summary>
		/// This method sets a double value, its status code, and its timestamp 
		/// for a given index in the DataValuesArrays object.
		/// </summary>
		/// <param name="idx">
		/// The index of the double value, status code, and timestamp in each of 
		/// the corresponding arrays.
		/// </param>
		/// <param name="statusCode">
		/// The status code of the value.
		/// </param>
		/// <param name="timeStamp">
		/// The timestamp of the value.</param>
		/// <param name="value">
		/// The double value.
		/// </param>
		public void SetDouble(int idx, uint statusCode, DateTime timeStamp, double value)
		{
			DoubleStatusCodes[idx] = statusCode;
			DoubleTimeStamps[idx] = timeStamp;
			DoubleValues[idx] = value;
		}

		/// <summary>
		/// This method sets a long value, its status code, and its timestamp 
		/// for a given index in the DataValuesArrays object.
		/// </summary>
		/// <param name="idx">
		/// The index of the long value, status code, and timestamp in each of 
		/// the corresponding arrays.
		/// </param>
		/// <param name="statusCode">
		/// The status code of the value.
		/// </param>
		/// <param name="timeStamp">
		/// The timestamp of the value.
		/// </param>
		/// <param name="value">
		/// The long value.
		/// </param>
		public void SetUint(int idx, uint statusCode, DateTime timeStamp, uint value)
		{
			UintStatusCodes[idx] = statusCode;
			UintTimeStamps[idx] = timeStamp;
			UintValues[idx] = value;
		}

		/// <summary>
		/// This method sets an object value, its status code, and its timestamp 
		/// for a given index in the DataValuesArrays object.
		/// </summary>
		/// <param name="idx">
		/// The index of the object value, status code, and timestamp in each of 
		/// the corresponding arrays.
		/// </param>
		/// <param name="statusCode">
		/// The status code of the value.
		/// </param>
		/// <param name="timeStamp">
		/// The timestamp of the value.
		/// </param>
		/// <param name="value">
		/// The object value.
		/// </param>
		public void SetObject(int idx, uint statusCode, DateTime timeStamp, object value)
		{
			ObjectStatusCodes[idx] = statusCode;
			ObjectTimeStamps[idx] = timeStamp;
			ObjectValues[idx] = value;
		}

		/// <summary>
		/// This method sets the arrays used to convey double values.
		/// </summary>
		/// <param name="statusCodeArray">
		/// The status code array.
		/// </param>
		/// <param name="timeStampArray">
		/// The timestamp array.
		/// </param>
		/// <param name="valueArray">
		/// The value array.
		/// </param>
		/// <returns>
		/// True if the array could be set.
		/// </returns>
		public bool CreateDoubleArrays(uint[] statusCodeArray,
			DateTime[] timeStampArray, double[] valueArray)
		{
			if (   (statusCodeArray == null)
				&& (timeStampArray == null)
				&& (valueArray == null)
			   )
			{
				DoubleStatusCodes = null;
				DoubleTimeStamps = null;
				DoubleValues = null;
				return true;
			}
			else if (   (statusCodeArray.Length == timeStampArray.Length)
					 && (statusCodeArray.Length == valueArray.Length)
					)
			{
				DoubleStatusCodes = statusCodeArray;
				DoubleTimeStamps = timeStampArray;
				DoubleValues = valueArray;
				return true;
			}
			return false;
		}

		/// <summary>
		/// This method sets the arrays used to convey integer values.
		/// </summary>
		/// <param name="statusCodeArray">
		/// The status code array.
		/// </param>
		/// <param name="timeStampArray">
		/// The timestamp array.
		/// </param>
		/// <param name="valueArray">
		/// The value array.
		/// </param>
		/// <returns>
		/// True if the array could be set.
		/// </returns>
		public bool CreateUintArrays(uint[] statusCodeArray,
			DateTime[] timeStampArray, uint[] valueArray)
		{
			if (   (statusCodeArray == null)
				&& (timeStampArray == null)
				&& (valueArray == null)
			   )
			{
				UintStatusCodes = null;
				UintTimeStamps = null;
				UintValues = null;
				return true;
			}
			else if (   (statusCodeArray.Length == timeStampArray.Length)
					 && (statusCodeArray.Length == valueArray.Length)
					)
			{
				UintStatusCodes = statusCodeArray;
				UintTimeStamps = timeStampArray;
				UintValues = valueArray;
				return true;
			}
			return false;
		}

		/// <summary>
		/// This method sets the arrays used to convey object values.
		/// </summary>
		/// <param name="statusCodeArray">
		/// The status code array.
		/// </param>
		/// <param name="timeStampArray">
		/// The timestamp array.
		/// </param>
		/// <param name="valueArray">
		/// The value array.
		/// </param>
		/// <returns>
		/// True if the array could be set.
		/// </returns>
		public bool CreateObjectArrays(uint[] statusCodeArray,
			DateTime[] timeStampArray, object[] valueArray)
		{
			if (   (statusCodeArray == null)
				&& (timeStampArray == null)
				&& (valueArray == null)
			   )
			{
				ObjectStatusCodes = null;
				ObjectTimeStamps = null;
				ObjectValues = null;
				return true;
			}
			else if (   (statusCodeArray.Length == timeStampArray.Length)
					 && (statusCodeArray.Length == valueArray.Length)
					)
			{
				ObjectStatusCodes = statusCodeArray;
				ObjectTimeStamps = timeStampArray;
				ObjectValues = valueArray;
				return true;
			}
			return false;
		}
	}
}