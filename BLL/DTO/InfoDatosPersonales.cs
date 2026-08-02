using BLL.Fachada;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.DTO
{
    [Serializable]
    public class InfoDatosPersonales
    {
        public string Matricula { get; set; }
        public string Nombre { get; set; }
        public string Materia { get; set; }
        public decimal Parcial1 { get; set; }
        public decimal Parcial2 { get; set; }
        public decimal TP { get; set; }
        public decimal ExamenFinal { get; set; }

        /// <summary>
        /// Retorna el nombre completo (igual al campo Nombre)
        /// </summary>
        public string NombreCompleto
        {
            get
            {
                return Nombre ?? string.Empty;
            }
        }

        /// <summary>
        /// Calcula el total de calificación (suma de todas las notas)
        /// </summary>
        public decimal Total
        {
            get
            {
                try
                {
                    return Calculos.CalcularTotal(Parcial1, Parcial2, TP, ExamenFinal);
                }
                catch
                {
                    return 0;
                }
            }
        }

        /// <summary>
        /// Calcula el promedio de la calificación
        /// </summary>
        public decimal Promedio
        {
            get
            {
                try
                {
                    return Calculos.CalcularPromedio(Total);
                }
                catch
                {
                    return 0;
                }
            }
        }

        public string PromedioLetras
        {
            get
            {
                try { return Calculos.ObtenerNotaFinalLetras(Promedio); }
                catch { return "Uno"; }
            }
        }

        public string Situacion
        {
            get
            {
                try { return Calculos.ObtenerSituacion(Promedio); }
                catch { return "Reprobado"; }
            }
        }

    }
}
