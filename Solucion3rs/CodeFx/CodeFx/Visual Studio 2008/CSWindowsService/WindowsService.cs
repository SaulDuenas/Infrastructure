using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;

namespace CSWindowsService
{
    public partial class WindowsService : ServiceBase
    {
        public WindowsService()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            eventLog1.WriteEntry("CSWindowsService in OnStart");
        }

        protected override void OnStop()
        {
            eventLog1.WriteEntry("CSWindowsService in OnStop");
        }
    }
}
