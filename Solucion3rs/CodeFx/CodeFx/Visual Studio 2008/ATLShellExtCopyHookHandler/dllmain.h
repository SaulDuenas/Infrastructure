// dllmain.h : Declaration of module class.

class CATLShellExtCopyHookHandlerModule : public CAtlDllModuleT< CATLShellExtCopyHookHandlerModule >
{
public :
	DECLARE_LIBID(LIBID_ATLShellExtCopyHookHandlerLib)
	DECLARE_REGISTRY_APPID_RESOURCEID(IDR_ATLSHELLEXTCOPYHOOKHANDLER, "{4BA8E3C6-101B-4719-8C51-CABA54E9ADB9}")
};

extern class CATLShellExtCopyHookHandlerModule _AtlModule;
