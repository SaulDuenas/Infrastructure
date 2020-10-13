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
 * Descripción: Ventana que presenta las caracteristicas generales del     *
 *              Sistema.                                                   *
 *       Autor: TSR-IHS.                                                   *
 *       Fecha: 18/Oct/2007.                                               *
 *     Versión: 1.0.0                                                      *
 ***************************************************************************/

namespace SrvControlPanel
{
    /*Metodos del Objeto Formulario.*/

    //<Públicos>
    //----------------------------------------------------------------------------
    //    Nombre: frmAcercade.
    // Categoría: Constructor (Sin parámetros).
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
        //  Objetivo: Inicializar la ventana con parámetros y visualizarla.
        // Categoría: Procedimiento de usuario.
        //     Autor: TSR-IHS.
        //     Fecha: 18/Oct/2007.
        //----------------------------------------------------------------------------
        public void Inicia()
        {
            //Establecer versión
            lblVersion.Text = lblVersion.Text + " " + Application.ProductVersion;

            //Mostrar Ventana.
            this.ShowDialog();
        }

        //----------------------------------------------------------------------------
        //    Nombre: cmdAceptar (Botón de Comandos). 
        // Categoría: Procedimiento de disparo por Objeto.
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