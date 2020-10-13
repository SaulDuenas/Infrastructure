using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace CSShellCommonFileDialog
{
    public partial class MainForm : Form
    {
        public MainForm()
        {
            InitializeComponent();
        }

        private void btnCFDInBCL_Click(object sender, EventArgs e)
        {
            // Demo Common File Dialogs through .NET BCL
            CFDInBCLForm bclForm = new CFDInBCLForm();
            bclForm.ShowDialog();
        }

        private void btnCFDInCodePack_Click(object sender, EventArgs e)
        {
            // Demo Common File Dialogs through Windows API Code Pack
            CFDInCodePackForm codePackForm = new CFDInCodePackForm();
            codePackForm.ShowDialog();
        }
    }
}
