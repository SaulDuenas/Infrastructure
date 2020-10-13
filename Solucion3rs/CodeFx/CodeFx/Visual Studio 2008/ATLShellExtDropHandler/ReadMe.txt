=============================================================================
    ACTIVE TEMPLATE LIBRARY : ATLShellExtDropHandler Project Overview
=============================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

- To be finished


/////////////////////////////////////////////////////////////////////////////
Build:

To build ATLShellExtDropHandler, please run Visual Studio as administrator 
because the component needs to be registered into HKCR.


/////////////////////////////////////////////////////////////////////////////
Deployment:

A. Setup

Regsvr32.exe ATLShellExtDropHandler.dll

B. Cleanup

Regsvr32.exe /u ATLShellExtDropHandler.dll


/////////////////////////////////////////////////////////////////////////////
Creation:

A. Creating the project

Step1. Create a Visual C++ / ATL / ATL Project named ATLShellExtDropHandler 
in Visual Studio 2008.

Step2. In the page "Application Settings" of ATL Project Wizard, select the 
server type as Dynamic-link library (DLL). Do not allow merging of proxy/stub 
code. After the creation of the project, remove the proxy project because the 
proxy will never be needed for any extension dlls.

Step3. After the project is created, delete the file 
ATLShellExtDropHandler.rgs from the project. ATLShellExtDropHandler.rgs is 
used to set the AppID of the COM component, which is not necessary for shell 
extension. Remove the following line from dllmain.h.

	DECLARE_REGISTRY_APPID_RESOURCEID(IDR_ATLSHELLEXTDROPHANDLER, 
		"{65C21411-FC47-4256-818B-8D7BD3677C7A}")

Last, open Resource View of the project, and delete the registry resource 
IDR_ATLSHELLEXTDROPHANDLER.

Step4. Include the following header files in stdafx.h:

	#include <comdef.h>
	#include <shlobj.h>

Link shlwapi.lib and comctl32.lib in the project (Project properties / Linker 
/ Input / Additional Dependencies.

-----------------------------------------------------------------------------

B. Creating Drop Extension Handler for Files

Step1. In Solution Explorer, add a new ATL / ATL Simple Object class to the 
project.

Step2. In ATL Simple Object Wizard, specify the short name as FileDropExt, 
and select the threading model as Apartment (corresponding to STA). Because 
the extension will only be used by Explorer, so we can change some settings 
to remove the Automation features: change the Interface type to Custom, and 
change the Aggregation setting to No. When you click OK, the wizard creates 
a class called CFileDropExt that contains the basic code for implementing a 
COM object, and adds this class to the project.

Step3. Remove the implementation of IFileDropExt from CFileDropExt since we 
are not implementing our own interface.

	class ATL_NO_VTABLE CFileDropExt :
		public CComObjectRootEx<CComSingleThreadModel>,
		public CComCoClass<CFileDropExt, &CLSID_FileDropExt>,
		public IFileDropExt					// Remove this line

	BEGIN_COM_MAP(CFileDropExt)
		COM_INTERFACE_ENTRY(IFileDropExt)	// Remove this line
	END_COM_MAP()

Some registry setting of the component can also be removed safely from 
FileDropExt.rgs.

	HKCR
	{
r		ATLShellExtDropHandler.FileDropExt.1 = s 'FileDropExt Class'
r		{
r			CLSID = s '{34F7A878-1529-416A-99DF-F9690A3D0DE6}'
r		}
r		ATLShellExtDropHandler.FileDropExt = s 'FileDropExt Class'
r		{
r			CLSID = s '{34F7A878-1529-416A-99DF-F9690A3D0DE6}'
r			CurVer = s 'ATLShellExtDropHandler.FileDropExt.1'
r		}
		NoRemove CLSID
		{
			ForceRemove {34F7A878-1529-416A-99DF-F9690A3D0DE6} = 
				s 'FileDropExt Class'
			{
r				ProgID = s 'ATLShellExtDropHandler.FileDropExt.1'
r				VersionIndependentProgID = 
r					s 'ATLShellExtDropHandler.FileDropExt'
				InprocServer32 = s '%MODULE%'
				{
					val ThreadingModel = s 'Apartment'
				}
r				'TypeLib' = s '{1151416F-672C-42C8-9694-61610B9F5567}'
			}
		}
	}

Step4. Register the drop handler. First, in the file FileDropExt.rgs add the 
following content under HKCR to tell ATL what registry entries to add when 
the server is registered, and which ones to delete when the server is 
unregistered.

	.fdh = s 'FileDropExt'
	ForceRemove FileDropExt = s 'ATLShellExtDropHandler - FileDropExt'
	{
		DefaultIcon = s '%MODULE%,0'
		shellex
		{
			DropHandler = s '{34F7A878-1529-416A-99DF-F9690A3D0DE6}'
		}
	}

The line .fdh = s 'FileDropExt' makes the association between the new .fdh  
file extension and HKCR\FileDropExt registry key (It's just like the 
association between .txt and txtfile). The "ATLShellExtDropHandler - 
FileDropExt" string is the file type description that appears in Explorer. 
The DefaultIcon key lists the location of the icon to use for .fdh files.
Finally, we add the shellex key with the DropHandler subkey. Because there 
can be only one drop handler for a file type, the handler's GUID is stored 
right in the DropHandler key, instead of being listed in a subkey under 
DropHandler.

Step5. Add the implementation of IPersistFile and IDropTarget to CFileDropExt.

	class ATL_NO_VTABLE CFileDropExt :
		public CComObjectRootEx<CComSingleThreadModel>,
		public CComCoClass<CFileDropExt, &CLSID_FileDropExt>,
		public IPersistFile,
		public IDropTarget
	
	BEGIN_COM_MAP(CFileDropExt)
		COM_INTERFACE_ENTRY(IPersistFile)
		COM_INTERFACE_ENTRY(IDropTarget)
	END_COM_MAP()


/////////////////////////////////////////////////////////////////////////////
References:

MSDN: Initializing Shell Extensions
http://msdn.microsoft.com/en-us/library/cc144105.aspx

MSDN: Creating Drop Handlers
http://msdn.microsoft.com/en-us/library/bb776846.aspx

The Complete Idiot's Guide to Writing Shell Extensions - Part VI
http://www.codeproject.com/KB/shell/shellextguide6.aspx


/////////////////////////////////////////////////////////////////////////////