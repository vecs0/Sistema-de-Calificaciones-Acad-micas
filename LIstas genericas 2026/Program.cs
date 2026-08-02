using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;
using BLL.DTO;
using BLL.Fachada;

// programacion modular - cada metodo tiene una sola responsabilidad
namespace LIstas_genericas_2026
{
    internal class Program
    {
        static void Main(string[] args)

        {
            // Configurar la codificación UTF-8 para caracteres especiales
             Console.OutputEncoding = System.Text.Encoding.UTF8;
           
                  // Intentar ampliar la consola para que quepa la tabla
             try
             {
                 Console.SetWindowSize(Math.Min(160, Console.LargestWindowWidth), 40);
                 Console.SetBufferSize(160, 1000);
             }
            catch
            { 
            
        }

            try
            {
                int cantidad = ObtenerCantidad();

                List<InfoCalificaciones> listaCalificaciones = CargarCalificaciones(cantidad);
                MostrarPlanillaCalificaciones(listaCalificaciones);

                //        int Cantidad = ObtenerCantidad();

                //        List<InfoDatosPersonales> lista = new List<InfoDatosPersonales>();
                //        lista = CargarDatosPersonales(Cantidad);

                //        MostrarDatosPersonales(lista);
                //        MostrarCantidadPorPais(lista);
                //        MostrarCantidadPorCiudad(lista);
                //        MostrarPersonasPorPais(lista);
                //        MostrarMayorYMenorPorPais(lista);


            }
            catch (Exception)
            {

                throw;
            }
        }

            //}

            //public static int ObtenerCantidad()
            //{
            //    int cantidad;
            //    while (true)
            //    {
            //        Console.Write("Ingrese la cantidad de personas a registrar: ");
            //        if (int.TryParse(Console.ReadLine(), out cantidad) && cantidad > 0)
            //        {
            //            return cantidad;
            //        }
            //        Console.WriteLine("Por favor, ingrese un número entero positivo.");
            //    }
            //}

            //public static List<InfoDatosPersonales> CargarDatosPersonales(int Cantidad)
            //{
            //    try
            //    {
            //        InfoDatosPersonales info;
            //        List<InfoDatosPersonales> lista = new List<InfoDatosPersonales>();

            //        for (int i = 0; i < Cantidad; i++)
            //        {
            //            info = new InfoDatosPersonales();
            //            Console.Write("Ingrese su nombre:");
            //            info.Nombre = Console.ReadLine();
            //            Console.Write("Ingrese su apellido:");
            //            info.Apellido = Console.ReadLine();
            //Console.Write("Ingrese su peso:");
            //info.Peso = Convert.ToDouble(Console.ReadLine());
            //Console.Write("Ingrese su altura:");
            //info.Altura = Convert.ToDouble(Console.ReadLine());
            //            Console.Write("Ingrese su fecha de nacimiento (dd/mm/aaaa):");
            //            info.FechaNacimiento = DateTime.ParseExact(Console.ReadLine(), "dd/MM/yyyy", System.Globalization.CultureInfo.InvariantCulture);
            //            Console.Write("Ingrese su país deOrigen:");
            //            info.Pais = Console.ReadLine().ToUpper();
            //            Console.Write("Ingrese su ciudad:");
            //            info.Ciudad = Console.ReadLine().ToUpper();
            //            lista.Add(info);
            //        }

            //        return lista;
            //    }
            //    catch (Exception)
            //    {

            //        throw;
            //    }
            //}
            //public static void MostrarDatosPersonales(List<InfoDatosPersonales> lista)
            //{
            //    Console.WriteLine("\n");
            //    Console.WriteLine("      DATOS PERSONALES INGRESADOS");
            //    Console.WriteLine("\n");

            //    int contador = 1;
            //    foreach (var item in lista)
            //    {
            //        Console.WriteLine($"--- Persona {contador} ---");
            //        Console.WriteLine($"Nombre:   {item.Nombre}");
            //        Console.WriteLine($"Apellido:     {item.Apellido}");
            //        Console.WriteLine($"País:     {item.Pais}");
            //        Console.WriteLine($"Ciudad:      {item.Ciudad}");
            //Console.WriteLine($"Altura:   {item.Altura} m");
            //Console.WriteLine($"Peso: {item.Peso} kg");
            //Console.WriteLine($"IMC:{Calculos.CalcularIMC(item.Peso, item.Altura):F2}");

