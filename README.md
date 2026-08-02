# 🎓 Sistema de Calificaciones Académicas

> Listas Genéricas 2026 — Sistema web de gestión académica

## 📌 Resumen del proyecto

**Sistema de Calificaciones Académicas** (Listas Genéricas 2026) es un sistema web de gestión académica para instituciones de educación superior. Permite administrar registros de estudiantes con sus calificaciones (P1/P2 0–20, TP 0–10, Examen Final 0–50), con cálculos automáticos de totales y promedios, auditoría completa de operaciones CRUD, exportación a Excel/CSV y gráficos estadísticos.

El sistema soporta **5 materias**: Lenguaje de Programación 2, Historia y Filosofía de la Ciencia, Ética Personal, Física 3 y Matemática para Informáticos. Localizado para `es-AR` · `America/Buenos_Aires` · `UTF-8`.

## ⚙️ Stack tecnológico

| Capa | Tecnología |
|---|---|
| Framework | .NET Framework 4.7.2 |
| Lenguaje | C# 7.3+ |
| UI Framework | Bootstrap 5.2.3 |
| Base de datos | SQL Server LocalDB |
| Dependencias | NuGet (`packages.config`) |

### Dependencias principales

```xml
<package id="ClosedXML"            version="0.105.0" />
<package id="Newtonsoft.Json"      version="13.0.3" />
<package id="Chart.js"              version="4.4.0" />
<package id="Bootstrap"             version="5.2.3" />
<package id="jQuery"                version="3.7.0" />
<package id="Microsoft.CodeDom.Providers.DotNetCompilerPlatform" version="2.0.1" />
```

## 🏗️ Arquitectura del proyecto

Arquitectura 3 capas clásica: **Presentación** (ASPX + Site.Master), **Lógica de Negocio** (BLL con Fachada, DTOs, Servicios), **Datos** (SQL Server LocalDB con procedimientos almacenados).

### Estructura

Solución `LIstas genericas 2026` (3 proyectos)

```
LIstas genericas 2026.sln
├── 📁 Datos/                  // Capa de Presentación (proyecto web)
│   ├── Site.Master            // Layout global
│   ├── Default.aspx           // Página de inicio
│   ├── Tect.aspx              // UI principal (GridView)
│   ├── Tect.aspx.cs           // Code-behind con eventos
│   ├── Contact.aspx           // Grilla de Ordenamiento (doc)
│   ├── About.aspx             // Documentación
│   ├── Imprimir.aspx          // Vista de impresión
│   ├── Content/               // Estilos globales + Bootstrap 5.2.3
│   └── Web.config             // Configuración de la aplicación
│
├── 📁 BLL/                    // Capa de Negocio
│   ├── Fachada/
│   │   ├── Calculos.cs        // Cálculos de total/promedio/letras
│   │   ├── AuditLogger.cs     // Registro de auditoría de sesión
│   │   └── PersonasService.cs // Validación de materias
│   └── DTO/
│       ├── InfoDatosPersonales.cs
│       ├── AuditEntry.cs
│       └── InfoCalificaciones.cs
│
└── 📁 LIstas genericas 2026/  // Proyecto de consola (entry-point / pruebas)
    ├── Program.cs
    └── ProgramBase.cs
```

## 🗄️ Esquema de base de datos

Base de datos **ListasGenericas2026** en SQL Server LocalDB (`(localdb)\mssqllocaldb`). Dos tablas principales:

### Tabla `Personas`

```sql
CREATE TABLE Personas (
    Id            INT           IDENTITY(1,1) PRIMARY KEY,
    Matricula     NVARCHAR(50)   NOT NULL,
    Nombre        NVARCHAR(150)  NOT NULL,
    Materia       NVARCHAR(100)  NOT NULL,
    Parcial1      DECIMAL(4,2)  NOT NULL,
    Parcial2      DECIMAL(4,2)  NOT NULL,
    TP            DECIMAL(4,2)  NOT NULL,
    ExamenFinal   DECIMAL(5,2)  NOT NULL,
    Total         DECIMAL(5,2)  NOT NULL,
    Promedio      DECIMAL(4,2)  NOT NULL,
    FechaRegistro DATETIME2     NOT NULL
);
```

