using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;
using BLL.DTO;

namespace Datos
{
    public partial class Contact : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var lista = Session["ListaPersonas"] as List<InfoDatosPersonales>;
            string json = "[]";

            if (lista != null && lista.Any())
            {
                var datos = lista.Select(p => new
                {
                    matricula = p.Matricula,
                    nombre = p.Nombre,
                    materia = p.Materia,
                    p1 = (double)p.Parcial1,
                    p2 = (double)p.Parcial2,
                    tp = (double)p.TP,
                    final = (double)p.ExamenFinal,
                    total = (double)p.Total,
                    prom = (double)p.Promedio
                }).ToList();

                json = new JavaScriptSerializer().Serialize(datos);
            }

            ClientScript.RegisterClientScriptBlock(
                GetType(),
                "sessionData",
                "var SESSION_DATA = " + json + ";",
                true);
        }
    }
}