            //        var edad = Calculos.CalcularEdad(item.FechaNacimiento, DateTime.Now);
            //        Console.WriteLine($"Edad:        {edad.años} años, {edad.meses} meses, {edad.dias} días");
            //        Console.WriteLine($"Mensaje:   ¡Hola, {item.Nombre}! Bienvenido a la programación en C#.\n");

            //        contador++;
            //    }
            //}
            //public static void MostrarCantidadPorPais(List<InfoDatosPersonales> lista)
            //{
            //    Console.WriteLine();
            //    Console.WriteLine("   CANTIDAD DE PERSONAS POR PAÍS");
            //    Console.WriteLine("\n");

            //    var agrupadoPorPais = lista.GroupBy(p => p.Pais)
            //       .OrderBy(g => g.Key);

            //    foreach (var grupo in agrupadoPorPais)
            //    {
            //        Console.WriteLine($"País: {grupo.Key,-15} Cantidad: {grupo.Count()} persona(s)");
            //    }
            //    Console.WriteLine("---------------------------------------------\n");
            //}
            //public static void MostrarCantidadPorCiudad(List<InfoDatosPersonales> lista)
            //{
            //    Console.WriteLine();
            //    Console.WriteLine("   CANTIDAD DE PERSONAS POR CIUDAD");
            //    Console.WriteLine("\n");

            //    var agrupadoPorCiudad = lista.GroupBy(c => c.Ciudad)
            //       .OrderBy(g => g.Key);

            //    foreach (var grupo in agrupadoPorCiudad)
            //    {
            //        Console.WriteLine($"Ciudad: {grupo.Key,-15} Cantidad: {grupo.Count()} persona(s)");
            //    }
            //    Console.WriteLine("--------------------------------------------\n");
            //}
            //public static void MostrarPersonasPorPais(List<InfoDatosPersonales> lista)
            //{
            //    Console.WriteLine();
            //    Console.WriteLine("   PERSONAS AGRUPADAS POR PAÍS");
            //    Console.WriteLine("\n");

            //    var agrupadoPorPais = lista.GroupBy(p => p.Pais)
            //                  .OrderBy(g => g.Key);

            //    foreach (var grupo in agrupadoPorPais)
            //    {
            //        Console.WriteLine($"=== PAÍS: {grupo.Key} ===");
            //        int contador = 1;
            //        foreach (var persona in grupo)
            //        {
            //            Console.WriteLine($"  {contador}. {persona.Nombre} {persona.Apellido} - Ciudad: {persona.Ciudad}");
            //            contador++;
            //        }
            //        Console.WriteLine();
            //    }
            //    Console.WriteLine("--------------------------------------------\n");
            //}
            //sacar de la lista el mayor y menos por edad por pais
            //public static void MostrarMayorYMenorPorPais(List<InfoDatosPersonales> lista)
            //{
            //    Console.WriteLine();
            //    Console.WriteLine("   PERSONAS CON MAYOR Y MENOR DE EDAD POR PAÍS");
            //    Console.WriteLine("\n");
            //    var agrupadoPorPais = lista.GroupBy(p => p.Pais)
            //                  .OrderBy(g => g.Key);
            //    foreach (var grupo in agrupadoPorPais)
            //    {
            //        var mayorEdad = grupo.OrderByDescending(p => Calculos.CalcularEdad(p.FechaNacimiento, DateTime.Now).años).FirstOrDefault();
            //        var menorEdad = grupo.OrderBy(p => Calculos.CalcularEdad(p.FechaNacimiento, DateTime.Now).años).FirstOrDefault();
            //        Console.WriteLine($"=== PAÍS: {grupo.Key} ===");
            //        if (mayorEdad != null)
            //        {
            //            var edadMayor = Calculos.CalcularEdad(mayorEdad.FechaNacimiento, DateTime.Now);
            //            Console.WriteLine($"  Mayor Edad: {mayorEdad.Nombre} {mayorEdad.Apellido} - Edad: {edadMayor.años} años, {edadMayor.meses} meses, {edadMayor.dias} días");
            //        }
            //        if (menorEdad != null)
            //        {
            //            var edadMenor = Calculos.CalcularEdad(menorEdad.FechaNacimiento, DateTime.Now);
            //            Console.WriteLine($"  Menor Edad: {menorEdad.Nombre} {menorEdad.Apellido} - Edad: {edadMenor.años} años, {edadMenor.meses} meses, {edadMenor.dias} días");
            //        }
            //        Console.WriteLine();
            //    }

            //}

