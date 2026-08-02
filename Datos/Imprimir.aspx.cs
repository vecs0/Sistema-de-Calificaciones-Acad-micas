using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using BLL.DTO;

namespace Datos
{
    public partial class Imprimir : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var lista = Session["ListaPersonas"] as List<InfoDatosPersonales> ?? new List<InfoDatosPersonales>();

            litFecha.Text = "Generado el " + DateTime.Now.ToString("dd/MM/yyyy HH:mm");
            litCantidad.Text = lista.Count + (lista.Count == 1 ? " registro" : " registros");
            litTabla.Text = RenderTabla(lista);
        }

        private string RenderTabla(List<InfoDatosPersonales> lista)
        {
            if (lista.Count == 0)
                return "<p>No hay registros para mostrar.</p>";

            var html = new StringBuilder();
            html.Append("<table class=\"print-table\"><thead><tr>");
            html.Append("<th>Matrícula</th><th>Nombre</th><th>Materia</th><th>P1</th><th>P2</th><th>TP</th><th>Final</th><th>Total</th><th>Prom.</th><th>Situación</th>");
            html.Append("</tr></thead><tbody>");

            foreach (var p in lista)
            {
                html.Append("<tr>");
                html.AppendFormat("<td>{0}</td>", HttpUtility.HtmlEncode(p.Matricula));
                html.AppendFormat("<td>{0}</td>", HttpUtility.HtmlEncode(p.NombreCompleto));
                html.AppendFormat("<td>{0}</td>", HttpUtility.HtmlEncode(p.Materia));
                html.AppendFormat("<td>{0:0.0}</td>", p.Parcial1);
                html.AppendFormat("<td>{0:0.0}</td>", p.Parcial2);
                html.AppendFormat("<td>{0:0.0}</td>", p.TP);
                html.AppendFormat("<td>{0:0.0}</td>", p.ExamenFinal);
                html.AppendFormat("<td>{0:0.0}</td>", p.Total);
                html.AppendFormat("<td>{0:0.00}</td>", p.Promedio);
                html.AppendFormat("<td>{0}</td>", p.Situacion == "Aprobado" ? "Aprobado" : "Reprobado");
                html.Append("</tr>");
            }

            html.Append("</tbody></table>");
            return html.ToString();
        }
    }
}
