using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL.DTO;
using BLL.Fachada;
using BLL.Procesos;
using ClosedXML.Excel;
using Newtonsoft.Json;

#pragma warning disable IDE1006

namespace Datos
{
    public partial class Tect : System.Web.UI.Page
    {
        private readonly PersonasService _personasService = new PersonasService();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!(Session["ListaPersonas"] is List<InfoDatosPersonales> existente) || existente.Count == 0)
                {
                    GuardarListViewState(new List<InfoDatosPersonales>());
                }
                else
                {
                    ViewState["list"] = existente;
                    ProcesarYActualizarGrid();
                    ActualizarEstadisticas();
                }
                HfMatriculaEdicion.Value = string.Empty;
                ActualizarContadorLog();
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            litAuditEntries.Text = RenderAuditEntries();
            ActualizarContadorLog();
        }

        protected void btn_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(HfMatriculaEdicion.Value))
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Guarda o cancela la edicion actual antes de agregar un nuevo registro.");
                    return;
                }

                InfoDatosPersonales info = CrearPersonaDesdeFormulario();

                if (!_personasService.ValidarPersona(info))
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Todos los campos son obligatorios y las calificaciones deben estar en rango (P1/P2: 0-20, TP: 0-10, Final: 0-50).");
                    return;
                }

                var lista = ObtenerListViewState();
                if (lista.Any(p => p.Matricula.Equals(info.Matricula, StringComparison.OrdinalIgnoreCase)
                                 && p.Materia.Equals(info.Materia, StringComparison.OrdinalIgnoreCase)))
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Ya existe un registro de la matricula '" + info.Matricula + "' para la materia '" + info.Materia + "'.");
                    return;
                }

                lista.Add(info);
                GuardarListViewState(lista);
                AuditLogger.RegistrarInsercion(Session, info);
                ActualizarContadorLog();
                ProcesarYActualizarGrid();
                ActualizarEstadisticas();
                LimpiarFormulario();
                btnMensaje.Text = HttpUtility.HtmlEncode("Registro de " + info.NombreCompleto + " agregado correctamente.");
            }
            catch (ArgumentException argEx)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode(argEx.Message);
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error: " + ex.Message);
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

        protected void GridDatos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                string argumento = e.CommandArgument?.ToString() ?? string.Empty;
                string[] partes = argumento.Split('|');
                string matricula = partes.Length > 0 ? partes[0] : string.Empty;
                string materia = partes.Length > 1 ? partes[1] : string.Empty;

                if (string.IsNullOrEmpty(matricula))
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Error: no se pudo identificar el registro.");
                    return;
                }

                var lista = ObtenerListViewState();

                if (e.CommandName == "perfil")
                {
                    var personaPerfil = lista.FirstOrDefault(p =>
                        p.Matricula.Equals(matricula, StringComparison.OrdinalIgnoreCase));

                    if (personaPerfil == null)
                    {
                        btnMensaje.Text = HttpUtility.HtmlEncode("Registro no encontrado.");
                        return;
                    }

                    MostrarPerfilAlumno(personaPerfil);
                    return;
                }

                var persona = lista.FirstOrDefault(p =>
                    p.Matricula.Equals(matricula, StringComparison.OrdinalIgnoreCase)
                    && p.Materia.Equals(materia, StringComparison.OrdinalIgnoreCase));

                if (persona == null)
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Registro no encontrado.");
                    return;
                }

                switch (e.CommandName)
                {
                    case "editar":
                        CargarRegistroParaEdicion(persona);
                        break;

                    case "anular":
                        EliminarRegistro(lista, matricula, materia);
                        break;

                    case "historial":
                        MostrarHistorialAlumno(persona);
                        break;
                }
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error: " + ex.Message);
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

        protected void btnGuardarEdicion_Click(object sender, EventArgs e)
        {
            try
            {
                string matricula = HfMatriculaEdicion.Value;
                string materiaOriginal = HfMateriaEdicion.Value;

                if (string.IsNullOrEmpty(matricula))
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Error: no hay una edicion activa.");
                    return;
                }

                var lista = ObtenerListViewState();
                int idx = lista.FindIndex(p =>
                    p.Matricula.Equals(matricula, StringComparison.OrdinalIgnoreCase)
                    && p.Materia.Equals(materiaOriginal, StringComparison.OrdinalIgnoreCase));

                if (idx < 0)
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Error: el registro a editar ya no existe.");
                    CancelarEdicion();
                    return;
                }

                // Capturar el estado anterior ANTES de modificar
                var personaAnterior = lista[idx];
                var snapshot = new InfoDatosPersonales
                {
                    Matricula = personaAnterior.Matricula,
                    Nombre = personaAnterior.Nombre,
                    Materia = personaAnterior.Materia,
                    Parcial1 = personaAnterior.Parcial1,
                    Parcial2 = personaAnterior.Parcial2,
                    TP = personaAnterior.TP,
                    ExamenFinal = personaAnterior.ExamenFinal
                };

                InfoDatosPersonales actualizado = CrearPersonaDesdeFormulario();
                actualizado.Matricula = matricula;

                if (!_personasService.ValidarPersona(actualizado))
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Todos los campos son obligatorios y las calificaciones deben estar en rango.");
                    return;
                }

                if (!actualizado.Materia.Equals(materiaOriginal, StringComparison.OrdinalIgnoreCase)
                    && lista.Where((p, i) => i != idx).Any(p =>
                        p.Matricula.Equals(matricula, StringComparison.OrdinalIgnoreCase)
                        && p.Materia.Equals(actualizado.Materia, StringComparison.OrdinalIgnoreCase)))
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Ya existe un registro de la matricula '" + matricula + "' para la materia '" + actualizado.Materia + "'.");
                    return;
                }

                lista[idx] = actualizado;
                GuardarListViewState(lista);
                AuditLogger.RegistrarActualizacion(Session, snapshot, actualizado);
                ActualizarContadorLog();
                ProcesarYActualizarGrid();
                ActualizarEstadisticas();
                CancelarEdicion();
                btnMensaje.Text = HttpUtility.HtmlEncode("Registro de " + actualizado.NombreCompleto + " actualizado correctamente.");
            }
            catch (ArgumentException argEx)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode(argEx.Message);
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al guardar: " + ex.Message);
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

        protected void btnCancelarEdicion_Click(object sender, EventArgs e)
        {
            CancelarEdicion();
            btnMensaje.Text = HttpUtility.HtmlEncode("Edicion cancelada.");
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            AplicarFiltroYOrden();
        }

        protected void DdlFiltroMateria_SelectedIndexChanged(object sender, EventArgs e)
        {
            AplicarFiltroYOrden();
        }

        protected void DdlOrden_SelectedIndexChanged(object sender, EventArgs e)
        {
            AplicarFiltroYOrden();
        }

        protected void ChkAscendente_CheckedChanged(object sender, EventArgs e)
        {
            AplicarFiltroYOrden();
        }

        protected void TxtBusqueda_TextChanged(object sender, EventArgs e)
        {
            AplicarFiltroYOrden();
        }

        protected void btnLimpiarFiltro_Click(object sender, EventArgs e)
        {
            try
            {
                TxtBusqueda.Text = string.Empty;
                DdlFiltroMateria.SelectedIndex = 0;
                DdlOrden.SelectedIndex = 0;
                ChkAscendente.Checked = true;
                AplicarFiltroYOrden();
                ActualizarEstadisticas();
                btnMensaje.Text = HttpUtility.HtmlEncode("Filtros limpiados.");
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al limpiar filtros: " + ex.Message);
            }
        }

        protected void btnExportar_Click(object sender, EventArgs e)
        {
            try
            {
                using (var workbook = new XLWorkbook())
                {
                    var ws = workbook.Worksheets.Add("Datos");

                    // Encabezados
                    ws.Cell(1, 1).Value = "Matrícula";
                    ws.Cell(1, 2).Value = "Nombre";
                    ws.Cell(1, 3).Value = "Materia";
                    ws.Cell(1, 4).Value = "Parcial 1";
                    ws.Cell(1, 5).Value = "Parcial 2";
                    ws.Cell(1, 6).Value = "TP";
                    ws.Cell(1, 7).Value = "Examen Final";
                    ws.Cell(1, 8).Value = "Total";
                    ws.Cell(1, 9).Value = "Promedio";

                    // Estilo de encabezado
                    var headerRow = ws.Row(1);
                    headerRow.Style.Font.Bold = true;
                    headerRow.Style.Fill.BackgroundColor = XLColor.SteelBlue;
                    headerRow.Style.Font.FontColor = XLColor.White;

                    // Datos desde ViewState
                    var lista = ObtenerListViewState();
                    int fila = 2;

                    foreach (var persona in lista)
                    {
                        ws.Cell(fila, 1).Value = persona.Matricula;
                        ws.Cell(fila, 2).Value = persona.Nombre;
                        ws.Cell(fila, 3).Value = persona.Materia;
                        ws.Cell(fila, 4).Value = persona.Parcial1;
                        ws.Cell(fila, 5).Value = persona.Parcial2;
                        ws.Cell(fila, 6).Value = persona.TP;
                        ws.Cell(fila, 7).Value = persona.ExamenFinal;
                        ws.Cell(fila, 8).Value = persona.Total;
                        ws.Cell(fila, 9).Value = persona.Promedio;
                        fila++;
                    }

                    ws.Columns().AdjustToContents(); // Autoajustar columnas

                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;filename=Reporte_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".xlsx");

                    using (var ms = new MemoryStream())
                    {
                        workbook.SaveAs(ms);
                        Response.BinaryWrite(ms.ToArray());
                    }

                    Response.End();
                }
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al exportar: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error en btnExportar_Click: " + ex.Message);
            }
        }

        protected void btnExportarCSV_Click(object sender, EventArgs e)
        {
            try
            {
                DataTable dt = ConvertirListaADataTable();
                ExportarCSV(dt, "Reporte", Response);
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al exportar CSV: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error en btnExportarCSV_Click: " + ex.Message);
            }
        }

        // ── Opción A: Importar alumnos desde Excel con vista previa ──

        [Serializable]
        private class ImportRow
        {
            public InfoDatosPersonales Persona { get; set; }
            public string Estado { get; set; } // "ok", "duplicado", "error"
            public string Mensaje { get; set; }
        }

        protected void btnDescargarPlantilla_Click(object sender, EventArgs e)
        {
            try
            {
                using (var workbook = new XLWorkbook())
                {
                    var ws = workbook.Worksheets.Add("Plantilla");

                    ws.Cell(1, 1).Value = "Matrícula";
                    ws.Cell(1, 2).Value = "Nombre";
                    ws.Cell(1, 3).Value = "Materia";
                    ws.Cell(1, 4).Value = "Parcial 1";
                    ws.Cell(1, 5).Value = "Parcial 2";
                    ws.Cell(1, 6).Value = "TP";
                    ws.Cell(1, 7).Value = "Examen Final";

                    var headerRow = ws.Row(1);
                    headerRow.Style.Font.Bold = true;
                    headerRow.Style.Fill.BackgroundColor = XLColor.SteelBlue;
                    headerRow.Style.Font.FontColor = XLColor.White;

                    ws.Columns().AdjustToContents();

                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;filename=Plantilla_Importacion.xlsx");

                    using (var ms = new MemoryStream())
                    {
                        workbook.SaveAs(ms);
                        Response.BinaryWrite(ms.ToArray());
                    }

                    Response.End();
                }
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al generar la plantilla: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error en btnDescargarPlantilla_Click: " + ex.Message);
            }
        }

        protected void btnPrevisualizarImportacion_Click(object sender, EventArgs e)
        {
            try
            {
                if (!FileImportar.HasFile)
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Selecciona un archivo Excel (.xlsx) para previsualizar.");
                    return;
                }

                var listaActual = ObtenerListViewState();
                var filas = new List<ImportRow>();

                using (var ms = new MemoryStream(FileImportar.FileBytes))
                using (var workbook = new XLWorkbook(ms))
                {
                    var ws = workbook.Worksheets.First();
                    int lastRow = ws.LastRowUsed()?.RowNumber() ?? 1;

                    for (int fila = 2; fila <= lastRow; fila++)
                    {
                        string matricula = ws.Cell(fila, 1).GetString().Trim();
                        string nombre = ws.Cell(fila, 2).GetString().Trim();
                        string materia = ws.Cell(fila, 3).GetString().Trim();

                        if (string.IsNullOrWhiteSpace(matricula) && string.IsNullOrWhiteSpace(nombre) && string.IsNullOrWhiteSpace(materia))
                            continue;

                        var persona = new InfoDatosPersonales
                        {
                            Matricula = matricula,
                            Nombre = nombre,
                            Materia = materia,
                            Parcial1 = LeerDecimalCelda(ws.Cell(fila, 4)),
                            Parcial2 = LeerDecimalCelda(ws.Cell(fila, 5)),
                            TP = LeerDecimalCelda(ws.Cell(fila, 6)),
                            ExamenFinal = LeerDecimalCelda(ws.Cell(fila, 7))
                        };

                        string estado;
                        string mensaje;

                        if (!PersonasService.EsMateriaValida(persona.Materia))
                        {
                            estado = "error";
                            mensaje = "Materia no v\u00e1lida. Las materias v\u00e1lidas son: " +
                                string.Join(", ", PersonasService.MateriasValidas);
                        }
                        else if (!_personasService.ValidarPersona(persona))
                        {
                            estado = "error";
                            mensaje = "Datos incompletos o calificaciones fuera de rango.";
                        }
                        else if (listaActual.Any(p => p.Matricula.Equals(matricula, StringComparison.OrdinalIgnoreCase)
                                                     && p.Materia.Equals(materia, StringComparison.OrdinalIgnoreCase)))
                        {
                            estado = "duplicado";
                            mensaje = "Ya existe un registro con esta matr\u00edcula para esta materia.";
                        }
                        else
                        {
                            persona.Materia = PersonasService.NormalizarMateria(persona.Materia);
                            estado = "ok";
                            mensaje = "Listo para importar.";
                        }

                        filas.Add(new ImportRow { Persona = persona, Estado = estado, Mensaje = mensaje });
                    }
                }

                ViewState["ImportPreview"] = filas;
                litPreviewImportacion.Text = RenderPreviewImportacion(filas);
                PnlDuplicados.Visible = filas.Any(f => f.Estado == "duplicado");
                btnConfirmarImportacion.Visible = filas.Any(f => f.Estado != "error");

                Page.ClientScript.RegisterStartupScript(this.GetType(), "abrirModalImportarPreview",
                    "document.getElementById('modalImportar').classList.add('show');", true);
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al previsualizar el archivo: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error en btnPrevisualizarImportacion_Click: " + ex.Message);
            }
        }

        protected void btnConfirmarImportacion_Click(object sender, EventArgs e)
        {
            try
            {
                if (!(ViewState["ImportPreview"] is List<ImportRow> filas) || filas.Count == 0)
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("No hay datos previsualizados para importar.");
                    return;
                }

                bool sobrescribir = rblDuplicados.SelectedValue == "sobrescribir";
                var lista = ObtenerListViewState();
                int insertados = 0, actualizados = 0, omitidos = 0;

                foreach (var fila in filas)
                {
                    if (fila.Estado == "error")
                    {
                        omitidos++;
                        continue;
                    }

                    if (fila.Estado == "duplicado")
                    {
                        if (!sobrescribir)
                        {
                            omitidos++;
                            continue;
                        }

                        fila.Persona.Materia = PersonasService.NormalizarMateria(fila.Persona.Materia);
                        int idx = lista.FindIndex(p => p.Matricula.Equals(fila.Persona.Matricula, StringComparison.OrdinalIgnoreCase)
                                                       && p.Materia.Equals(fila.Persona.Materia, StringComparison.OrdinalIgnoreCase));
                        if (idx >= 0)
                        {
                            var anterior = lista[idx];
                            lista[idx] = fila.Persona;
                            AuditLogger.RegistrarActualizacion(Session, anterior, fila.Persona);
                            actualizados++;
                        }
                        continue;
                    }

                    // estado == "ok"
                    fila.Persona.Materia = PersonasService.NormalizarMateria(fila.Persona.Materia);
                    lista.Add(fila.Persona);
                    AuditLogger.RegistrarInsercion(Session, fila.Persona);
                    insertados++;
                }

                GuardarListViewState(lista);
                ViewState.Remove("ImportPreview");
                litPreviewImportacion.Text = "";
                PnlDuplicados.Visible = false;
                btnConfirmarImportacion.Visible = false;

                ActualizarContadorLog();
                ProcesarYActualizarGrid();
                ActualizarEstadisticas();

                btnMensaje.Text = HttpUtility.HtmlEncode(
                    "Importación completa: " + insertados + " nuevos, " + actualizados + " actualizados, " + omitidos + " omitidos.");

                Page.ClientScript.RegisterStartupScript(this.GetType(), "cerrarModalImportar",
                    "document.getElementById('modalImportar').classList.remove('show');", true);
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al importar: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error en btnConfirmarImportacion_Click: " + ex.Message);
            }
        }

        private static decimal LeerDecimalCelda(IXLCell celda)
        {
            if (celda.TryGetValue(out decimal valor))
                return valor;
            return 0;
        }

        private string RenderPreviewImportacion(List<ImportRow> filas)
        {
            if (filas.Count == 0)
                return "<div class=\"history-empty\">No se encontraron filas con datos en el archivo.</div>";

            int ok = filas.Count(f => f.Estado == "ok");
            int dup = filas.Count(f => f.Estado == "duplicado");
            int err = filas.Count(f => f.Estado == "error");

            var html = new System.Text.StringBuilder();
            html.AppendFormat("<div class=\"import-summary\">{0} listos para importar &middot; {1} duplicados &middot; {2} con errores</div>", ok, dup, err);

            html.Append("<table class=\"import-preview-table\"><thead><tr>");
            html.Append("<th>Estado</th><th>Matrícula</th><th>Nombre</th><th>Materia</th><th>P1</th><th>P2</th><th>TP</th><th>Final</th><th>Detalle</th>");
            html.Append("</tr></thead><tbody>");

            foreach (var f in filas)
            {
                html.AppendFormat("<tr class=\"import-row-{0}\">", f.Estado);
                html.AppendFormat("<td class=\"import-row-estado\">{0}</td>", f.Estado.ToUpperInvariant());
                html.AppendFormat("<td>{0}</td>", HttpUtility.HtmlEncode(f.Persona.Matricula));
                html.AppendFormat("<td>{0}</td>", HttpUtility.HtmlEncode(f.Persona.Nombre));
                html.AppendFormat("<td>{0}</td>", HttpUtility.HtmlEncode(f.Persona.Materia));
                html.AppendFormat("<td>{0:0.0}</td>", f.Persona.Parcial1);
                html.AppendFormat("<td>{0:0.0}</td>", f.Persona.Parcial2);
                html.AppendFormat("<td>{0:0.0}</td>", f.Persona.TP);
                html.AppendFormat("<td>{0:0.0}</td>", f.Persona.ExamenFinal);
                html.AppendFormat("<td>{0}</td>", HttpUtility.HtmlEncode(f.Mensaje));
                html.Append("</tr>");
            }

            html.Append("</tbody></table>");
            return html.ToString();
        }

        protected void btnGuardarSesion_Click(object sender, EventArgs e)
        {
            try
            {
                var backup = new SesionBackup
                {
                    Version = "1.0",
                    FechaExportacion = DateTime.Now,
                    Personas = ObtenerListViewState(),
                    AuditLog = AuditLogger.ObtenerEntradasRaw(Session)
                };

                string json = JsonConvert.SerializeObject(backup, Formatting.Indented);
                byte[] bytes = Encoding.UTF8.GetBytes(json);

                Response.Clear();
                Response.ContentType = "application/json";
                Response.AddHeader("content-disposition", "attachment;filename=Sesion_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".json");
                Response.BinaryWrite(bytes);
                Response.End();
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al guardar sesión: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error en btnGuardarSesion_Click: " + ex.Message);
            }
        }

        protected void btnRestaurarSesion_Click(object sender, EventArgs e)
        {
            try
            {
                if (!FileSesion.HasFile)
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("Selecciona un archivo JSON de respaldo para restaurar.");
                    return;
                }

                string json = Encoding.UTF8.GetString(FileSesion.FileBytes);
                var backup = JsonConvert.DeserializeObject<SesionBackup>(json);

                if (backup?.Personas == null)
                {
                    btnMensaje.Text = HttpUtility.HtmlEncode("El archivo no tiene un formato válido de respaldo de sesión.");
                    return;
                }

                foreach (var p in backup.Personas)
                {
                    p.Matricula = p.Matricula?.Trim();
                    p.Nombre = p.Nombre?.Trim();
                    p.Materia = p.Materia?.Trim();
                }

                var personasConMateriaValida = backup.Personas
                    .Where(p => !string.IsNullOrWhiteSpace(p.Materia) && PersonasService.EsMateriaValida(p.Materia))
                    .ToList();

                foreach (var p in personasConMateriaValida)
                {
                    p.Materia = PersonasService.NormalizarMateria(p.Materia);
                }

                var personasValidas = personasConMateriaValida
                    .Where(p => _personasService.ValidarPersona(p))
                    .ToList();

                int invalidas = backup.Personas.Count - personasConMateriaValida.Count;

                GuardarListViewState(personasValidas);
                AuditLogger.RestaurarEntradas(Session, backup.AuditLog ?? new List<AuditEntry>());

                CancelarEdicion();
                ActualizarContadorLog();
                ProcesarYActualizarGrid();
                ActualizarEstadisticas();

                string msg = "Sesi\u00f3n restaurada: " + personasValidas.Count + " de " + backup.Personas.Count +
                    " registros cargados";

                if (invalidas > 0)
                    msg += ", " + invalidas + " registros omitidos por materia no v\u00e1lida";

                msg += ", " + (backup.AuditLog?.Count ?? 0) + " eventos de auditor\u00eda.";
                btnMensaje.Text = HttpUtility.HtmlEncode(msg);
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al restaurar sesión: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error en btnRestaurarSesion_Click: " + ex.Message);
            }
        }

        private List<InfoDatosPersonales> ObtenerListViewState()
        {
            try
            {
                var lista = ViewState["list"] as List<InfoDatosPersonales> ?? (Session["ListaPersonas"] as List<InfoDatosPersonales> ?? new List<InfoDatosPersonales>());
                if (lista != null)
                {
                    ViewState["list"] = lista;
                }
                return lista;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ObtenerListViewState: " + ex.Message);
                return new List<InfoDatosPersonales>();
            }
        }

        private void GuardarListViewState(List<InfoDatosPersonales> lista)
        {
            try
            {
                ViewState["list"] = lista;
                Session["ListaPersonas"] = lista;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en GuardarListViewState: " + ex.Message);
            }
        }

        private void ProcesarYActualizarGrid()
        {
            try
            {
                var lista = ObtenerListViewState();
                lista = _personasService.ProcesarPersonas(lista);
                GuardarListViewState(lista);

                bool hayFiltro = !string.IsNullOrWhiteSpace(TxtBusqueda?.Text) ||
                                 (DdlFiltroMateria?.SelectedIndex ?? 0) > 0;

                if (hayFiltro)
                {
                    AplicarFiltroYOrden();
                }
                else
                {
                    GridDatos.DataSource = lista;
                    GridDatos.DataBind();
                    LblResultados.Text = "Mostrando <strong>" + lista.Count + "</strong> de <strong>" + lista.Count + "</strong> registros";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ProcesarYActualizarGrid: " + ex.Message);
                throw;
            }
        }

        private void AplicarFiltroYOrden()
        {
            try
            {
                var listaCompleta = ObtenerListViewState();
                string texto = TxtBusqueda?.Text?.Trim() ?? string.Empty;
                string filtro = DdlFiltroMateria?.SelectedValue ?? string.Empty;
                string orden = DdlOrden?.SelectedValue ?? "Nombre";
                bool ascendente = ChkAscendente?.Checked ?? true;

                var resultado = _personasService.BuscarYOrdenar(
                    listaCompleta, texto, filtro, orden, ascendente);

                GridDatos.DataSource = resultado;
                GridDatos.DataBind();

                LblResultados.Text = "Mostrando <strong>" + resultado.Count + "</strong> de <strong>" + listaCompleta.Count + "</strong> registros";
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al aplicar filtros: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error en AplicarFiltroYOrden: " + ex.Message);
            }
        }

        private void ActualizarEstadisticas()
        {
            try
            {
                var lista = ObtenerListViewState();
                LblStatsCount.Text = lista.Count + (lista.Count == 1 ? " entrada" : " entradas");
                var estadisticas = _personasService.CalcularEstadisticas(lista);

                if (lista.Count > 0)
                {
                    LblPromedioClase.Text = estadisticas.PromedioClase.ToString("0.00");
                    LblMejorCalificacion.Text = estadisticas.MejorCalificacion.ToString("0.0");
                    LblAlumnoMejor.Text = estadisticas.AlumnoMejorCalificacion;
                    LblMateriaMejor.Text = estadisticas.MateriaMejorCalificacion;
                    LblSituacionMejor.Text = GetSituacionText(estadisticas.SituacionMejorCalificacion);
                    LblSituacionMejor.CssClass = GetSituacionClass(estadisticas.SituacionMejorCalificacion);

                    LblPeorCalificacion.Text = estadisticas.PeorCalificacion.ToString("0.0");
                    LblAlumnoPeor.Text = estadisticas.AlumnoPeorCalificacion;
                    LblMateriaPeor.Text = estadisticas.MateriaPeorCalificacion;
                    if (!string.IsNullOrEmpty(estadisticas.SituacionPeorCalificacion))
                    {
                        LblSituacionPeor.Text = GetSituacionText(estadisticas.SituacionPeorCalificacion);
                        LblSituacionPeor.CssClass = GetSituacionClass(estadisticas.SituacionPeorCalificacion);
                    }
                    else
                    {
                        LblSituacionPeor.Text = "";
                        LblSituacionPeor.CssClass = "";
                    }
                }
                else
                {
                    LblPromedioClase.Text = "&mdash;";
                    LblMejorCalificacion.Text = "&mdash;";
                    LblAlumnoMejor.Text = "";
                    LblMateriaMejor.Text = "";
                    LblSituacionMejor.Text = "";
                    LblSituacionMejor.CssClass = "";
                    LblPeorCalificacion.Text = "&mdash;";
                    LblAlumnoPeor.Text = "";
                    LblMateriaPeor.Text = "";
                    LblSituacionPeor.Text = "";
                    LblSituacionPeor.CssClass = "";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ActualizarEstadisticas: " + ex.Message);
            }
        }

        private static readonly Dictionary<string, string> ColoresMateria = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
        {
            { "Lenguaje de Programacion 2", "#5aadff" },
            { "Historia y Filosofia de la Ciencia", "#b87eff" },
            { "Etica Personal", "var(--teal)" },
            { "Fisica 3", "var(--amber)" },
            { "Matematica para Informaticos", "#ff7a7a" }
        };

        private void CargarRegistroParaEdicion(InfoDatosPersonales persona)
        {
            TxtMatricula.Text = persona.Matricula;
            TxtNombre.Text = persona.Nombre;
            DdlMateria.SelectedValue = persona.Materia ?? string.Empty;
            TxtParcial1.Text = persona.Parcial1.ToString(CultureInfo.InvariantCulture);
            TxtParcial2.Text = persona.Parcial2.ToString(CultureInfo.InvariantCulture);
            TxtTP.Text = persona.TP.ToString(CultureInfo.InvariantCulture);
            TxtExamenFinal.Text = persona.ExamenFinal.ToString(CultureInfo.InvariantCulture);

            HfMatriculaEdicion.Value = persona.Matricula;
            HfMateriaEdicion.Value = persona.Materia;
            TxtMatricula.Enabled = false;

            btnProcesar.Visible = false;
            btnGuardarEdicion.Visible = true;
            btnCancelarEdicion.Visible = true;

            btnMensaje.Text = HttpUtility.HtmlEncode("Editando registro de " + persona.NombreCompleto + ". Modifica los datos y hace clic en 'Guardar Edicion'.");
            TxtNombre?.Focus();
        }

        private void EliminarRegistro(List<InfoDatosPersonales> lista, string matricula, string materia)
        {
            // Encontrar y guardar la persona antes de eliminarla
            var personaAEliminar = lista.FirstOrDefault(p =>
                p.Matricula.Equals(matricula, StringComparison.OrdinalIgnoreCase)
                && p.Materia.Equals(materia, StringComparison.OrdinalIgnoreCase));

            int removidos = lista.RemoveAll(p =>
                p.Matricula.Equals(matricula, StringComparison.OrdinalIgnoreCase)
                && p.Materia.Equals(materia, StringComparison.OrdinalIgnoreCase));

            if (removidos == 0)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("No se encontro el registro a eliminar.");
                return;
            }

            // Registrar en auditoría después de eliminar
            if (personaAEliminar != null)
            {
                AuditLogger.RegistrarEliminacion(Session, personaAEliminar);
                ActualizarContadorLog();
            }

            GuardarListViewState(lista);
            ProcesarYActualizarGrid();
            ActualizarEstadisticas();
            btnMensaje.Text = HttpUtility.HtmlEncode("Registro eliminado correctamente.");
        }

        private void CancelarEdicion()
        {
            LimpiarFormulario();
            HfMatriculaEdicion.Value = string.Empty;
            HfMateriaEdicion.Value = string.Empty;
            TxtMatricula.Enabled = true;
            btnProcesar.Visible = true;
            btnGuardarEdicion.Visible = false;
            btnCancelarEdicion.Visible = false;
        }

        private void LimpiarFormulario()
        {
            TxtMatricula.Text = string.Empty;
            TxtNombre.Text = string.Empty;
            TxtParcial1.Text = string.Empty;
            TxtParcial2.Text = string.Empty;
            TxtTP.Text = string.Empty;
            TxtExamenFinal.Text = string.Empty;
            DdlMateria.SelectedIndex = 0;
            TxtMatricula?.Focus();
        }

        private InfoDatosPersonales CrearPersonaDesdeFormulario()
        {
            string matricula = TxtMatricula?.Text?.Trim() ?? string.Empty;
            string nombre = TxtNombre?.Text?.Trim() ?? string.Empty;
            string materia = DdlMateria?.SelectedValue?.Trim() ?? string.Empty;
            string p1Text = TxtParcial1?.Text?.Trim() ?? string.Empty;
            string p2Text = TxtParcial2?.Text?.Trim() ?? string.Empty;
            string tpText = TxtTP?.Text?.Trim() ?? string.Empty;
            string efText = TxtExamenFinal?.Text?.Trim() ?? string.Empty;

            if (string.IsNullOrEmpty(matricula) || string.IsNullOrEmpty(nombre) ||
                string.IsNullOrEmpty(materia) || string.IsNullOrEmpty(p1Text) ||
                string.IsNullOrEmpty(p2Text) || string.IsNullOrEmpty(tpText) ||
                string.IsNullOrEmpty(efText))
            {
                throw new ArgumentException(HttpUtility.HtmlEncode("Todos los campos del formulario son obligatorios."));
            }

            return new InfoDatosPersonales
            {
                Matricula = matricula,
                Nombre = nombre,
                Materia = materia,
                Parcial1 = decimal.TryParse(p1Text, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal p1) ? p1 : 0,
                Parcial2 = decimal.TryParse(p2Text, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal p2) ? p2 : 0,
                TP = decimal.TryParse(tpText, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal tp) ? tp : 0,
                ExamenFinal = decimal.TryParse(efText, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal ef) ? ef : 0
            };
        }

        private DataTable ConvertirListaADataTable()
        {
            DataTable dt = new DataTable();

            // Crear columnas
            dt.Columns.Add("Matrícula", typeof(string));
            dt.Columns.Add("Nombre", typeof(string));
            dt.Columns.Add("Materia", typeof(string));
            dt.Columns.Add("Parcial 1", typeof(decimal));
            dt.Columns.Add("Parcial 2", typeof(decimal));
            dt.Columns.Add("TP", typeof(decimal));
            dt.Columns.Add("Examen Final", typeof(decimal));
            dt.Columns.Add("Total", typeof(decimal));
            dt.Columns.Add("Promedio", typeof(decimal));

            // Agregar filas desde la lista del ViewState
            var lista = ObtenerListViewState();
            foreach (var persona in lista)
            {
                dt.Rows.Add(
                    persona.Matricula,
                    persona.Nombre,
                    persona.Materia,
                    persona.Parcial1,
                    persona.Parcial2,
                    persona.TP,
                    persona.ExamenFinal,
                    persona.Total,
                    persona.Promedio
                );
            }

            return dt;
        }

        private static void ExportarCSV(DataTable dt, string nombreArchivo, HttpResponse response)
        {
            response.Clear();
            response.Buffer = true;
            response.AddHeader("content-disposition", $"attachment;filename={nombreArchivo}_{DateTime.Now:yyyyMMdd_HHmmss}.csv");
            response.ContentType = "text/csv";
            response.ContentEncoding = System.Text.Encoding.UTF8;

            // BOM para que Excel reconozca UTF-8 (tildes, ñ, etc.)
            response.BinaryWrite(System.Text.Encoding.UTF8.GetPreamble());

            StringBuilder sb = new StringBuilder();

            // Encabezados
            var encabezados = dt.Columns
                                .Cast<DataColumn>()
                                .Select(col => EscaparCSV(col.ColumnName));
            sb.AppendLine(string.Join(",", encabezados));

            // Filas
            foreach (DataRow row in dt.Rows)
            {
                var campos = row.ItemArray.Select(campo => 
                {
                    // Formatea decimales con punto (.) en lugar de coma (,)
                    if (campo is decimal dec)
                    {
                        string valor = dec.ToString("0.00", System.Globalization.CultureInfo.InvariantCulture);
                        // Retorna sin escapar - Excel lo reconoce como número
                        return valor;
                    }
                    // Para otros tipos de datos, retorna escapado si es necesario
                    return EscaparCSV(campo?.ToString() ?? "");
                });
                sb.AppendLine(string.Join(",", campos));
            }

            response.Output.Write(sb.ToString());
            response.Flush();
            response.End();
        }

        private static string EscaparCSV(string valor)
        {
            if (valor.Contains(",") || valor.Contains("\"") || valor.Contains("\n") || valor.Contains("\r"))
                return $"\"{valor.Replace("\"", "\"\"")}\"";
            return valor;
        }

        private void ActualizarContadorLog()
        {
            try
            {
                int cantidad = AuditLogger.CantidadEventos(Session);
                lblLogCount.Text = cantidad.ToString();
                lblLogCount.Attributes["data-zero"] = cantidad == 0 ? "true" : "false";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ActualizarContadorLog: " + ex.Message);
            }

            ActualizarIndicadorCapacidad();
        }

        private const int UmbralCapacidadKb = 500;

        private void ActualizarIndicadorCapacidad()
        {
            try
            {
                var lista = ObtenerListViewState();
                var auditLog = AuditLogger.ObtenerEntradasRaw(Session);

                int bytes = JsonConvert.SerializeObject(lista).Length + JsonConvert.SerializeObject(auditLog).Length;
                double kb = bytes / 1024.0;

                lblCapacidad.Text = lista.Count + (lista.Count == 1 ? " alumno" : " alumnos") + " &middot; ~" + kb.ToString("0.0") + " KB";

                if (kb > UmbralCapacidadKb)
                    lblCapacidad.CssClass = "capacidad-info capacidad-warn";
                else
                    lblCapacidad.CssClass = "capacidad-info";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ActualizarIndicadorCapacidad: " + ex.Message);
            }
        }

        protected string RenderAuditEntries()
        {
            try
            {
                var ultimas = AuditLogger.ObtenerUltimas(Session, int.MaxValue);
                return RenderAuditEntriesHtml(ultimas);
            }
            catch
            {
                return "<div class=\"history-empty\">Sin eventos registrados en esta sesi\u00f3n.</div>";
            }
        }

        private void MostrarPerfilAlumno(InfoDatosPersonales persona)
        {
            var registros = ObtenerListViewState()
                .Where(p => p.Matricula.Equals(persona.Matricula, StringComparison.OrdinalIgnoreCase))
                .ToList();

            litPerfilNombre.Text = HttpUtility.HtmlEncode(persona.NombreCompleto);
            litPerfilMatricula.Text = HttpUtility.HtmlEncode(persona.Matricula) +
                (registros.Count > 1 ? " &middot; " + registros.Count + " materias registradas" : "");

            var html = new System.Text.StringBuilder();
            foreach (var reg in registros)
            {
                string color = ColoresMateria.TryGetValue(reg.Materia ?? "", out var c) ? c : "var(--text2)";

                html.Append("<div class=\"perfil-materia-section\">");
                html.Append("<div class=\"perfil-materia-header\">");
                html.AppendFormat("<span class=\"perfil-materia-name\" style=\"color:{0}\">{1}</span>",
                    color, HttpUtility.HtmlEncode(reg.Materia));
                html.AppendFormat("<span class=\"{0}\">{1}</span>", GetSituacionClass(reg.Situacion), GetSituacionText(reg.Situacion));
                html.Append("</div>");

                html.Append("<div class=\"perfil-notas-grid\">");
                html.AppendFormat("<div class=\"perfil-nota-item\"><div class=\"perfil-nota-label\">P1</div><div class=\"perfil-nota-val\">{0:0.0}</div></div>", reg.Parcial1);
                html.AppendFormat("<div class=\"perfil-nota-item\"><div class=\"perfil-nota-label\">P2</div><div class=\"perfil-nota-val\">{0:0.0}</div></div>", reg.Parcial2);
                html.AppendFormat("<div class=\"perfil-nota-item\"><div class=\"perfil-nota-label\">TP</div><div class=\"perfil-nota-val\">{0:0.0}</div></div>", reg.TP);
                html.AppendFormat("<div class=\"perfil-nota-item\"><div class=\"perfil-nota-label\">Final</div><div class=\"perfil-nota-val\">{0:0.0}</div></div>", reg.ExamenFinal);
                html.AppendFormat("<div class=\"perfil-nota-item\"><div class=\"perfil-nota-label\">Total</div><div class=\"perfil-nota-val\">{0:0.0}</div></div>", reg.Total);
                html.AppendFormat("<div class=\"perfil-nota-item\"><div class=\"perfil-nota-label\">Promedio</div><div class=\"perfil-nota-val\">{0:0.00}</div></div>", reg.Promedio);
                html.AppendFormat("<div class=\"perfil-nota-item\"><div class=\"perfil-nota-label\">Situaci&oacute;n</div><div class=\"perfil-nota-val\">{0}</div></div>", GetSituacionText(reg.Situacion));
                html.Append("</div>");

                html.Append("<div class=\"perfil-hist-title\">Historial &mdash; " + HttpUtility.HtmlEncode(reg.Materia) + "</div>");
                var entradas = AuditLogger.ObtenerPorMatriculaYMateria(Session, reg.Matricula, reg.Materia);
                html.Append("<div class=\"history-panel\">" + RenderAuditEntriesHtml(entradas) + "</div>");

                html.Append("</div>");
            }
            litPerfilMaterias.Text = html.ToString();

            Page.ClientScript.RegisterStartupScript(this.GetType(), "abrirPerfilAlumno",
                "document.getElementById('modalPerfilAlumno').classList.add('show');", true);
        }

        protected void GridDatos_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.DataItem is InfoDatosPersonales persona)
            {
                e.Row.Attributes["data-matricula"] = persona.Matricula;
                e.Row.Attributes["data-materia"] = persona.Materia;
            }
        }

        private void MostrarHistorialAlumno(InfoDatosPersonales persona)
        {
            var entradas = AuditLogger.ObtenerPorMatricula(Session, persona.Matricula);
            litHistorialAlumnoNombre.Text = HttpUtility.HtmlEncode(persona.NombreCompleto + " (" + persona.Matricula + ")");
            litHistorialAlumno.Text = RenderAuditEntriesHtml(entradas);
            Page.ClientScript.RegisterStartupScript(this.GetType(), "abrirHistorialAlumno",
                "document.getElementById('modalHistorialAlumno').classList.add('show');", true);
        }

        private string RenderAuditEntriesHtml(List<AuditEntry> entradas)
        {
            if (entradas == null || entradas.Count == 0)
            {
                return "<div class=\"history-empty\">Sin eventos registrados en esta sesi\u00f3n.</div>";
            }

            var html = new System.Text.StringBuilder();
            foreach (var e in entradas)
            {
                string cls = e.Accion == "INSERT" ? "ins" : e.Accion == "UPDATE" ? "upd" : "del";
                html.Append("<div class=\"history-item\">");
                html.AppendFormat("<div class=\"h-dot {0}\"></div>", cls);
                html.AppendFormat("<div class=\"h-action {0}\">{1}</div>", cls, e.Accion);
                html.AppendFormat("<div class=\"h-detail\">{0} &middot; {1} &middot; {2}</div>",
                    System.Web.HttpUtility.HtmlEncode(e.Nombre),
                    System.Web.HttpUtility.HtmlEncode(e.Materia),
                    System.Web.HttpUtility.HtmlEncode(e.Detalle));
                html.AppendFormat("<div class=\"h-time\">{0}</div>", e.Timestamp.ToLongTimeString());
                html.Append("</div>");
            }
            return html.ToString();
        }

        protected string GetPromedioClass(object promedio)
        {
            decimal p = 0;
            try { p = Convert.ToDecimal(promedio); } catch { }
            if (p >= 4m) return "promedio-excelente";
            if (p >= 3m) return "promedio-regular";
            return "promedio-bajo";
        }

        protected string GetSituacionClass(object situacion)
        {
            return situacion?.ToString() == "Aprobado" ? "status-approved" : "status-rejected";
        }

        protected string GetSituacionText(object situacion)
        {
            return situacion?.ToString() == "Aprobado" ? "Aprobado ✓" : "Reprobado X";
        }

        protected void btnDescargarLog_Click(object sender, EventArgs e)
        {
            try
            {
                var entradas = AuditLogger.ObtenerUltimas(Session, int.MaxValue);

                using (var workbook = new XLWorkbook())
                {
                    var ws = workbook.Worksheets.Add("Log de Auditoría");

                    // Encabezados
                    ws.Cell(1, 1).Value = "Timestamp";
                    ws.Cell(1, 2).Value = "Acción";
                    ws.Cell(1, 3).Value = "Matrícula";
                    ws.Cell(1, 4).Value = "Nombre";
                    ws.Cell(1, 5).Value = "Materia";
                    ws.Cell(1, 6).Value = "Detalle";

                    var headerRow = ws.Row(1);
                    headerRow.Style.Font.Bold = true;
                    headerRow.Style.Fill.BackgroundColor = XLColor.FromArgb(31, 41, 55);
                    headerRow.Style.Font.FontColor = XLColor.White;

                    if (entradas.Count == 0)
                    {
                        ws.Cell(2, 1).Value = "(Sin eventos registrados en esta sesión)";
                        ws.Range(2, 1, 2, 6).Merge();
                        ws.Cell(2, 1).Style.Font.Italic = true;
                        ws.Cell(2, 1).Style.Font.FontColor = XLColor.Gray;
                    }
                    else
                    {
                        int fila = 2;
                        foreach (var entry in entradas)
                        {
                            ws.Cell(fila, 1).Value = entry.Timestamp.ToString("yyyy-MM-dd HH:mm:ss");
                            ws.Cell(fila, 2).Value = entry.Accion;
                            ws.Cell(fila, 3).Value = entry.Matricula;
                            ws.Cell(fila, 4).Value = entry.Nombre;
                            ws.Cell(fila, 5).Value = entry.Materia;
                            ws.Cell(fila, 6).Value = entry.Detalle;

                            XLColor rowColor;
                            XLColor textColor;
                            if (entry.Accion == "INSERT")
                            {
                                rowColor = XLColor.FromArgb(220, 250, 237);
                                textColor = XLColor.FromArgb(14, 100, 60);
                            }
                            else if (entry.Accion == "UPDATE")
                            {
                                rowColor = XLColor.FromArgb(255, 248, 220);
                                textColor = XLColor.FromArgb(130, 80, 0);
                            }
                            else
                            {
                                rowColor = XLColor.FromArgb(255, 228, 228);
                                textColor = XLColor.FromArgb(150, 20, 20);
                            }

                            var row = ws.Row(fila);
                            row.Style.Fill.BackgroundColor = rowColor;
                            row.Style.Font.FontColor = textColor;
                            fila++;
                        }

                        // Hoja de resumen
                        var resumen = workbook.Worksheets.Add("Resumen");
                        var desglose = AuditLogger.ObtenerDesglose(Session);
                        resumen.Cell(1, 1).Value = "Tipo";
                        resumen.Cell(1, 2).Value = "Cantidad";
                        resumen.Row(1).Style.Font.Bold = true;
                        resumen.Row(1).Style.Fill.BackgroundColor = XLColor.FromArgb(31, 41, 55);
                        resumen.Row(1).Style.Font.FontColor = XLColor.White;
                        resumen.Cell(2, 1).Value = "INSERT";  resumen.Cell(2, 2).Value = desglose["INSERT"];
                        resumen.Cell(3, 1).Value = "UPDATE";  resumen.Cell(3, 2).Value = desglose["UPDATE"];
                        resumen.Cell(4, 1).Value = "DELETE";  resumen.Cell(4, 2).Value = desglose["DELETE"];
                        resumen.Cell(5, 1).Value = "TOTAL";   resumen.Cell(5, 2).Value = entradas.Count;
                        resumen.Row(5).Style.Font.Bold = true;
                        resumen.Columns().AdjustToContents();
                    }

                    ws.Columns().AdjustToContents();

                    string nombre = string.Format("AuditLog_{0}.xlsx",
                        DateTime.Now.ToString("yyyyMMdd_HHmmss"));

                    Response.Clear();
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition",
                        string.Format("attachment; filename=\"{0}\"", nombre));

                    using (var ms = new MemoryStream())
                    {
                        workbook.SaveAs(ms);
                        Response.BinaryWrite(ms.ToArray());
                    }

                    Response.End();
                }
            }
            catch (Exception ex)
            {
                btnMensaje.Text = HttpUtility.HtmlEncode("Error al descargar log: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Error en btnDescargarLog_Click: " + ex.Message);
            }
        }
    }
}