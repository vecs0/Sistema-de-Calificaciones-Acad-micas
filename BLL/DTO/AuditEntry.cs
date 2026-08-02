using System;

namespace BLL.DTO
{
    /// <summary>
    /// Representa una entrada individual en el log de auditoría.
    /// </summary>
    [Serializable]
    public class AuditEntry
    {
        /// <summary>Fecha y hora exacta del evento.</summary>
        public DateTime Timestamp { get; set; }

        /// <summary>Tipo de acción: INSERT | UPDATE | DELETE.</summary>
        public string Accion { get; set; }

        /// <summary>Matrícula del estudiante afectado.</summary>
        public string Matricula { get; set; }

        /// <summary>Nombre del estudiante afectado.</summary>
        public string Nombre { get; set; }

        /// <summary>Materia del registro afectado.</summary>
        public string Materia { get; set; }

        /// <summary>
        /// Detalle del cambio realizado.
        /// Para INSERT: valores ingresados.
        /// Para UPDATE: "Campo: [anterior] → [nuevo]".
        /// Para DELETE: "Registro anulado".
        /// </summary>
        public string Detalle { get; set; }

        /// <summary>
        /// Convierte la entrada a una línea CSV correctamente escapada.
        /// Los campos que contengan comas o comillas se encierran en comillas dobles.
        /// </summary>
        public string ToCsvLine()
        {
            return string.Join(",",
                EscapeCsv(Timestamp.ToString("yyyy-MM-dd HH:mm:ss")),
                EscapeCsv(Accion),
                EscapeCsv(Matricula),
                EscapeCsv(Nombre),
                EscapeCsv(Materia),
                EscapeCsv(Detalle)
            );
        }

        /// <summary>Encabezado CSV para la primera línea del archivo.</summary>
        public static string CsvHeader()
        {
            return "Timestamp,Accion,Matricula,Nombre,Materia,Detalle";
        }

        private static string EscapeCsv(string value)
        {
            if (string.IsNullOrEmpty(value)) return string.Empty;
            // Si contiene coma, comilla doble o salto de línea → envolver en comillas
            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n"))
                return "\"" + value.Replace("\"", "\"\"") + "\"";
            return value;
        }
    }
}
