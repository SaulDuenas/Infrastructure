========================================================================
    CONSOLE APPLICATION : VBLinqToXml Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

This example illustrates how to use Linq to XML in VB.NET to create XML 
document from in-memory objects and SQL Server database. It also demonstrates 
how to write Linq to XML queries in VB.NET.  It uses Linq to SQL when querying 
data from SQL Server database. In this example, you will see VB.NET XML 
literals methods to create, query and edit XML document.


/////////////////////////////////////////////////////////////////////////////
Project Relation:

VBLinqToXml -> SQLServer2005DB
VBLinqToXml accesses the database created by SQLServer2005DB.


/////////////////////////////////////////////////////////////////////////////
Code Logic:

Query the in-memory object XML document

1. Create the in-memory objects based on the CodeFx examples information.
   (VB.NET 9.0 new features: object initializers)
   
2. Create the XML document based on the in-memory objects.
   (VB.NET XML literals)
   
3. Query the in-memory object XML document.
   (VB.NET XML literals)
   
Query the database XML document

1. Create the XML document based on the Person table in SQLServer2005DB 
   database in CodeFx.
   (VB.NET XML literals)
   
2. queries the database XML document.
   (VB.NET XML literals)
   
Note: To query the SQLServer2005DB data, we use Linq to SQL technology.
      For detail about Linq to SQL examples, please see the CSLinqToSQL
      project in CodeFx.
      
Edit an XML document in file system

1. Insert new XML elements to the XML document.
   (XElement.Add, VB.NET XML literals)
   
2. Modify the value of certain XML element
   (XElement.Value, VB.NET XML literals)
   
3. Delete certain XML element
   (XElement.Remove) 
   

/////////////////////////////////////////////////////////////////////////////
References:

Object Initializers: Named and Anonymous Types
http://msdn.microsoft.com/en-us/library/bb385125.aspx

Namespaces in Visual Basic (LINQ to XML)
http://msdn.microsoft.com/en-us/library/bb387016.aspx

Creating XML in Visual Basic
http://msdn.microsoft.com/en-us/library/bb384808.aspx

Embedded Expressions in XML
http://msdn.microsoft.com/en-us/library/bb384964.aspx


/////////////////////////////////////////////////////////////////////////////