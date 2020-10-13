/************************************** Module Header **************************************\
* Module Name:	ProjectInstaller.h
* Project:		CppWin7TriggerStartService
* Copyright (c) Microsoft Corporation.
* 
* In ProjectInstaller, we configured the service to start when a generic USB disk becomes 
* available. It also shows how to trigger-start when the first IP address becomes available, 
* and trigger-stop when the last IP address becomes unavailable. 
* 
* This source is subject to the Microsoft Public License.
* See http://www.microsoft.com/opensource/licenses.mspx#Ms-PL.
* All other rights reserved.
* 
* History:
* * 8/29/2009 3:00 PM Jialiang Ge Created
\*******************************************************************************************/

#pragma once

#include <msclr\marshal.h>
#include <msclr\marshal_windows.h>

using namespace msclr::interop;
using namespace System;
using namespace System::ComponentModel;
using namespace System::Collections;
using namespace System::Configuration::Install;
using namespace System::Runtime::InteropServices;


namespace CppWin7TriggerStartService {

	[RunInstaller(true)]

	/// <summary>
	/// Summary for ProjectInstaller
	/// </summary>
	public ref class ProjectInstaller : public System::Configuration::Install::Installer
	{
	public:
		ProjectInstaller(void)
		{
			InitializeComponent();
			//
			//TODO: Add the constructor code here
			//
		}

	protected:
		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		~ProjectInstaller()
		{
			if (components)
			{
				delete components;
			}
		}
	private: System::ServiceProcess::ServiceProcessInstaller^  serviceProcessInstaller1;
	private: System::ServiceProcess::ServiceInstaller^  triggerStartServiceInstaller;
	protected: 


	private:
		/// <summary>
		/// Required designer variable.
		/// </summary>
		System::ComponentModel::Container ^components;

#pragma region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		void InitializeComponent(void)
		{
			this->serviceProcessInstaller1 = (gcnew System::ServiceProcess::ServiceProcessInstaller());
			this->triggerStartServiceInstaller = (gcnew System::ServiceProcess::ServiceInstaller());
			// 
			// serviceProcessInstaller1
			// 
			this->serviceProcessInstaller1->Account = System::ServiceProcess::ServiceAccount::LocalSystem;
			this->serviceProcessInstaller1->Password = nullptr;
			this->serviceProcessInstaller1->Username = nullptr;
			// 
			// triggerStartServiceInstaller
			// 
			this->triggerStartServiceInstaller->Description = L"All-In-One Code Framework (CodeFx) Trigger Start Service example";
			this->triggerStartServiceInstaller->ServiceName = L"CppWin7TriggerStartService";
			this->triggerStartServiceInstaller->AfterInstall += gcnew System::Configuration::Install::InstallEventHandler(this, &ProjectInstaller::triggerStartServiceInstaller_AfterInstall);
			// 
			// ProjectInstaller
			// 
			this->Installers->AddRange(gcnew cli::array< System::Configuration::Install::Installer^  >(2) {this->serviceProcessInstaller1, 
				this->triggerStartServiceInstaller});

		}
#pragma endregion

	private:

		System::Void triggerStartServiceInstaller_AfterInstall(System::Object^  sender, 
			System::Configuration::Install::InstallEventArgs^  e) 
		{
			// Service trigger events are not supported until Windows Server 2008 R2 and Windows 7.
            // Windows Server 2008 R2 and Windows 7 have major version 6 and minor version 1.
			if ((Environment::OSVersion->Version >= gcnew Version(6, 1)))
			{
				Console::WriteLine("Configuring trigger-start service...");

				// Set the service to trigger-start when a generic USB disk becomes available.
                //SetServiceTriggerStartOnUSBArrival(triggerStartServiceInstaller->ServiceName);

                // [-or-]

                // Set the service to trigger-start when the first IP address becomes available, 
                // and trigger-stop when the last IP address becomes unavailable.
                SetServiceTriggerStartOnIPAddressArrival(triggerStartServiceInstaller->ServiceName);
			}
			else
			{
				Console::WriteLine("The current system does not support trigger-start service.");
			}
		}


		/// <summary>
		/// Set the service to trigger-start when a generic USB disk becomes available.
		/// </summary>
		System::Void SetServiceTriggerStartOnUSBArrival(System::String^ serviceName)
		{
			SC_HANDLE hSCManager = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);
			if (hSCManager == NULL)
			{
				throw Marshal::GetExceptionForHR(GetLastError());
			}

			marshal_context context;

			// Open the service to be configured as trigger start on USB arrival
			SC_HANDLE hService = OpenService(hSCManager, 
				context.marshal_as<LPCWSTR>(serviceName), SERVICE_ALL_ACCESS);
			if (hService == NULL)
			{
				DWORD dwLastError = GetLastError();
				CloseServiceHandle(hSCManager);
				throw Marshal::GetExceptionForHR(dwLastError);
			}

			// Hardware ID generated by the USB storage port driver
			LPCWSTR lpszDeviceString = L"USBSTOR\\GenDisk";

			// Allocate and set the SERVICE_TRIGGER_SPECIFIC_DATA_ITEM structure
			SERVICE_TRIGGER_SPECIFIC_DATA_ITEM deviceData = {0};
			deviceData.dwDataType = SERVICE_TRIGGER_DATA_TYPE_STRING;
			deviceData.cbData = (DWORD)((wcslen(lpszDeviceString)+1) * sizeof(WCHAR));
			deviceData.pData = (PBYTE)lpszDeviceString;

			// The GUID_DEVINTERFACE_DISK device interface class is defined for hard disk 
			// storage devices.
			static const GUID GUID_DEVINTERFACE_DISK = {
				0x53f56307, 0xb6bf, 0x11d0, {0x94, 0xf2, 0x00, 0xa0, 0xc9, 0x1e, 0xfb, 0x8b }};

			// Allocate and set the SERVICE_TRIGGER structure
			SERVICE_TRIGGER serviceTrigger = {0};
			serviceTrigger.dwTriggerType = SERVICE_TRIGGER_TYPE_DEVICE_INTERFACE_ARRIVAL;
			serviceTrigger.dwAction = SERVICE_TRIGGER_ACTION_SERVICE_START;
			serviceTrigger.pTriggerSubtype = (GUID*)&GUID_DEVINTERFACE_DISK;
			serviceTrigger.cDataItems = 1;
			serviceTrigger.pDataItems = &deviceData;

			// Allocate and set the SERVICE_TRIGGER_INFO structure. 
			SERVICE_TRIGGER_INFO serviceTriggerInfo = {0};
			serviceTriggerInfo.cTriggers = 1;
			serviceTriggerInfo.pTriggers = &serviceTrigger;

			// Call ChangeServiceConfig2 with the SERVICE_CONFIG_TRIGGER_INFO level and pass to 
			// it the address of the SERVICE_TRIGGER_INFO structure.
			if (!ChangeServiceConfig2(hService, SERVICE_CONFIG_TRIGGER_INFO, &serviceTriggerInfo))
			{
				DWORD dwLastError = GetLastError();
				CloseServiceHandle(hService);
				CloseServiceHandle(hSCManager);
				throw Marshal::GetExceptionForHR(dwLastError);
			}

			CloseServiceHandle(hService);
			CloseServiceHandle(hSCManager);
		}


