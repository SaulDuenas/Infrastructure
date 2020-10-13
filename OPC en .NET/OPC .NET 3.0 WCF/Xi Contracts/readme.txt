This readme file describes the changes to the files in Xi Contracts.

Data/ModificationType.cs
Data/XiFault.cs
Correct DataContract Namespace attribute

IWrite.cs
Add [OperationContract, FaultContract(typeof(XiFault))] to WriteJournalEvents() 