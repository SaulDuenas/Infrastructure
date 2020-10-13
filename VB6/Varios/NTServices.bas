Attribute VB_Name = "NTServices"
' NTServices.bas - Teseracto (c) 2003
'      Ing. Alejandro Armida Moreno.
'      Ing. Miguel A. Torres-Orozco Bermeo.
' Rutinas para Controlar Servicios de NT
Option Explicit

'API Constants
Const SERVICES_ACTIVE_DATABASE = "ServicesActive"
' Service Control
Const SERVICE_CONTROL_STOP = &H1
Const SERVICE_CONTROL_PAUSE = &H2
' Service State - for CurrentState
Const SERVICE_STOPPED = &H1
Const SERVICE_START_PENDING = &H2
Const SERVICE_STOP_PENDING = &H3
Const SERVICE_RUNNING = &H4
Const SERVICE_CONTINUE_PENDING = &H5
Const SERVICE_PAUSE_PENDING = &H6
Const SERVICE_PAUSED = &H7
'Service Control Manager object specific access types
Const STANDARD_RIGHTS_REQUIRED = &HF0000
Const SC_MANAGER_CONNECT = &H1
Const SC_MANAGER_CREATE_SERVICE = &H2
Const SC_MANAGER_ENUMERATE_SERVICE = &H4
Const SC_MANAGER_LOCK = &H8
Const SC_MANAGER_QUERY_LOCK_STATUS = &H10
Const SC_MANAGER_MODIFY_BOOT_CONFIG = &H20
Const SC_MANAGER_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED _
 Or SC_MANAGER_CONNECT _
 Or SC_MANAGER_CREATE_SERVICE Or SC_MANAGER_ENUMERATE_SERVICE _
 Or SC_MANAGER_LOCK _
 Or SC_MANAGER_QUERY_LOCK_STATUS _
 Or SC_MANAGER_MODIFY_BOOT_CONFIG)
'Service object specific access types
Const SERVICE_QUERY_CONFIG = &H1
Const SERVICE_CHANGE_CONFIG = &H2
Const SERVICE_QUERY_STATUS = &H4
Const SERVICE_ENUMERATE_DEPENDENTS = &H8
Const SERVICE_START = &H10
Const SERVICE_STOP = &H20
Const SERVICE_PAUSE_CONTINUE = &H40
Const SERVICE_INTERROGATE = &H80
Const SERVICE_USER_DEFINED_CONTROL = &H100
Const SERVICE_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED _
Or SERVICE_QUERY_CONFIG _
 Or SERVICE_CHANGE_CONFIG _
 Or SERVICE_QUERY_STATUS _
 Or SERVICE_ENUMERATE_DEPENDENTS _
 Or SERVICE_START _
 Or SERVICE_STOP _
 Or SERVICE_PAUSE_CONTINUE _
 Or SERVICE_INTERROGATE _
 Or SERVICE_USER_DEFINED_CONTROL)

Type SERVICE_STATUS
   dwServiceType As Long
   dwCurrentState As Long
   dwControlsAccepted As Long
   dwWin32ExitCode As Long
   dwServiceSpecificExitCode As Long
   dwCheckPoint As Long
   dwWaitHint As Long
End Type

Private Declare Function CloseServiceHandle Lib "advapi32.dll" (ByVal hSCObject As Long) As Long
Private Declare Function ControlService Lib "advapi32.dll" (ByVal hService As Long, ByVal dwControl As Long, lpServiceStatus As SERVICE_STATUS) As Long
Private Declare Function OpenSCManager Lib "advapi32.dll" Alias "OpenSCManagerA" (ByVal lpMachineName As String, ByVal lpDatabaseName As String, ByVal dwDesiredAccess As Long) As Long
Private Declare Function OpenService Lib "advapi32.dll" Alias "OpenServiceA" (ByVal hSCManager As Long, ByVal lpServiceName As String, ByVal dwDesiredAccess As Long) As Long
Private Declare Function QueryServiceStatus Lib "advapi32.dll" (ByVal hService As Long, lpServiceStatus As SERVICE_STATUS) As Long
Private Declare Function StartService Lib "advapi32.dll" Alias "StartServiceA" (ByVal hService As Long, ByVal dwNumServiceArgs As Long, ByVal lpServiceArgVectors As Long) As Long