            public static int ObtenerCantidad()
        {
            int cantidad;
            while (true)
            {
                Console.Write("Ingrese la cantidad de estudiantes a registrar: ");
                if (int.TryParse(Console.ReadLine(), out cantidad) && cantidad > 0)
                {
                    return cantidad;
                }
                Console.WriteLine("Por favor, ingrese un número entero positivo.");
            }
        }

        public static List<InfoCalificaciones> CargarCalificaciones(int cantidad)
        {
            List<InfoCalificaciones> lista = new List<InfoCalificaciones>();

            for (int i = 0; i < cantidad; i++)
            {
                InfoCalificaciones info = new InfoCalificaciones();
                info.Nro = i + 1;

                Console.Write($"\n--- Estudiante {i + 1} ---\n");
                Console.Write("Ingrese la matrícula: ");
                info.Matricula = Console.ReadLine();

                Console.Write("Ingrese el nombre: ");
                info.Nombre = Console.ReadLine();

                info.Parcial1 = ObtenerCalificacion("Ingrese Parcial 1 (máximo 20 puntos): ", 0, 20);
                info.Parcial2 = ObtenerCalificacion("Ingrese Parcial 2 (máximo 20 puntos): ", 0, 20);
                info.TrabajosPracticos = ObtenerCalificacion("Ingrese Trabajos Prácticos (máximo 20 puntos): ", 0, 20);
                info.ExamenFinal = ObtenerCalificacion("Ingrese Examen Final (máximo 50 puntos): ", 0, 50);

                info.Total = Calculos.CalcularTotal(info.Parcial1, info.Parcial2, info.TrabajosPracticos, info.ExamenFinal);
                info.NotaFinal = Calculos.CalcularNotaFinal(info.Total);
                info.NotaFinalLetras = Calculos.ObtenerNotaFinalLetras(info.NotaFinal);
                info.Situacion = Calculos.ObtenerSituacion(info.NotaFinal);

                lista.Add(info);
            }

            return lista;
        }

        public static decimal ObtenerCalificacion(string mensaje, decimal minimo, decimal maximo)
        {
            while (true)
            {
                Console.Write(mensaje);
                if (decimal.TryParse(Console.ReadLine(), out decimal calificacion) &&
                    Calculos.ValidarRango(calificacion, minimo, maximo))
                {
                    return calificacion;
                }
                Console.WriteLine($"Por favor, ingrese un número entre {minimo} y {maximo}.");
            }
        }

        public static void MostrarPlanillaCalificaciones(List<InfoCalificaciones> lista)
        {
            Console.OutputEncoding = System.Text.Encoding.UTF8;

          // Obtener el ancho actual de la consola y restar margen de seguridad
            int anchoConsola = Console.WindowWidth - 2;
  
          // Reducir aún más si es necesario para evitar wrap
            if (anchoConsola > 140)
            anchoConsola = 140;
            
            string separador = new string('─', anchoConsola);
            string separadorDoble = new string('═', anchoConsola);
            string titulo = "LP2 - PLANILLA DE CALIFICACIONES";

            Console.WriteLine("\n");
            Console.WriteLine(separadorDoble);
            Console.WriteLine(titulo.PadLeft((anchoConsola + titulo.Length) / 2));
            Console.WriteLine(separadorDoble);

     // Encabezados con ancho adaptado
        Console.WriteLine(
            "{0,-4} {1,-10} {2,-15} {3,-8} {4,-8} {5,-8} {6,-10} {7,-6} {8,-9} {9,-8} {10,-10}",
            "Nro", "Matrícula", "Nombre", "Parcial1", "Parcial2", "Trabajos", "Ex.Final", "Total", "NotaFinal", "Letras", "Situación");

            Console.WriteLine(separador);

            foreach (var estudiante in lista)
            {
                Console.WriteLine(
                "{0,-4} {1,-10} {2,-15} {3,-8:F2} {4,-8:F2} {5,-8:F2} {6,-10:F2} {7,-6:F2} {8,-9:F2} {9,-8} {10,-10}",
                estudiante.Nro,
                estudiante.Matricula,
                estudiante.Nombre,
                estudiante.Parcial1,
                estudiante.Parcial2,
                estudiante.TrabajosPracticos,
                estudiante.ExamenFinal,
                estudiante.Total,
                estudiante.NotaFinal,
                estudiante.NotaFinalLetras,
                estudiante.Situacion);
            }

        Console.WriteLine(separadorDoble);
        }
    }
}

        

