using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

/***************************************************************************
 *    Proyecto: LPSConsolaSrv.                                             *
 *  Formulario: frmSplash.                                                 *
 * Descripci�n: Ventana de Presentaci�n de la aplicaci�n de Cat�logos del  *
 *              sistema Line Performance Solution.                         *
 *       Autor: TSR-IHS.                                                   *
 *       Fecha: 21/Nov/2007.                                               *
 *     Versi�n: 1.0.0                                                      *
 ***************************************************************************/
namespace SrvControlPanel
{
    public partial class frmSplash : Form
    {
        //----------------------------------------------------------------------------
        //    Nombre: frmSplash.
        // Categor�a: Constructor (Sin par�metros).
        //  Objetivo: Inicializar los Objetos del Formulario.
        //     Autor: TSR-IHS.
        //     Fecha: 21/Nov/2007.
        //----------------------------------------------------------------------------
        public frmSplash()
        {
            //[1]Inicializar ventana.
            InitializeComponent();

            //[2]Establecer versi�n del sistema.
            lblVersion.Text = "Versi�n: " + Application.ProductVersion;
        }
    }
}