'Devuelve el Estatus de un servicio NT
Public Function ServiceStatus(ByVal ComputerName As String, ServiceName As String) As String
   Dim ServiceStat As SERVICE_STATUS
   Dim hSManager As Long
   Dim hService As Long
   Dim hServiceStatus As Long
   
   'Corrige el nombre de la computadora en caso de ser "(local)"
   If UCase(ComputerName) = "(LOCAL)" Then ComputerName = ""

   ServiceStatus = ""
   hSManager = OpenSCManager(ComputerName, SERVICES_ACTIVE_DATABASE, SC_MANAGER_ALL_ACCESS)
   If hSManager <> 0 Then
       hService = OpenService(hSManager, ServiceName, SERVICE_ALL_ACCESS)
       If hService <> 0 Then
           hServiceStatus = QueryServiceStatus(hService, ServiceStat)
           If hServiceStatus <> 0 Then
               Select Case ServiceStat.dwCurrentState
               Case SERVICE_STOPPED
                   ServiceStatus = "Stopped"
               Case SERVICE_START_PENDING
                   ServiceStatus = "Start Pending"
               Case SERVICE_STOP_PENDING
                   ServiceStatus = "Stop Pending"
               Case SERVICE_RUNNING
                   ServiceStatus = "Running"
               Case SERVICE_CONTINUE_PENDING
                   ServiceStatus = "Coninue Pending"
               Case SERVICE_PAUSE_PENDING
                   ServiceStatus = "Pause Pending"
               Case SERVICE_PAUSED
                   ServiceStatus = "Paused"
               End Select
           End If
           CloseServiceHandle hService
       End If
       CloseServiceHandle hSManager
   End If
End Function

Public Sub ServicePause(ByVal ComputerName As String, ServiceName As String)
   Dim ServiceStatus As SERVICE_STATUS
   Dim hSManager As Long
   Dim hService As Long
   Dim res As Long

   'Corrige el nombre de la computadora en caso de ser "(local)"
   If UCase(ComputerName) = "(LOCAL)" Then ComputerName = ""
   
   hSManager = OpenSCManager(ComputerName, SERVICES_ACTIVE_DATABASE, SC_MANAGER_ALL_ACCESS)
   If hSManager <> 0 Then
       hService = OpenService(hSManager, ServiceName, SERVICE_ALL_ACCESS)
       If hService <> 0 Then
           res = ControlService(hService, SERVICE_CONTROL_PAUSE, ServiceStatus)
           CloseServiceHandle hService
       End If
       CloseServiceHandle hSManager
   End If
End Sub

Public Sub ServiceStart(ByVal ComputerName As String, ServiceName As String)
   Dim ServiceStatus As SERVICE_STATUS
   Dim hSManager As Long
   Dim hService As Long
   Dim res As Long

   'Corrige el nombre de la computadora en caso de ser "(local)"
   If UCase(ComputerName) = "(LOCAL)" Then ComputerName = ""
   
   hSManager = OpenSCManager(ComputerName, SERVICES_ACTIVE_DATABASE, SC_MANAGER_ALL_ACCESS)
   If hSManager <> 0 Then
       hService = OpenService(hSManager, ServiceName, SERVICE_ALL_ACCESS)
       If hService <> 0 Then
           res = StartService(hService, 0, 0)
           CloseServiceHandle hService
       End If
       CloseServiceHandle hSManager
   End If
End Sub

Public Sub ServiceStop(ByVal ComputerName As String, ServiceName As String)
   Dim ServiceStatus As SERVICE_STATUS
   Dim hSManager As Long
   Dim hService As Long
   Dim res As Long

   'Corrige el nombre de la computadora en caso de ser "(local)"
   If UCase(ComputerName) = "(LOCAL)" Then ComputerName = ""
   
   hSManager = OpenSCManager(ComputerName, SERVICES_ACTIVE_DATABASE, SC_MANAGER_ALL_ACCESS)
   If hSManager <> 0 Then
       hService = OpenService(hSManager, ServiceName, SERVICE_ALL_ACCESS)
       If hService <> 0 Then
           res = ControlService(hService, SERVICE_CONTROL_STOP, ServiceStatus)
           CloseServiceHandle hService
       End If
       CloseServiceHandle hSManager
   End If
End Sub