### Tabla `AuditLog`

```sql
CREATE TABLE AuditLog (
    Id         INT          IDENTITY(1,1) PRIMARY KEY,
    Accion     NVARCHAR(20)  NOT NULL,           -- INSERT / UPDATE / DELETE
    Matricula  NVARCHAR(50)  NOT NULL,
    Nombre     NVARCHAR(150) NOT NULL,
    Detalle    NVARCHAR(500) NULL,
    Usuario    NVARCHAR(100) NULL,
    FechaHora  DATETIME2    NOT NULL
);
```

## ⚡ Procedimientos almacenados

Todos los accesos a datos se realizan mediante procedimientos almacenados en lugar de SQL inline, mejorando seguridad y mantenibilidad.

| Procedimiento | Descripción |
|---|---|
| `Personas_Insert` | Inserta nueva persona |
| `Personas_Update` | Actualiza datos existentes |
| `Personas_Delete` | Elimina registro por Id |
| `Personas_GetAll` | Obtiene todas las personas |
| `Personas_GetByMatricula` | Busca por matrícula |
| `AuditLog_Insert` | Registra evento de auditoría |
| `AuditLog_GetAll` | Obtiene historial de auditoría |
| `AuditLog_GetStats` | Estadísticas por tipo de operación |

## ∑ Lógica de cálculos

La clase `Calculos.cs` en `BLL/Fachada/` contiene toda la lógica matemática del sistema.

```csharp
// Calcula Total = P1 + P2 + TP + ExamenFinal
public static decimal CalcularTotal(decimal p1, decimal p2,
    decimal tp, decimal ef)
    => p1 + p2 + tp + ef;

// Calcula Promedio = Total / 20 (escala 0-5)
public static decimal CalcularPromedio(decimal total)
    => Math.Round(total / 20m, 2);

// Convierte promedio numérico a letra
public static string ObtenerNotaFinalLetras(decimal promedio)
{
    if (promedio < 1m)  return "Malo";
    if (promedio < 2m)  return "Deficiente";
    if (promedio < 3m)  return "Regular";
    if (promedio < 4m)  return "Bueno";
    if (promedio < 5m)  return "Excelente";
    return "Excelente";
}

// Determina situación académica
public static string ObtenerSituacion(decimal promedio)
    => promedio >= 2m ? "Aprobado" : "Reprobado";
```

## ◉ Sistema de auditoría

Cada operación CRUD (Insert, Update, Delete) registra automáticamente un evento en la tabla `AuditLog`. El `AuditLogger` y el GridView con historial permiten visualizar y auditar todos los cambios.

| Operación | Evento |
|---|---|
| **+** Altas | `INSERT` |
| **↻** Actualizaciones | `UPDATE` |
| **✕** Eliminaciones | `DELETE` |

La estrategia de almacenamiento del log de sesión es en memoria (diccionario en `Session`), y al descargar se generan los bytes CSV/Excel en memoria (`MemoryStream`) sin escribir en disco del servidor, evitando problemas de permisos en IIS.

## ⬇️ Exportación a Excel / CSV

Usa **ClosedXML 0.105.0** para exportar a Excel y `StringBuilder` para CSV. Respeta los filtros activos al exportar.

> La exportación filtra por los mismos criterios que la UI: si hay búsqueda o filtro de materia, solo exporta los registros visibles.

## ▦ Distribución de promedios — Mosaico

Visualización de la distribución de promedios mediante una cuadrícula de **5 filas × 8 celdas**. Cada fila representa un rango (0–1, 1–2, 2–3, 3–4, 4–5) y cada celda rellena representa un estudiante en ese rango. Incluye tooltip al hover, contador y porcentaje por fila, y leyenda inferior.

