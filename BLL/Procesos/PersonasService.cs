using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using BLL.DTO;
using BLL.Fachada;

namespace BLL.Procesos
{
    public class PersonasService
    {
        public static readonly List<string> MateriasValidas = new List<string>
        {
            "Lenguaje de Programaci\u00f3n 2",
            "Historia y Filosof\u00eda de la Ciencia",
            "\u00c9tica Personal",
            "F\u00edsica 3",
            "Matem\u00e1tica para Inform\u00e1ticos"
        };

        private static readonly Dictionary<string, List<string>> MateriaAliases =
            new Dictionary<string, List<string>>(StringComparer.OrdinalIgnoreCase)
            {
                { "Lenguaje de Programación 2",       new List<string> { "Lenguaje de Programacion 2", "Prog. 2", "Lenguaje Prog. 2" } },
                { "Historia y Filosofía de la Ciencia", new List<string> { "Historia y Filosofia de la Ciencia", "Hist. Filosofia", "Hist. Filosofía" } },
                { "Ética Personal",                    new List<string> { "Etica Personal" } },
                { "Física 3",                         new List<string> { "Fisica 3" } },
                { "Matemática para Informáticos",      new List<string> { "Matematica para Informaticos", "Matem\u00e1tica para Inform\u00e1tico", "Matematica para Informatico", "Mat. Inform\u00e1ticos", "Mat. Informaticos" } }
            };

        private static string QuitarAcentos(string texto)
        {
            if (string.IsNullOrWhiteSpace(texto)) return texto;
            string formD = texto.Normalize(NormalizationForm.FormD);
            var sb = new StringBuilder();
            for (int i = 0; i < formD.Length; i++)
            {
                var cat = System.Globalization.CharUnicodeInfo.GetUnicodeCategory(formD[i]);
                if (cat != System.Globalization.UnicodeCategory.NonSpacingMark)
                    sb.Append(formD[i]);
            }
            return sb.ToString().Normalize(NormalizationForm.FormC);
        }

        public static bool EsMateriaValida(string materia)
        {
            if (string.IsNullOrWhiteSpace(materia)) return false;
            string input = QuitarAcentos(materia.Trim());
            if (MateriasValidas.Any(m => string.Equals(QuitarAcentos(m), input, StringComparison.OrdinalIgnoreCase)))
                return true;
            return MateriaAliases.Values.Any(alias => alias.Any(a => string.Equals(QuitarAcentos(a), input, StringComparison.OrdinalIgnoreCase)));
        }

        public static string NormalizarMateria(string materia)
        {
            if (string.IsNullOrWhiteSpace(materia)) return materia;
            string input = QuitarAcentos(materia.Trim());
            var match = MateriasValidas.FirstOrDefault(m => string.Equals(QuitarAcentos(m), input, StringComparison.OrdinalIgnoreCase));
            if (match != null) return match;
            foreach (var kvp in MateriaAliases)
            {
                if (kvp.Value.Any(a => string.Equals(QuitarAcentos(a), input, StringComparison.OrdinalIgnoreCase)))
                    return kvp.Key;
            }
            return materia;
        }
        public List<InfoDatosPersonales> ProcesarPersonas(List<InfoDatosPersonales> personas)
        {
            try
            {
                if (personas == null || personas.Count == 0)
                    return new List<InfoDatosPersonales>();
                return personas;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en ProcesarPersonas: " + ex.Message);
                throw;
            }
        }

        public bool ValidarPersona(InfoDatosPersonales persona)
        {
            if (persona == null)
                return false;
            return !string.IsNullOrWhiteSpace(persona.Matricula) &&
                   !string.IsNullOrWhiteSpace(persona.Nombre)    &&
                   !string.IsNullOrWhiteSpace(persona.Materia)   &&
                   ValidarCalificaciones(persona);
        }

        public bool ValidarCalificaciones(InfoDatosPersonales persona)
        {
            if (persona == null)
                return false;
            return Calculos.ValidarCalificacion(persona.Parcial1, 0, 20) &&
                   Calculos.ValidarCalificacion(persona.Parcial2, 0, 20) &&
                   Calculos.ValidarCalificacion(persona.TP, 0, 10) &&
                   Calculos.ValidarCalificacion(persona.ExamenFinal, 0, 50);
        }

