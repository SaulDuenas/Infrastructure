/****************************** Module Header ******************************\
* Module Name:    TPTClass.cs
* Project:        CSEFEntityDataModel
* Copyright (c) Microsoft Corporation.
*
* This example demonstrates how to establish table per type inheritance.
* The difference is that all of the entities are sourced from a single table, 
* with the discriminator column being used as the differentiator. Then it 
* shows how to query all the students in the context.
*  
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
*
* History:
* * 10/27/2009 09:00 PM Yichun Feng Created
* * 10/28/2009 09:00 PM Lingzhi Sun Reviewed
\***************************************************************************/

#region Using directives
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
#endregion

namespace CSEFEntityDataModel.TablePerType
{
    public static class TPTClass
    {
        // Test the query method in TPTClass
        public static void TPTTest()
        {
            Query();
        }

        // Query all the Students in the context
        public static void Query()
        {
            using (EFTPTEntities context = new EFTPTEntities())
            {
                var people = from p in context.People.OfType<Student>()
                             select p;
                
                foreach (var s in people)
                {
                    Console.WriteLine("{0} {1} Degree: {2}",
                        s.LastName,
                        s.FirstName,
                        s.Degree);
                }
            }
        }
    }
}
