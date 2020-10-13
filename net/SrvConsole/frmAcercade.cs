using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

/***************************************************************************
 *    Proyecto: LPSConsola.                                              *
 *  Formulario: frmAcercade.                                               *
 * Descripci�n: Ventana que presenta las caracteristicas generales del     *
 *              Sistema.                                                   *
 *       Autor: TSR-IHS.                                                   *
 *       Fecha: 18/Oct/2007.                                               *
 *     Versi�n: 1.0.0                                                      *
 ***************************************************************************/

namespace SrvControlPanel
{
    /*Metodos del Objeto Formulario.*/

    //<P�blicos>
    //----------------------------------------------------------------------------
    //    Nombre: frmAcercade.
    // Categor�a: Constructor (Sin par�metros).
    //  Objetivo: Inicializar los Objetos del Formulario.
    //     Autor: TSR-IHS.
    //     Fecha: 18/Oct/2007.
    //----------------------------------------------------------------------------
    public partial class frmAcercade : Form
    {
        public frmAcercade()
        {
            InitializeComponent();
        }

        //----------------------------------------------------------------------------
        //    Nombre: Inicia.
        //  Objetivo: Inicializar la ventana con par�metros y visualizarla.
        // Categor�a: Procedimiento de usuario.
        //     Autor: TSR-IHS.
        //     Fecha: 18/Oct/2007.
        //----------------------------------------------------------------------------
        public void Inicia()
        {
            //Establecer versi�n
            lblVersion.Text = lblVersion.Text + " " + Application.ProductVersion;

            //Mostrar Ventana.
            this.ShowDialog();
        }

        //----------------------------------------------------------------------------
        //    Nombre: cmdAceptar (Bot�n de Comandos). 
        // Categor�a: Procedimiento de disparo por Objeto.
        //    Evento: Click 
        //  Objetivo: Cerrar la ventana Acerca de ...
        //     Autor: TSR-IHS.
        //     Fecha: 18/Oct/2007.
        //----------------------------------------------------------------------------
        private void cmdAceptar_Click(object sender, EventArgs e)
        {
            this.Hide();
            this.Close();
            this.Dispose();
        }

    }
}