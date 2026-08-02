using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using BLL.DTO;

namespace BLL.Fachada
{
    /// <summary>
    /// Logger de auditoría de sesión.
    /// 
    /// ESTRATEGIA DE ALMACENAMIENTO:
    ///   - Las entradas del log se guardan en un diccionario pasado desde la página ASP.NET.
    ///   - Al descargar, se generan los bytes CSV en memoria (MemoryStream) y se envían
    ///     directamente al cliente sin escribir nada en disco del servidor.
    ///   - Esto evita problemas de permisos de escritura en IIS y no deja archivos huérfanos.
    /// 
    /// USO DESDE EL CODE-BEHIND:
    ///   AuditLogger.RegistrarInsercion(Session, persona);
    ///   AuditLogger.RegistrarActualizacion(Session, anterior, nuevo);
    ///   AuditLogger.RegistrarEliminacion(Session, persona);
    ///   byte[] csv = AuditLogger.GenerarCsvBytes(Session);
    /// </summary>
    public static class AuditLogger
    {
        private const string SessionKey = "AuditLog";

        // ─────────────────────────────────────────────
        // Métodos de registro
        // ─────────────────────────────────────────────

        /// <summary>Registra la inserción de un nuevo estudiante.</summary>
        public static void RegistrarInsercion(dynamic session, InfoDatosPersonales persona)
        {
            var detalle = string.Format(
                "P1={0} P2={1} TP={2} Final={3} Total={4} Promedio={5}",
                persona.Parcial1, persona.Parcial2, persona.TP,
                persona.ExamenFinal, persona.Total, persona.Promedio.ToString("F2"));

            Agregar(session, "INSERT", persona, detalle);
        }

        /// <summary>Registra la modificación de un registro existente.</summary>
        public static void RegistrarActualizacion(dynamic session,
                                                  InfoDatosPersonales anterior,
                                                  InfoDatosPersonales nuevo)
        {
            var cambios = new List<string>();

            if (anterior.Nombre != nuevo.Nombre)
                cambios.Add(string.Format("Nombre: [{0}] → [{1}]", anterior.Nombre, nuevo.Nombre));
            if (anterior.Materia != nuevo.Materia)
                cambios.Add(string.Format("Materia: [{0}] → [{1}]", anterior.Materia, nuevo.Materia));
            if (anterior.Parcial1 != nuevo.Parcial1)
                cambios.Add(string.Format("P1: {0} → {1}", anterior.Parcial1, nuevo.Parcial1));
            if (anterior.Parcial2 != nuevo.Parcial2)
                cambios.Add(string.Format("P2: {0} → {1}", anterior.Parcial2, nuevo.Parcial2));
            if (anterior.TP != nuevo.TP)
                cambios.Add(string.Format("TP: {0} → {1}", anterior.TP, nuevo.TP));
            if (anterior.ExamenFinal != nuevo.ExamenFinal)
                cambios.Add(string.Format("Final: {0} → {1}", anterior.ExamenFinal, nuevo.ExamenFinal));

            var detalle = cambios.Count > 0
                ? string.Join(" | ", cambios)
                : "Sin cambios detectados";

            Agregar(session, "UPDATE", nuevo, detalle);
        }

        /// <summary>Registra la eliminación (anulación) de un registro.</summary>
        public static void RegistrarEliminacion(dynamic session, InfoDatosPersonales persona)
        {
            var detalle = string.Format(
                "Registro anulado. P1={0} P2={1} TP={2} Final={3} Total={4}",
                persona.Parcial1, persona.Parcial2, persona.TP,
                persona.ExamenFinal, persona.Total);

            Agregar(session, "DELETE", persona, detalle);
        }

        // ─────────────────────────────────────────────
        // Generación del CSV para descarga
        // ─────────────────────────────────────────────

        /// <summary>
        /// Genera el contenido CSV del log completo de la sesión como array de bytes UTF-8 con BOM.
        /// El BOM (Byte Order Mark) asegura que Excel abra el archivo en UTF-8 correctamente.
        /// </summary>
        public static byte[] GenerarCsvBytes(dynamic session)
        {
            var entradas = ObtenerEntradas(session);

            using (var ms = new MemoryStream())
            using (var sw = new StreamWriter(ms, new System.Text.UTF8Encoding(encoderShouldEmitUTF8Identifier: true)))
            {
                sw.WriteLine(AuditEntry.CsvHeader());

                if (entradas.Count == 0)
                {
                    sw.WriteLine("(Sin eventos registrados en esta sesión)");
                }
                else
                {
                    foreach (var entrada in entradas)
                        sw.WriteLine(entrada.ToCsvLine());
                }

                sw.Flush();
                return ms.ToArray();
            }
        }

        /// <summary>
        /// Genera el log completo de la sesión como archivo Excel (.xlsx) usando ClosedXML.
        /// Incluye una hoja "Log" con filas de colores según acción (INSERT verde, UPDATE amarillo, DELETE rojo)
        /// y una hoja "Resumen" con estadísticas por tipo de acción.
        /// 
        /// NOTA: Este método requiere el paquete NuGet ClosedXML. 
        /// Si no está instalado, use GenerarCsvBytes() como alternativa.
        /// </summary>
        public static byte[] GenerarExcelBytes(dynamic session)
        {
            // Método deshabilitado: ClosedXML no está disponible en este proyecto.
            // Use GenerarCsvBytes() como alternativa o instale ClosedXML:
            // Install-Package ClosedXML
            throw new NotSupportedException(
                "GenerarExcelBytes requiere el paquete ClosedXML. " +
                "Use GenerarCsvBytes() como alternativa o instale ClosedXML via NuGet.");
        }

