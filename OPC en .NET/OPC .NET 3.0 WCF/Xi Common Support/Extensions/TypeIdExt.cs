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

namespace Xi.Common.Support.Extensions
{
	public static class TypeIdExt
	{
		public static XiDataTypeHandle BasicDataValueType(this TypeId typeId)
		{
			if (null != typeId.Namespace) return XiDataTypeHandle.DataValueTypeIUnknown;
			if (null != typeId.SchemaType) return XiDataTypeHandle.DataValueTypeIUnknown;

			if (0 == string.Compare(typeof(Single).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeFloat32;
			if (0 == string.Compare(typeof(Int32).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeInt32;
			if (0 == string.Compare(typeof(String).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeString;

			if (0 == string.Compare(typeof(SByte).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeInt8;
			if (0 == string.Compare(typeof(Int16).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeInt16;
			if (0 == string.Compare(typeof(Int64).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeInt64;

			if (0 == string.Compare(typeof(Byte).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeUInt8;
			if (0 == string.Compare(typeof(UInt16).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeUInt16;
			if (0 == string.Compare(typeof(UInt32).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeUint32;
			if (0 == string.Compare(typeof(UInt64).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeUInt64;

			if (0 == string.Compare(typeof(Double).ToString(), typeId.LocalId, true))
				return XiDataTypeHandle.DataValueTypeFloat64;

			return XiDataTypeHandle.DataValueTypeIUnknown;
		}
	}
}
