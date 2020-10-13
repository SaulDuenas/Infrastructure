This readme file describes the changes to the files in Xi ServerBase

BaseClasses/XiDiscoveryServerResolver.cs
Fix problem of the failure to properly generate comments in the manual config file when first starting the DiscoveryServer 
and the manual config file does not exist

Context/ContextBase.cs
Change type of locks to nullable<long> instead of object. Object does not always yield a unique lock.
Correct spelling of Locale from Local in SetSupportedLocaleIds()

Lists and Data/ListRoot.cs
Change type of locks to nullable<long> instead of object. Object does not always yield a unique lock.

Service Contracts/InitializeServerData.cs
Correct spelling of Locale from Local in SetSupportedLocaleIds()
