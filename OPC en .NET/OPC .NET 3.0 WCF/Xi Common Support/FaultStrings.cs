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
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Xml.Linq;

namespace Xi.Common.Support
{
	/// <summary>
	/// This class is used to lookup error codes
	/// </summary>
	public class FaultStrings
	{
		protected readonly Dictionary<uint, string> _errorCodesToStringDictionary;
		private static FaultStrings _instance;

		/// <summary>
		/// Internal constructor which creates the default set if the server does not supply them
		/// </summary>
		protected FaultStrings()
		{
			Debug.Assert(null == _instance);
			_errorCodesToStringDictionary = new Dictionary<uint, string>();

			_instance = this;
			StreamReader sr = null;
			Stream stm = null;
			try
			{
				using (stm = Assembly.GetAssembly(typeof(FaultStrings))
					.GetManifestResourceStream("Xi.Common.Support.ErrorCodes.xml"))
				{
					using (sr = new StreamReader(stm))
					{
						this.LoadDictionary(sr);
					}
					sr = null;
				}
				stm = null;

				using (stm = Assembly.GetAssembly(typeof(FaultStrings))
					.GetManifestResourceStream("Xi.Common.Support.ErrorCodesOpc.xml"))
				{
					using (sr = new StreamReader(stm))
					{
						this.LoadDictionary(sr);
					}
					sr = null;
				}
				stm = null;
			}
			finally
			{
				if (stm != null)
					stm.Dispose();
				if (sr != null)
					sr.Dispose();
			}
		}

		private void LoadDictionary(StreamReader sr)
		{
			string id;
			string text;
			try
			{
				XElement root = XElement.Parse(sr.ReadToEnd());
				foreach (var err in root.Elements("error"))
				{
					id = err.Attribute("id").Value;
					text = err.Attribute("text").Value;
					_errorCodesToStringDictionary.Add(
						ParseErrorNumber(err.Attribute("id").Value),
						err.Attribute("text").Value);
				}
			}
			catch (Exception ex)
			{
				string msg = ex.Message;
				Debug.Assert(null == ex);
			}
		}

		/// <summary>
		/// Parses out error codes and allows for both integer and hexidecimal varieties.
		/// </summary>
		/// <param name="value"></param>
		/// <returns></returns>
		private static uint ParseErrorNumber(string value)
		{
			if (value != null)
			{
				string val = value.Trim();
				bool isHex = false;
				if (val.StartsWith("0x", StringComparison.InvariantCultureIgnoreCase))
				{
					isHex = true;
					val = val.Substring(2);
				}
				if (!isHex && val.IndexOfAny("ABCDEFabcdef".ToCharArray()) >= 0)
					isHex = true;

				uint uiValue;
				if (uint.TryParse(val, ((isHex) ? NumberStyles.HexNumber : NumberStyles.Integer),
					CultureInfo.InvariantCulture, out uiValue))
					return uiValue;
			}
			throw new FormatException(
				string.Format("Improper Error Code Formatting [{0}]. Expected numeric or hex number.", value));
		}

		/// <summary>
		/// Retrieves the error text for a given error code.
		/// </summary>
		/// <param name="errorCode">Error Code</param>
		/// <returns>Text Message</returns>
		public static string Get(uint errorCode)
		{
			if (_instance == null)
				_instance = new FaultStrings();

			string msg;

			// First find out if this is a Xi Message defined in ErrorCodes.xml
			if (_instance._errorCodesToStringDictionary.TryGetValue(errorCode, out msg))
				return msg;

			// Second find out if this is a Win32 Error Code
			System.ComponentModel.Win32Exception winExcep =
				new System.ComponentModel.Win32Exception(unchecked((int)errorCode));
			msg = winExcep.Message;
			if (!string.IsNullOrEmpty(msg))
				return msg;

			return string.Format("Unknown Fault Code 0x{0:X}", errorCode);
		}
	}
}