> Los tooltips usan `position: fixed` sobre `document.body`, lo que evita problemas de clipping por `overflow: hidden` del panel.

### Archivos involucrados

| Archivo | Líneas | Descripción |
|---|---|---|
| `Datos/Tect.aspx` | 98–115 | CSS del mosaico (`.mosaic-grid/row/cells/cell/count/pct/legend`) |
| `Datos/Tect.aspx` | 373–393 | HTML del panel `.chart-panel` con `#mosaicGrid` y leyenda |
| `Datos/Tect.aspx` | ~510–700 | JS `inicializarGrafico()` — lee GridView, extrae promedios, renderiza mosaico |
| `Datos/Content/site-override.css` | ~1380–1425 | CSS base del mosaico con `!important` |

### Colores por rango

```javascript
var CONFIG = [
  { label: '0–1', color: '#e05555' },   // rojo
  { label: '1–2', color: '#e08840' },   // naranja
  { label: '2–3', color: '#e0c040' },   // amarillo
  { label: '3–4', color: '#68c464' },   // verde
  { label: '4–5', color: '#2dd4a0' }    // teal
];
// Extracción de promedio desde cells[8] que contiene "3,43Cuatro":
var m = raw.replace(',', '.').match(/^(\d+(?:\.\d+)?)/);
var val = m ? parseFloat(m[1]) : NaN;
```

## ◉ Últimos eventos de auditoría — Panel

Panel colapsable que muestra las **últimas 5 entradas** del log de sesión actual, sin necesidad de descargar el Excel. Muestra: tipo de acción (INSERT / UPDATE / DELETE), nombre del estudiante, materia, detalle del cambio y hora exacta. Se actualiza automáticamente tras cada operación (postback).

> **Diferencia con el botón Log:** el panel muestra solo los últimos 5 eventos en pantalla. El botón **Log** descarga un Excel/CSV con todos los eventos de la sesión. Los datos viven en `Session["AuditLog"]` — se pierden al cerrar el navegador.

### Flujo de datos

```
Datos/Tect.aspx.cs + AuditLogger.cs
// 1. El usuario acciona INSERT / UPDATE / DELETE
btn_Click()           → AuditLogger.RegistrarInsercion(Session, info)
btnGuardarEdicion()   → AuditLogger.RegistrarActualizacion(Session, snapshot, actualizado)
EliminarRegistro()    → AuditLogger.RegistrarEliminacion(Session, personaAEliminar)

// 2. AuditLogger.Agregar() crea AuditEntry y lo guarda en Session
Session["AuditLog"] = lista;   // List<AuditEntry>

// 3. Page_PreRender genera el HTML y lo asigna al Literal
protected void Page_PreRender(object sender, EventArgs e)
    => litAuditEntries.Text = RenderAuditEntries();
```

## ✓ Mejoras implementadas

De un sistema base funcional, se implementaron las siguientes mejoras para alcanzar una aplicación profesional:

| # | Mejora | Detalle |
|---|---|---|
| 1 | **Paginación** | `AllowPaging=true` · 10 reg/pág · GridDatos |
| 2 | **RangeValidator** | Validación por campo: P1/P2 0–20, TP 0–10, EF 0–50 |
| 3 | **Columna Situación** | TemplateField · Aprobado / Reprobado con colores |
| 4 | **Desglose auditoría** | strip INSERT / UPDATE / DELETE en tiempo real |
| 5 | **Resaltar fila editada** | JS `resaltarFilaEditando()` via ScriptManager |
| 6 | **Mosaico distribución** | 5 rangos × 8 celdas · tooltips `position:fixed` · sin Chart.js |
| 7 | **Exportar filtrados** | ClosedXML · Excel + CSV con filtros activos |
| 8 | **Nota en letras** | `ObtenerNotaFinalLetras()` en BLL/Fachada (midpoints) |
| 9 | **Búsqueda tiempo real** | AutoPostBack · `txtBuscar` con TextChanged |
| 10 | **Panel historial audit** | `litAuditEntries` · `toggleAudit()` · h-dot coloreados |

