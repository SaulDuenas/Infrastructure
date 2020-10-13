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

using Xi.Contracts.Data;

namespace Xi.Server.Base
{
	public class DataJournalListValueBase
		: ValueRoot
	{
		public DataJournalListValueBase(uint clientAlias, uint serverAlias)
			: base(clientAlias, serverAlias)
		{
		}

		public void UpdateDictionary(JournalDataValues dataValues)
		{
			JournalDataValues journalDataValues = null;
			if (_journalDataValues.TryGetValue(dataValues.Calculation, out journalDataValues))
			{
				_journalDataValues.Remove(dataValues.Calculation);
			}
			_journalDataValues.Add(dataValues.Calculation, dataValues);
		}

		protected Dictionary<TypeId, JournalDataValues> _journalDataValues =
			new Dictionary<TypeId, JournalDataValues>();
	}
}