        /// <summary>
        /// Devuelve el nombre sugerido para el archivo de descarga.
        /// Formato: AuditLog_yyyyMMdd_HHmmss.xlsx
        /// </summary>
        public static string NombreArchivo()
        {
            return string.Format("AuditLog_{0}.csv",
                DateTime.Now.ToString("yyyyMMdd_HHmmss"));
        }

        /// <summary>Devuelve cuántos eventos hay registrados en la sesión actual.</summary>
        public static int CantidadEventos(dynamic session)
        {
            return ObtenerEntradas(session).Count;
        }

        /// <summary>Borra el log de la sesión actual (útil para testing o reset).</summary>
        public static void LimpiarLog(dynamic session)
        {
            session[SessionKey] = new List<AuditEntry>();
        }

        // ─────────────────────────────────────────────
        // Helpers privados
        // ─────────────────────────────────────────────

        private static void Agregar(dynamic session,
                                    string accion,
                                    InfoDatosPersonales persona,
                                    string detalle)
        {
            var lista = ObtenerEntradas(session);
            lista.Add(new AuditEntry
            {
                Timestamp = DateTime.Now,
                Accion    = accion,
                Matricula = persona?.Matricula ?? string.Empty,
                Nombre    = persona?.Nombre    ?? string.Empty,
                Materia   = persona?.Materia   ?? string.Empty,
                Detalle   = detalle
            });
            session[SessionKey] = lista;
        }

        private static List<AuditEntry> ObtenerEntradas(dynamic session)
        {
            try
            {
                if (session[SessionKey] is List<AuditEntry> lista)
                    return lista;
            }
            catch
            {
                // Si no existe o hay error, crear uno nuevo
            }

            var nueva = new List<AuditEntry>();
            session[SessionKey] = nueva;
            return nueva;
        }

        // ── Mejora 4: desglose por tipo de acción ──
        public static Dictionary<string, int> ObtenerDesglose(dynamic session)
        {
            var entradas = ObtenerEntradas(session);
            int countInsert = 0, countUpdate = 0, countDelete = 0;

            foreach (var e in entradas)
            {
                if (e.Accion == "INSERT") countInsert++;
                else if (e.Accion == "UPDATE") countUpdate++;
                else if (e.Accion == "DELETE") countDelete++;
            }

            return new Dictionary<string, int>
            {
                { "INSERT", countInsert },
                { "UPDATE", countUpdate },
                { "DELETE", countDelete }
            };
        }

        // ── Mejora 10: últimas N entradas para el historial en pantalla ––
        public static List<AuditEntry> ObtenerUltimas(dynamic session, int cantidad = 5)
        {
            var entradas = ObtenerEntradas(session);
            var ordenadas = new List<AuditEntry>();

            // Ordenar manualmente sin LINQ lambdas
            foreach (var e in entradas)
            {
                ordenadas.Add(e);
            }

            // Ordenar por timestamp descendente
            for (int i = 0; i < ordenadas.Count - 1; i++)
            {
                for (int j = i + 1; j < ordenadas.Count; j++)
                {
                    if (ordenadas[j].Timestamp > ordenadas[i].Timestamp)
                    {
                        (ordenadas[j], ordenadas[i]) = (ordenadas[i], ordenadas[j]);
                    }
                }
            }

            // Tomar solo los primeros 'cantidad'
            var resultado = new List<AuditEntry>();
            for (int i = 0; i < Math.Min(cantidad, ordenadas.Count); i++)
            {
                resultado.Add(ordenadas[i]);
            }

            return resultado;
        }

        // ── Historial filtrado por alumno (perfil / historial individual) ──
        public static List<AuditEntry> ObtenerPorMatricula(dynamic session, string matricula, int cantidad = int.MaxValue)
        {
            List<AuditEntry> todas = ObtenerUltimas(session, int.MaxValue);
            var filtradas = todas.Where(e =>
                string.Equals(e.Matricula, matricula, StringComparison.OrdinalIgnoreCase)).ToList();

            if (filtradas.Count <= cantidad) return filtradas;
            return filtradas.GetRange(0, cantidad);
        }

        // ── Historial filtrado por alumno y materia (perfil con múltiples materias) ──
        public static List<AuditEntry> ObtenerPorMatriculaYMateria(dynamic session, string matricula, string materia)
        {
            List<AuditEntry> todas = ObtenerUltimas(session, int.MaxValue);
            return todas.Where(e =>
                string.Equals(e.Matricula, matricula, StringComparison.OrdinalIgnoreCase) &&
                string.Equals(e.Materia, materia, StringComparison.OrdinalIgnoreCase)).ToList();
        }

        // ── Persistencia de sesión: exportar/restaurar el log completo ──

        /// <summary>Devuelve todas las entradas del log, ordenadas por fecha descendente.</summary>
        public static List<AuditEntry> ObtenerEntradasRaw(dynamic session)
        {
            return ObtenerUltimas(session, int.MaxValue);
        }

        /// <summary>Reemplaza el log de la sesión actual con las entradas provistas (restauración desde backup).</summary>
        public static void RestaurarEntradas(dynamic session, List<AuditEntry> entradas)
        {
            session[SessionKey] = entradas ?? new List<AuditEntry>();
        }
    }
}
