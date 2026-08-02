using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BLL.Fachada
{
    public class Calculos
    {
        //public static double CalcularIMC(double peso, double altura)
        //{
        //    if (altura <= 0)
        //    {
        //        throw new ArgumentException("La altura debe ser mayor que cero.");
        //    }
        //    return peso / (altura * altura);
        //}
        //public static (int años, int meses, int dias) CalcularEdad(DateTime fechaNacimiento, DateTime fechaReferencia)
        //{
        //    if (fechaNacimiento > fechaReferencia)
        //        throw new ArgumentException("La fecha de nacimiento no puede ser posterior a la fecha de referencia.");

        //    int años = fechaReferencia.Year - fechaNacimiento.Year;
        //    int meses = fechaReferencia.Month - fechaNacimiento.Month;
        //    int dias = fechaReferencia.Day - fechaNacimiento.Day;

        // Ajustar si el día es negativo
        //if (dias < 0)
        //{
        //    meses--;
        //    // Obtener días del mes anterior
        //    DateTime mesAnterior = fechaReferencia.AddMonths(-1);
        //    dias += DateTime.DaysInMonth(mesAnterior.Year, mesAnterior.Month);
        //}

        // Ajustar si el mes es negativo
        //        if (meses < 0)
        //        {
        //            años--;
        //            meses += 12;
        //        }

        //        return (años, meses, dias);
        //    }



        // Validar que el número sea positivo
        //public static bool ValidarNumeroPositivo(decimal numero)
        //{
        //    return numero >= 0;
        //}

        // Validar que esté dentro del rango permitido (0-20 para parciales, etc.)
        //public static bool ValidarRango(decimal numero, decimal minimo, decimal maximo)
        //{
        //    return numero >= minimo && numero <= maximo;
        //}

        // Calcular total de calificación
        //public static decimal CalcularTotal(decimal parcial1, decimal parcial2, decimal trabajosPracticos, decimal examenFinal)
        //{
        //    if (!ValidarNumeroPositivo(parcial1) || !ValidarNumeroPositivo(parcial2) ||
        //        !ValidarNumeroPositivo(trabajosPracticos) || !ValidarNumeroPositivo(examenFinal))
        //    {
        //        throw new ArgumentException("Todos los valores deben ser números positivos.");
        //    }

        //    return parcial1 + parcial2 + trabajosPracticos + examenFinal;
        //}

        // Calcular nota final basada en el total
        //public static decimal CalcularNotaFinal(decimal total)
        //{
        //    if (!ValidarNumeroPositivo(total))
        //    {
        //        throw new ArgumentException("El total debe ser un número positivo.");
        //    }

        // Suponiendo que el máximo es 100 y se convierte a escala de 10
        //    return (total / 100) * 10;
        //}

        // Obtener la nota final en letras
        //public static string ObtenerNotaFinalLetras(decimal notaFinal)
        //{
        //    if (notaFinal >= 9)
        //        return "Diez";
        //    else if (notaFinal >= 8)
        //        return "Nueve";
        //    else if (notaFinal >= 7)
        //        return "Ocho";
        //    else if (notaFinal >= 6)
        //        return "Siete";
        //    else if (notaFinal >= 5)
        //        return "Seis";
        //    else if (notaFinal >= 4)
        //        return "Cinco";
        //    else
        //        return "Cuatro";
        //}

        // Obtener la situación (Aprobado/Reprobado)
        //public static string ObtenerSituacion(decimal notaFinal)
        //{
        //    return notaFinal >= 4 ? "Aprobado" : "Reprobado";
        //}


        /// <summary>
        /// Calcula la edad en años basada en la fecha de nacimiento
        /// </summary>
        public static int CalcularEdad(DateTime fechaNacimiento)
        {
            if (fechaNacimiento == DateTime.MinValue)
                return 0;

            if (fechaNacimiento > DateTime.Today)
                throw new ArgumentException("La fecha de nacimiento no puede ser posterior a hoy.");

            DateTime hoy = DateTime.Today;
            int edad = hoy.Year - fechaNacimiento.Year;

            // Restar 1 si el cumpleaños aún no ha ocurrido este año
            if (fechaNacimiento.Date > hoy.AddYears(-edad))
                edad--;

            return edad;
        }

        /// <summary>
        /// Valida que una calificación esté dentro del rango permitido
        /// </summary>
        public static bool ValidarCalificacion(decimal valor, decimal minimo, decimal maximo)
        {
            return valor >= minimo && valor <= maximo;
        }

        /// <summary>
        /// Calcula el total de calificación (suma de Parcial1 + Parcial2 + TP + ExamenFinal)
        /// </summary>
        public static decimal CalcularTotal(decimal parcial1, decimal parcial2, decimal tp, decimal examenFinal)
        {
            return parcial1 + parcial2 + tp + examenFinal;
        }

        /// <summary>
        /// Calcula el promedio basado en el total (máximo 100 puntos)
        /// convertido a escala de 1 a 5
        /// </summary>
        public static decimal CalcularPromedio(decimal total)
        {
            return Math.Round((total / 100m) * 5m, 2);
        }

        /// <summary>
        /// Valida que un valor esté dentro de un rango específico
        /// </summary>
        public static bool ValidarRango(decimal numero, decimal minimo, decimal maximo)
        {
            return numero >= minimo && numero <= maximo;
        }

        /// <summary>
        /// Calcula la nota final convertida a escala de 1 a 5
        /// </summary>
        public static decimal CalcularNotaFinal(decimal total)
        {
            return Math.Round((total / 100m) * 5m, 2);
        }

        /// <summary>
        /// Obtiene la nota final en letras (escala 1-5)
        /// </summary>
        public static string ObtenerNotaFinalLetras(decimal notaFinal)
        {
            if (notaFinal >= 4.5m)
                return "Cinco";
            else if (notaFinal >= 3.5m)
                return "Cuatro";
            else if (notaFinal >= 2.5m)
                return "Tres";
            else if (notaFinal >= 1.5m)
                return "Dos";
            else
                return "Uno";
        }

        /// <summary>
        /// Obtiene la situación (Aprobado/Reprobado)
        /// Aprobado si la nota final es >= 3 (equivalente a 60% del puntaje máximo)
        /// </summary>
        public static string ObtenerSituacion(decimal notaFinal)
        {
            return notaFinal >= 3m ? "Aprobado" : "Reprobado";
        }

    }
}