> La mejora **#6** reemplaza la versión anterior basada en Chart.js 4.4.0. El nuevo mosaico no requiere dependencias externas y usa JS vanilla con `cell.style.setProperty('background', color, 'important')` para sobrescribir reglas CSS con `!important`.

> La mejora **#10** usa `<asp:Literal ID="litAuditEntries">` poblado en `Page_PreRender`, reemplazando el Repeater anterior.

## 🆕 Materias múltiples y diseño compacto

Un mismo estudiante (misma Matrícula) puede tener un **registro por cada materia** que cursa. La grilla lo indica con un badge y un popover de cambio rápido, el perfil del alumno muestra todas sus materias juntas, y los paneles inferiores se reorganizaron para aprovechar mejor el espacio.

### Resumen visual

| Elemento | Descripción |
|---|---|
| 🏷 Badge numérico | Junto al nombre de la Materia |
| ⇄ Popover | Cambia la fila visible sin postback |
| 🗂 Perfil del alumno | Una sección por materia |
| ▦ Layout | Toolbar de 2 filas, paneles compactos |

### Validación de duplicados: Matrícula + Materia

Antes, dar de alta una matrícula que ya existía se rechazaba siempre. Ahora se permite si la **Materia es distinta**: la comprobación de duplicados pasó de `p.Matricula.Equals(matricula)` a `p.Matricula.Equals(matricula) && p.Materia.Equals(materia)`. Este cambio se aplicó de forma consistente en el alta manual (`btn_Click`), en la edición (`btnGuardarEdicion_Click`) y en la importación desde Excel/CSV.

### Badge + popover en la grilla

`GridDatos_RowDataBound` marca cada fila `<tr>` con los atributos `data-matricula` y `data-materia`. En el cliente, `aplicarBadgesMultiMateria()` agrupa las filas renderizadas por matrícula: si un alumno tiene más de un registro, oculta todas las filas excepto la primera y agrega un badge (ícono 📚 + número) junto al nombre de la materia.

Al hacer clic en el badge, `mostrarPopoverMaterias()` despliega un popover flotante (`position: fixed`, posicionado con `getBoundingClientRect()`) con la lista de materias registradas para esa matrícula. Todo ocurre en el cliente, sin postback ni modal.

> Las acciones de cada fila (Editar / Anular / Historial) usan `CommandArgument='<%# Eval("Matricula") + "|" + Eval("Materia") %>'`. `GridDatos_RowCommand` separa ese valor con `Split('|')` para identificar exactamente qué registro de materia se está accionando.

### Perfil unificado del alumno

`MostrarPerfilAlumno()` recolecta **todos** los registros de la matrícula y los renderiza como bloques independientes (`.perfil-materia-section`), uno por materia. Cada bloque incluye el nombre de la materia (con su color habitual), la situación (Aprobado/Reprobado), la grilla de notas y su propio historial de auditoría (`AuditLogger.ObtenerPorMatriculaYMateria`).

## 🚀 Requisitos y ejecución

1. **.NET Framework 4.7.2** y **Visual Studio 2019/2022** (con workloads ASP.NET y web).
2. Restaurar paquetes NuGet (`.sln` + `packages.config`).
3. SQL Server **LocalDB** (`(localdb)\mssqllocaldb`) con la base `ListasGenericas2026` y los procedimientos almacenados.
4. Ejecutar el proyecto `Datos` (IIS Express) o el entry-point de consola `LIstas genericas 2026`.

> **Nota Smart App Control (Windows):** ASP.NET compila ensamblados dinámicos en `Temporary ASP.NET Files`. Si Windows bloquea la carga con el error `0x800711C7`, desactiva Smart App Control (Configuración → Seguridad de Windows → Control de aplicaciones y navegador) o precompila la aplicación.
