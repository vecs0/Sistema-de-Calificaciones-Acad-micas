//using System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.DTO
{
    [Serializable]
    public class InfoCalificaciones
    {
        public int Nro { get; set; }
        public string Matricula { get; set; }
        public string Nombre { get; set; }
        public decimal Parcial1 { get; set; }
        public decimal Parcial2 { get; set; }
        public decimal TrabajosPracticos { get; set; }
        public decimal ExamenFinal { get; set; }
        public decimal Total { get; set; }
        public decimal NotaFinal { get; set; }
        public string NotaFinalLetras { get; set; }
        public string Situacion { get; set; }
    }
}