        public List<InfoDatosPersonales> BuscarYOrdenar(
            List<InfoDatosPersonales> personas,
            string textoBusqueda = "",
            string filtroMateria = "",
            string criterioOrden = "Nombre",
            bool ascendente = true)
        {
            try
            {
                if (personas == null || personas.Count == 0)
                    return new List<InfoDatosPersonales>();
                string texto = string.IsNullOrWhiteSpace(textoBusqueda) ? "" : textoBusqueda.Trim().ToLowerInvariant();
                string materia = string.IsNullOrWhiteSpace(filtroMateria) || filtroMateria.Trim() == "Todas" ? "" : filtroMateria.Trim();
                IEnumerable<InfoDatosPersonales> resultado = personas;
                if (!string.IsNullOrEmpty(texto))
                {
                    resultado = resultado.Where(p =>
                        (p.Matricula ?? "").Trim().ToLowerInvariant().Contains(texto) ||
                        (p.Nombre ?? "").Trim().ToLowerInvariant().Contains(texto) ||
                        (p.Materia ?? "").Trim().ToLowerInvariant().Contains(texto));
                }
                if (!string.IsNullOrEmpty(materia))
                    resultado = resultado.Where(p => string.Equals((p.Materia ?? "").Trim(), materia, StringComparison.OrdinalIgnoreCase));
                switch (criterioOrden.ToLowerInvariant())
                {
                    case "matricula":
                        resultado = ascendente ? resultado.OrderBy(p => p.Matricula) : resultado.OrderByDescending(p => p.Matricula);
                        break;
                    case "total":
                        resultado = ascendente ? resultado.OrderBy(p => p.Total) : resultado.OrderByDescending(p => p.Total);
                        break;
                    case "promedio":
                        resultado = ascendente ? resultado.OrderBy(p => p.Promedio) : resultado.OrderByDescending(p => p.Promedio);
                        break;
                    case "materia":
                        resultado = ascendente ? resultado.OrderBy(p => p.Materia) : resultado.OrderByDescending(p => p.Materia);
                        break;
                    default:
                        resultado = ascendente ? resultado.OrderBy(p => p.Nombre) : resultado.OrderByDescending(p => p.Nombre);
                        break;
                }
                return resultado.ToList();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en BuscarYOrdenar: " + ex.Message);
                return new List<InfoDatosPersonales>();
            }
        }

        public EstadisticasClase CalcularEstadisticas(List<InfoDatosPersonales> personas)
        {
            try
            {
                if (personas == null || personas.Count == 0)
                    return new EstadisticasClase();

                // Mejor calificación (más alta)
                var registroMejor = personas.OrderByDescending(p => p.Promedio).FirstOrDefault();
                decimal mejorPromedio = registroMejor?.Promedio ?? 0;
                var alumnMejor = registroMejor?.NombreCompleto ?? "N/A";
                var materiaMejor = registroMejor?.Materia ?? "";
                var situacionMejor = registroMejor?.Situacion ?? "";

                // Peor calificación: solo si hay alguien con promedio < 3
                decimal peorPromedio = 0;
                string alumnoPeor = "N/A";
                string materiaPeor = "";
                string situacionPeor = "";
                var conPromedioMenor3 = personas.FirstOrDefault(p => p.Promedio < 3);

                if (conPromedioMenor3 != null)
                {
                    var registroPeor = personas.OrderBy(p => p.Promedio).FirstOrDefault();
                    peorPromedio = registroPeor?.Promedio ?? 0;
                    alumnoPeor = registroPeor?.NombreCompleto ?? "N/A";
                    materiaPeor = registroPeor?.Materia ?? "";
                    situacionPeor = registroPeor?.Situacion ?? "";
                }

                return new EstadisticasClase
                {
                    PromedioClase = personas.Average(p => p.Promedio),
                    MejorCalificacion = mejorPromedio,
                    PeorCalificacion = peorPromedio,
                    AlumnoMejorCalificacion = alumnMejor,
                    AlumnoPeorCalificacion = alumnoPeor,
                    MateriaMejorCalificacion = materiaMejor,
                    SituacionMejorCalificacion = situacionMejor,
                    MateriaPeorCalificacion = materiaPeor,
                    SituacionPeorCalificacion = situacionPeor
                };
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error en CalcularEstadisticas: " + ex.Message);
                return new EstadisticasClase();
            }
        }

    }

    public class EstadisticasClase
    {
        public decimal PromedioClase { get; set; }
        public decimal MejorCalificacion { get; set; }
        public decimal PeorCalificacion { get; set; }
        public string AlumnoMejorCalificacion { get; set; }
        public string AlumnoPeorCalificacion { get; set; }
        public string MateriaMejorCalificacion { get; set; }
        public string SituacionMejorCalificacion { get; set; }
        public string MateriaPeorCalificacion { get; set; }
        public string SituacionPeorCalificacion { get; set; }
    }

}