using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace CodeFX.CSVSPackageState
{
    public partial class MyControl : UserControl
    {
        public MyControl()
        {
            InitializeComponent();
        }

        public object Object
        {
            get
            {
                return this.propertyGrid.SelectedObject;
            }
            set
            {
                this.propertyGrid.SelectedObject = value;
            }
        }


    }
}
