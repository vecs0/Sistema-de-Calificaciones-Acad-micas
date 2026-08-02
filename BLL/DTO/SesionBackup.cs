using System;
using System.Collections.Generic;

namespace BLL.DTO
{
    /// <summary>
    /// Snapshot completo de la sesión (alumnos + log de auditoría) para
    /// exportar/restaurar como archivo JSON desde el navegador.
    /// </summary>
    [Serializable]
    public class SesionBackup
    {
        public string Version { get; set; } = "1.0";
        public DateTime FechaExportacion { get; set; }
        public List<InfoDatosPersonales> Personas { get; set; }
        public List<AuditEntry> AuditLog { get; set; }
    }
}