		/// <summary>
		/// Set the service to trigger-start when the first IP address on the TCP/IP 
        /// networking stack becomes available, and trigger-stop when the last IP address on 
        /// the TCP/IP networking stack becomes unavailable.
		/// </summary>
		System::Void SetServiceTriggerStartOnIPAddressArrival(System::String^ serviceName)
		{
			SC_HANDLE hSCManager = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);
			if (hSCManager == NULL)
			{
				throw Marshal::GetExceptionForHR(GetLastError());
			}

			marshal_context context;

			// Open the service to be configured as trigger start on IP address arrival
			SC_HANDLE hService = OpenService(hSCManager, 
				context.marshal_as<LPCWSTR>(serviceName), SERVICE_ALL_ACCESS);
			if (hService == NULL)
			{
				DWORD dwLastError = GetLastError();
				CloseServiceHandle(hSCManager);
				throw Marshal::GetExceptionForHR(dwLastError);
			}

			SERVICE_TRIGGER serviceTriggers[2] = {0};

			// Allocate and set the SERVICE_TRIGGER structure for 
			// NETWORK_MANAGER_FIRST_IP_ADDRESS_ARRIVAL_GUID to start the service
			serviceTriggers[0].dwTriggerType = SERVICE_TRIGGER_TYPE_IP_ADDRESS_AVAILABILITY;
			serviceTriggers[0].dwAction = SERVICE_TRIGGER_ACTION_SERVICE_START;
			serviceTriggers[0].pTriggerSubtype = (GUID*)
				&NETWORK_MANAGER_FIRST_IP_ADDRESS_ARRIVAL_GUID;

			// Allocate and set the SERVICE_TRIGGER structure for 
			// NETWORK_MANAGER_LAST_IP_ADDRESS_REMOVAL_GUID to stop the service
			serviceTriggers[1].dwTriggerType = SERVICE_TRIGGER_TYPE_IP_ADDRESS_AVAILABILITY;
			serviceTriggers[1].dwAction = SERVICE_TRIGGER_ACTION_SERVICE_STOP;
			serviceTriggers[1].pTriggerSubtype = (GUID*)
				&NETWORK_MANAGER_LAST_IP_ADDRESS_REMOVAL_GUID;

			// Allocate and set the SERVICE_TRIGGER_INFO structure
			SERVICE_TRIGGER_INFO serviceTriggerInfo = {0};
			serviceTriggerInfo.cTriggers = 2;
			serviceTriggerInfo.pTriggers = (PSERVICE_TRIGGER)&serviceTriggers;

			// Call ChangeServiceConfig2 with the SERVICE_CONFIG_TRIGGER_INFO level and pass to 
			// it the address of the SERVICE_TRIGGER_INFO structure.
			if (!ChangeServiceConfig2(hService, SERVICE_CONFIG_TRIGGER_INFO, &serviceTriggerInfo))
			{
				DWORD dwLastError = GetLastError();
				CloseServiceHandle(hService);
				CloseServiceHandle(hSCManager);
				throw Marshal::GetExceptionForHR(dwLastError);
			}
			
			CloseServiceHandle(hService);
			CloseServiceHandle(hSCManager);
		}
	};
}