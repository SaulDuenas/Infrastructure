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
 * Descripción: Ventana de Presentación de la aplicación de Catálogos del  *
 *              sistema Line Performance Solution.                         *
 *       Autor: TSR-IHS.                                                   *
 *       Fecha: 21/Nov/2007.                                               *
 *     Versión: 1.0.0                                                      *
 ***************************************************************************/
namespace SrvControlPanel
{
    public partial class frmSplash : Form
    {
        //----------------------------------------------------------------------------
        //    Nombre: frmSplash.
        // Categoría: Constructor (Sin parámetros).
        //  Objetivo: Inicializar los Objetos del Formulario.
        //     Autor: TSR-IHS.
        //     Fecha: 21/Nov/2007.
        //----------------------------------------------------------------------------
        public frmSplash()
        {
            //[1]Inicializar ventana.
            InitializeComponent();

            //[2]Establecer versión del sistema.
            lblVersion.Text = "Versión: " + Application.ProductVersion;
        }
    }
}