========================================================================
    CONSOLE APPLICATION : CSLinqToXml Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

This example illustrates how to use Linq to XML in C# to create XML document
from in-memory objects and SQL Server database. It also demonstrates how to
write Linq to XML queries in C#.  It uses Linq to SQL when querying data 
from SQL Server database. In this example, you will see the basic Linq to
XML methods to create XML document and the axis methods to query and edit 
XML document. 


/////////////////////////////////////////////////////////////////////////////
Project Relation:

CSLinqToXml -> SQLServer2005DB
CSLinqToXml accesses the database created by SQLServer2005DB.


/////////////////////////////////////////////////////////////////////////////
Code Logic:

Query the in-memory object XML document

1. Create the in-memory objects based on the CodeFx examples information.
   (C# 3.0 new features: object initializers and collection initializers)
   
2. Create the XML document based on the in-memory objects.
   (XDocument, XElement, XDeclaration, XAttribute, XNamespace)
   
3. Query the in-memory object XML document.
   (XContainer.Descendants, XContainer.Elements, XElement.Element,
   XElement.Attribute)
   
Query the database XML document

1. Create the XML document based on the Person table in SQLServer2005DB 
   database in CodeFx.
   (XDocument, XElement, XDeclaration, XAttribute, XNamespace)
   
2. Queries the database XML document.
   (XContainer.Descendants, XElement.Element)
   
Note: To query the SQLServer2005DB data, we use Linq to SQL technology.
      For detail about Linq to SQL examples, please see the CSLinqToSQL
      project in CodeFx.
      
Edit an XML document in file system

1. Insert new XML elements to the XML document.
   {XElement.Add, XAttribute, XNamespace}
   
2. Modify the value of certain XML element
   (XElement.Value, XAttribute)
   
3. Delete certain XML element
   (XElement.Remove) 


/////////////////////////////////////////////////////////////////////////////
References:

Object and Collection Initializers (C# Programming Guide)
http://msdn.microsoft.com/en-us/library/bb384062.aspx

How to: Create a Document with Namespaces (C#) (LINQ to XML)
http://msdn.microsoft.com/en-us/library/bb387075.aspx

Scope of Default Namespaces in C# (LINQ to XML)
http://msdn.microsoft.com/en-us/library/bb943852.aspx

Namespaces in C# (LINQ to XML)
http://msdn.microsoft.com/en-us/library/bb387042.aspx


///////////////////////////////////////////////////////////////////////////////////




