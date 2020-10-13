Public Class WindowsService

    Protected Overrides Sub OnStart(ByVal args() As String)
        ' Add code here to start your service. This method should set things
        ' in motion so your service can do its work.

        EventLog1.WriteEntry("VBWindowsService in OnStart")

    End Sub

    Protected Overrides Sub OnStop()
        ' Add code here to perform any tear-down necessary to stop your service.

        EventLog1.WriteEntry("VBWindowsService in OnStop")

    End Sub

End Class
