<%@ Page Title="Documentación" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Datos.About" ResponseEncoding="UTF-8" ContentType="text/html; charset=utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
/* ── Layout docs ──────────────────────────────────────── */
.docs-page {
  display: grid;
  grid-template-columns: 200px 1fr;
  gap: 40px;
  align-items: start;
  padding-top: 8px;
}
.docs-sidebar {
  position: sticky;
  top: 80px;
  border-right: 1px solid var(--border);
  padding-right: 20px;
}
.docs-sidebar-label {
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: .1em;
  color: var(--text3);
  margin-bottom: 10px;
  padding-bottom: 8px;
  border-bottom: 1px solid var(--border);
}
.docs-nav-group-title {
  font-size: 10px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: .07em;
  color: var(--text3);
  margin: 14px 0 5px;
}
.docs-nav-link {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 5px 8px;
  border-radius: var(--r);
  font-size: 13px;
  color: var(--text2);
  text-decoration: none;
  cursor: pointer;
  transition: all .15s;
  margin-bottom: 2px;
}
.docs-nav-link:hover { background: var(--bg3); color: var(--text); }
.docs-nav-link.active { background: var(--amber-glow); color: var(--amber); }
.docs-nav-link .ndot {
  width: 5px; height: 5px;
  border-radius: 50%;
  background: var(--border2);
  flex-shrink: 0;
}
.docs-nav-link.active .ndot { background: var(--amber); }

.docs-content { min-width: 0; }
.doc-section {
  margin-bottom: 52px;
  scroll-margin-top: 90px;
}
.doc-section-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text);
  margin-bottom: 6px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  gap: 10px;
}
.ds-icon {
  width: 30px; height: 30px;
  border-radius: var(--r);
  display: flex; align-items: center; justify-content: center;
  font-size: 14px; flex-shrink: 0;
}
.ds-icon.amber  { background: var(--amber-glow); color: var(--amber); }
.ds-icon.teal   { background: var(--teal-glow);  color: var(--teal); }
.ds-icon.blue   { background: rgba(74,158,255,.1); color: var(--blue); }
.ds-icon.purple { background: rgba(160,100,230,.1); color: var(--purple); }

.doc-h3 {
  font-size: 14px;
  font-weight: 600;
  color: var(--text);
  margin: 22px 0 8px;
  display: flex;
  align-items: center;
  gap: 8px;
}
.doc-h3::before {
  content: '';
  width: 3px; height: 13px;
  background: var(--amber);
  border-radius: 2px;
}
.doc-p {
  font-size: 13px;
  color: var(--text2);
  line-height: 1.75;
  margin-bottom: 10px;
}
.doc-p strong { color: var(--text); font-weight: 500; }
.doc-p code {
  font-family: var(--mono);
  font-size: 11px;
  color: var(--amber);
  background: var(--amber-glow);
  padding: 1px 6px;
  border-radius: 4px;
}

.code-wrap {
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: var(--r2);
  overflow: hidden;
  margin: 12px 0;
}
.code-hdr {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 14px;
  background: var(--bg3);
  border-bottom: 1px solid var(--border);
}
.code-lang {
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: .07em;
}
.code-lang.aspx   { color: var(--amber); }
.code-lang.csharp { color: var(--purple); }
.code-lang.sql    { color: var(--blue); }
.code-lang.xml    { color: var(--teal); }
.code-file { font-family: var(--mono); font-size: 11px; color: var(--text3); }

pre.code-block {
  padding: 16px;
  font-family: var(--mono);
  font-size: 12px;
  color: var(--text2);
  line-height: 1.65;
  overflow-x: auto;
  margin: 0;
  tab-size: 2;
}
pre.code-block .kw   { color: #c792ea; }
pre.code-block .kw2  { color: var(--blue); }
pre.code-block .str  { color: var(--teal); }
pre.code-block .cmt  { color: var(--text3); font-style: italic; }
pre.code-block .prop { color: var(--amber); }
pre.code-block .num  { color: #f78c6c; }
pre.code-block .tag  { color: #f07178; }
pre.code-block .att  { color: var(--amber); }
pre.code-block .val  { color: var(--teal); }

.note {
  display: flex; gap: 12px;
  padding: 12px 16px;
  border-radius: var(--r);
  margin: 12px 0;
  font-size: 13px;
  line-height: 1.6;
}
.note.info   { background: rgba(74,158,255,.07); border-left: 3px solid var(--blue);  color: var(--text2); }
.note.tip    { background: var(--teal-glow);      border-left: 3px solid var(--teal);  color: var(--text2); }
.note.warn   { background: var(--amber-glow);     border-left: 3px solid var(--amber); color: var(--text2); }
.note strong { color: var(--text); }

.doc-grid-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 14px;
  margin: 14px 0;
}
.doc-mini-card {
  background: var(--bg2);
  border: 1px solid var(--border);
  border-radius: var(--r2);
  padding: 18px;
  transition: border-color .2s;
}
.doc-mini-card:hover { border-color: var(--border2); }
.doc-mini-card .mc-icon {
  width: 32px; height: 32px;
  border-radius: var(--r);
  display: flex; align-items: center; justify-content: center;
  font-size: 14px; margin-bottom: 10px;
}
.doc-mini-card .mc-icon.amber  { background: var(--amber-glow); color: var(--amber); }
.doc-mini-card .mc-icon.teal   { background: var(--teal-glow);  color: var(--teal); }
.doc-mini-card .mc-icon.blue   { background: rgba(74,158,255,.1); color: var(--blue); }
.doc-mini-card .mc-icon.purple { background: rgba(160,100,230,.1); color: var(--purple); }
.doc-mini-card .mc-icon.red    { background: var(--red-glow); color: var(--red); }
.doc-mini-card .mc-label { font-size: 11px; color: var(--text3); text-transform: uppercase; letter-spacing: .06em; margin-bottom: 4px; }
.doc-mini-card .mc-val   { font-size: 22px; font-weight: 600; color: var(--text); }

.doc-divider { height: 1px; background: var(--border); margin: 28px 0; }

.hero-banner {
  background: var(--bg2);
  border: 1px solid var(--border);
  border-radius: var(--r2);
  padding: 28px;
  margin-bottom: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  position: relative;
  overflow: hidden;
}
.hero-banner::after {
  content: '';
  position: absolute; top: 0; right: 0;
  width: 200px; height: 100%;
  background: linear-gradient(90deg, transparent, rgba(232,160,73,.03));
  pointer-events: none;
}
.hero-icon {
  width: 56px; height: 56px;
  background: linear-gradient(135deg, var(--amber), var(--amber3));
  border-radius: var(--r2);
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0;
}
.hero-icon svg { width: 26px; height: 26px; stroke: white; fill: none; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; }
.hero-title { font-size: 22px; font-weight: 600; color: var(--text); line-height: 1.2; }
.hero-sub   { font-size: 13px; color: var(--text3); margin-top: 4px; }

.ref-table-wrap { overflow-x: auto; margin: 12px 0; }
.ref-table { width: 100%; border-collapse: collapse; font-size: 13px; }
.ref-table th {
  padding: 8px 12px; text-align: left;
  font-size: 10px; font-weight: 700; text-transform: uppercase;
  letter-spacing: .08em; color: var(--text2);
  background: var(--bg3); border-bottom: 2px solid var(--amber3); white-space: nowrap;
}
.ref-table td {
  padding: 8px 12px; border-bottom: 1px solid var(--border); color: var(--text2);
}
.ref-table tr:last-child td { border-bottom: none; }
.ref-table tr:hover td { background: rgba(255,255,255,.02); }
.ref-table td code {
  font-family: var(--mono); font-size: 11px; color: var(--amber);
  background: var(--amber-glow); padding: 1px 6px; border-radius: 4px;
}

@media (max-width: 860px) {
  .docs-page { grid-template-columns: 1fr; }
  .docs-sidebar { position: static; border-right: none; border-bottom: 1px solid var(--border); padding-bottom: 14px; padding-right: 0; }
}
</style>

<div class="docs-page">

  <%-- Sidebar --%>
  <aside class="docs-sidebar">
    <div class="docs-sidebar-label">Documentación</div>

    <div class="docs-nav-group-title">Proyecto</div>
    <a class="docs-nav-link active" href="#resumen"><span class="ndot"></span>Resumen</a>
    <a class="docs-nav-link" href="#stack"><span class="ndot"></span>Stack tecnológico</a>
    <a class="docs-nav-link" href="#arquitectura"><span class="ndot"></span>Arquitectura</a>

    <div class="docs-nav-group-title">Base de datos</div>
    <a class="docs-nav-link" href="#schema"><span class="ndot"></span>Esquema BD</a>
    <a class="docs-nav-link" href="#procedimientos"><span class="ndot"></span>Procedimientos</a>

    <div class="docs-nav-group-title">Negocio</div>
    <a class="docs-nav-link" href="#calculos"><span class="ndot"></span>Cálculos</a>
    <a class="docs-nav-link" href="#auditoria"><span class="ndot"></span>Auditoría</a>
    <a class="docs-nav-link" href="#exportacion"><span class="ndot"></span>Exportación</a>

    <div class="docs-nav-group-title">Componentes</div>
    <a class="docs-nav-link" href="#distribucion"><span class="ndot"></span>Distribución mosaico</a>
    <a class="docs-nav-link" href="#historial-audit"><span class="ndot"></span>Historial auditoría</a>

    <div class="docs-nav-group-title">Mejoras</div>
    <a class="docs-nav-link" href="#mejoras"><span class="ndot"></span>Mejoras implementadas</a>

    <div class="docs-nav-group-title">Novedades</div>
    <a class="docs-nav-link" href="#novedades"><span class="ndot"></span>Materias múltiples y diseño compacto</a>
  </aside>

  <%-- Content --%>
  <div class="docs-content">

    <%-- Hero --%>
    <div class="hero-banner">
      <div class="hero-icon">
        <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
      </div>
      <div>
        <div class="hero-title">Listas Genéricas 2026 — Documentación</div>
        <div class="hero-sub">Sistema de Gestión Académica · .NET Framework 4.7.2 · ASP.NET WebForms · SQL LocalDB</div>
      </div>
    </div>

    <div class="note tip" style="margin-bottom:24px">
      <span>💡</span>
      <span>Documentación completa del proyecto <strong>Listas Genéricas 2026</strong>. Incluye stack,
      arquitectura 3 capas, esquema de base de datos, lógica de negocio, y las 10 mejoras implementadas.</span>
    </div>

    <%-- ════ RESUMEN ════ --%>
    <section class="doc-section" id="resumen">
      <h2 class="doc-section-title">
        <span class="ds-icon amber">ℹ</span>
        Resumen del proyecto
      </h2>
      <p class="doc-p">
        <strong>Listas Genéricas 2026</strong> es un sistema web de gestión académica para instituciones de
        educación superior. Permite administrar registros de estudiantes con sus calificaciones
        (P1/P2 0–20, TP 0–10, Examen Final 0–50), con cálculos automáticos de totales y promedios,
        auditoría completa de operaciones CRUD, exportación a Excel/CSV y gráficos estadísticos.
      </p>
      <p class="doc-p">
        El sistema soporta 5 materias: <strong>Lenguaje de Programación 2</strong>,
        <strong>Historia y Filosofía de la Ciencia</strong>, <strong>Ética Personal</strong>,
        <strong>Física 3</strong> y <strong>Matemática para Informáticos</strong>.
        Localizado para <code>es-AR · America/Buenos_Aires · UTF-8</code>.
      </p>
    </section>

    <%-- ════ STACK ════ --%>
    <section class="doc-section" id="stack">
      <h2 class="doc-section-title">
        <span class="ds-icon amber">⚙</span>
        Stack tecnológico
      </h2>

      <div class="doc-grid-cards">
        <div class="doc-mini-card">
          <div class="mc-icon amber">.N</div>
          <div class="mc-label">Framework</div>
          <div class="mc-val">4.7.2</div>
        </div>
        <div class="doc-mini-card">
          <div class="mc-icon teal">CS</div>
          <div class="mc-label">Lenguaje</div>
          <div class="mc-val">C# 7.3+</div>
        </div>
        <div class="doc-mini-card">
          <div class="mc-icon blue">BS</div>
          <div class="mc-label">UI Framework</div>
          <div class="mc-val">Bootstrap 5.2.3</div>
        </div>
        <div class="doc-mini-card">
          <div class="mc-icon purple">DB</div>
          <div class="mc-label">Base de datos</div>
          <div class="mc-val">SQL LocalDB</div>
        </div>
      </div>

      <div class="code-wrap">
        <div class="code-hdr">
          <span class="code-lang xml">packages.config</span>
          <span class="code-file">Dependencias NuGet</span>
        </div>
        <pre class="code-block"><span class="cmt">&lt;!-- Dependencias principales del proyecto --&gt;</span>
<span class="tag">&lt;package</span> <span class="att">id</span>=<span class="str">"ClosedXML"</span>            <span class="att">version</span>=<span class="str">"0.105.0"</span> <span class="tag">/&gt;</span>
<span class="tag">&lt;package</span> <span class="att">id</span>=<span class="str">"Newtonsoft.Json"</span>      <span class="att">version</span>=<span class="str">"13.0.3"</span> <span class="tag">/&gt;</span>
<span class="tag">&lt;package</span> <span class="att">id</span>=<span class="str">"Chart.js"</span>              <span class="att">version</span>=<span class="str">"4.4.0"</span> <span class="tag">/&gt;</span>
<span class="tag">&lt;package</span> <span class="att">id</span>=<span class="str">"Bootstrap"</span>             <span class="att">version</span>=<span class="str">"5.2.3"</span> <span class="tag">/&gt;</span>
<span class="tag">&lt;package</span> <span class="att">id</span>=<span class="str">"jQuery"</span>                <span class="att">version</span>=<span class="str">"3.7.0"</span> <span class="tag">/&gt;</span>
<span class="tag">&lt;package</span> <span class="att">id</span>=<span class="str">"Microsoft.CodeDom.Providers.DotNetCompilerPlatform"</span> <span class="att">version</span>=<span class="str">"2.0.1"</span> <span class="tag">/&gt;</span></pre>
      </div>
    </section>

    <%-- ════ ARQUITECTURA ════ --%>
    <section class="doc-section" id="arquitectura">
      <h2 class="doc-section-title">
        <span class="ds-icon teal">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
        </span>
        Arquitectura del proyecto
      </h2>

      <p class="doc-p">
        Arquitectura <strong>3 capas</strong> clásica: <strong>Presentación</strong> (ASPX + Site.Master),
        <strong>Lógica de Negocio</strong> (BLL con Fachada, DTOs, Servicios),
        <strong>Datos</strong> (SQL Server LocalDB con procedimientos almacenados).
      </p>

      <div class="code-wrap">
        <div class="code-hdr">
          <span class="code-lang xml">Estructura</span>
          <span class="code-file">Solución Datos + BLL</span>
        </div>
        <pre class="code-block">Datos.sln
├── 📁 Datos                    <span class="cmt">// Capa de Presentación</span>
│   ├── Site.Master             <span class="cmt">// Layout global</span>
│   ├── Default.aspx            <span class="cmt">// Página de inicio</span>
│   ├── Tect.aspx               <span class="cmt">// UI principal (GridView)</span>
│   ├── Tect.aspx.cs            <span class="cmt">// Code-behind con eventos</span>
│   ├── Contact.aspx            <span class="cmt">// Grilla de Ordenamiento (doc)</span>
│   ├── About.aspx              <span class="cmt">// Documentación</span>
│   ├── Content/
│   │   ├── site-rediseno.css   <span class="cmt">// Estilos globales</span>
│   │   └── bootstrap/          <span class="cmt">// Bootstrap 5.2.3</span>
│   └── Web.config              <span class="cmt">// Conexión LocalDB + appSettings</span>
│
├── 📁 BLL                      <span class="cmt">// Capa de Negocio</span>
│   ├── Fachada/
│   │   ├── Calculos.cs         <span class="cmt">// Cálculos de total/promedio/letras</span>
│   │   ├── AuditLogger.cs      <span class="cmt">// Registro de auditoría</span>
│   │   └── PersonasService.cs  <span class="cmt">// CRUD Personas</span>
│   └── DTO/
│       ├── InfoDatosPersonales.cs
│       ├── AuditEntry.cs
│       └── InfoCalificaciones.cs
│
└── packages.config              <span class="cmt">// NuGet dependencies</span></pre>
      </div>
    </section>

    <div class="doc-divider"></div>

    <%-- ════ ESQUEMA BD ════ --%>
    <section class="doc-section" id="schema">
      <h2 class="doc-section-title">
        <span class="ds-icon blue">🗄</span>
        Esquema de base de datos
      </h2>

      <p class="doc-p">
        Base de datos <strong>ListasGenericas2026</strong> en SQL Server LocalDB (<code>(localdb)\mssqllocaldb</code>).
        Dos tablas principales:
      </p>

      <h3 class="doc-h3">Tabla Personas</h3>
      <div class="code-wrap">
        <div class="code-hdr">
          <span class="code-lang sql">SQL</span>
          <span class="code-file">CREATE TABLE Personas</span>
        </div>
        <pre class="code-block"><span class="kw">CREATE TABLE</span> Personas (
    Id           <span class="kw2">INT</span>          <span class="kw">IDENTITY(1,1) PRIMARY KEY</span>,
    Matricula    <span class="kw2">NVARCHAR(50)</span>  <span class="kw">NOT NULL</span>,
    Nombre       <span class="kw2">NVARCHAR(150)</span> <span class="kw">NOT NULL</span>,
    Materia      <span class="kw2">NVARCHAR(100)</span> <span class="kw">NOT NULL</span>,
    Parcial1     <span class="kw2">DECIMAL(4,2)</span> <span class="kw">NOT NULL</span>,
    Parcial2     <span class="kw2">DECIMAL(4,2)</span> <span class="kw">NOT NULL</span>,
    TP           <span class="kw2">DECIMAL(4,2)</span> <span class="kw">NOT NULL</span>,
    ExamenFinal  <span class="kw2">DECIMAL(5,2)</span> <span class="kw">NOT NULL</span>,
    Total        <span class="kw2">DECIMAL(5,2)</span> <span class="kw">NOT NULL</span>,
    Promedio     <span class="kw2">DECIMAL(4,2)</span> <span class="kw">NOT NULL</span>,
    FechaRegistro <span class="kw2">DATETIME2</span>   <span class="kw">NOT NULL</span>
);</pre>
      </div>

      <h3 class="doc-h3">Tabla AuditLog</h3>
      <div class="code-wrap">
        <div class="code-hdr">
          <span class="code-lang sql">SQL</span>
          <span class="code-file">CREATE TABLE AuditLog</span>
        </div>
        <pre class="code-block"><span class="kw">CREATE TABLE</span> AuditLog (
    Id         <span class="kw2">INT</span>          <span class="kw">IDENTITY(1,1) PRIMARY KEY</span>,
    Accion     <span class="kw2">NVARCHAR(20)</span>  <span class="kw">NOT NULL</span>,           <span class="cmt">-- INSERT / UPDATE / DELETE</span>
    Matricula  <span class="kw2">NVARCHAR(50)</span>  <span class="kw">NOT NULL</span>,
    Nombre     <span class="kw2">NVARCHAR(150)</span> <span class="kw">NOT NULL</span>,
    Detalle    <span class="kw2">NVARCHAR(500)</span> <span class="kw">NULL</span>,
    Usuario    <span class="kw2">NVARCHAR(100)</span> <span class="kw">NULL</span>,
    FechaHora  <span class="kw2">DATETIME2</span>    <span class="kw">NOT NULL</span>
);</pre>
      </div>
    </section>

    <%-- ════ PROCEDIMIENTOS ════ --%>
    <section class="doc-section" id="procedimientos">
      <h2 class="doc-section-title">
        <span class="ds-icon purple">⚡</span>
        Procedimientos almacenados
      </h2>

      <p class="doc-p">
        Todos los accesos a datos se realizan mediante <strong>procedimientos almacenados</strong>
        en lugar de SQL inline, mejorando seguridad y mantenibilidad.
      </p>

      <div class="ref-table-wrap">
        <table class="ref-table">
          <thead>
            <tr><th>Procedimiento</th><th>Función</th></tr>
          </thead>
          <tbody>
            <tr><td><code>Personas_Insert</code></td><td>Inserta nueva persona</td></tr>
            <tr><td><code>Personas_Update</code></td><td>Actualiza datos existentes</td></tr>
            <tr><td><code>Personas_Delete</code></td><td>Elimina registro por Id</td></tr>
            <tr><td><code>Personas_GetAll</code></td><td>Obtiene todas las personas</td></tr>
            <tr><td><code>Personas_GetByMatricula</code></td><td>Busca por matrícula</td></tr>
            <tr><td><code>AuditLog_Insert</code></td><td>Registra evento de auditoría</td></tr>
            <tr><td><code>AuditLog_GetAll</code></td><td>Obtiene historial de auditoría</td></tr>
            <tr><td><code>AuditLog_GetStats</code></td><td>Estadísticas por tipo de operación</td></tr>
          </tbody>
        </table>
      </div>
    </section>

    <div class="doc-divider"></div>

    <%-- ════ CÁLCULOS ════ --%>
    <section class="doc-section" id="calculos">
      <h2 class="doc-section-title">
        <span class="ds-icon teal">∑</span>
        Lógica de cálculos
      </h2>

      <p class="doc-p">
        La clase <code>Calculos.cs</code> en <code>BLL/Fachada/</code> contiene toda la lógica
        matemática del sistema.
      </p>

      <div class="code-wrap">
        <div class="code-hdr">
          <span class="code-lang csharp">C#</span>
          <span class="code-file">BLL/Fachada/Calculos.cs</span>
        </div>
        <pre class="code-block"><span class="cmt">// Calcula Total = P1 + P2 + TP + ExamenFinal</span>
<span class="kw">public static decimal</span> CalcularTotal(<span class="kw2">decimal</span> p1, <span class="kw2">decimal</span> p2,
    <span class="kw2">decimal</span> tp, <span class="kw2">decimal</span> ef)
    => p1 + p2 + tp + ef;

<span class="cmt">// Calcula Promedio = Total / 20 (escala 0-5)</span>
<span class="kw">public static decimal</span> CalcularPromedio(<span class="kw2">decimal</span> total)
    => Math.Round(total / <span class="num">20m</span>, <span class="num">2</span>);

<span class="cmt">// Convierte promedio numérico a letra</span>
<span class="kw">public static string</span> ObtenerNotaFinalLetras(<span class="kw2">decimal</span> promedio)
{
    <span class="kw">if</span> (promedio &lt; <span class="num">1m</span>)  <span class="kw">return</span> <span class="str">"Malo"</span>;
    <span class="kw">if</span> (promedio &lt; <span class="num">2m</span>)  <span class="kw">return</span> <span class="str">"Deficiente"</span>;
    <span class="kw">if</span> (promedio &lt; <span class="num">3m</span>)  <span class="kw">return</span> <span class="str">"Regular"</span>;
    <span class="kw">if</span> (promedio &lt; <span class="num">4m</span>)  <span class="kw">return</span> <span class="str">"Bueno"</span>;
    <span class="kw">if</span> (promedio &lt; <span class="num">5m</span>)  <span class="kw">return</span> <span class="str">"Excelente"</span>;
    <span class="kw">return</span> <span class="str">"Excelente"</span>;
}

<span class="cmt">// Determina situación académica</span>
<span class="kw">public static string</span> ObtenerSituacion(<span class="kw2">decimal</span> promedio)
    => promedio >= <span class="num">2m</span> ? <span class="str">"Aprobado"</span> : <span class="str">"Reprobado"</span>;</pre>
      </div>
    </section>

    <%-- ════ AUDITORÍA ════ --%>
    <section class="doc-section" id="auditoria">
      <h2 class="doc-section-title">
        <span class="ds-icon purple">◉</span>
        Sistema de auditoría
      </h2>

      <p class="doc-p">
        Cada operación CRUD (Insert, Update, Delete) registra automáticamente un evento en la
        tabla <code>AuditLog</code>. El <strong>AuditLogger</strong> y el <strong>GridView con historial</strong>
        permiten visualizar y auditar todos los cambios.
      </p>

      <div class="doc-grid-cards">
        <div class="doc-mini-card">
          <div class="mc-icon teal">+</div>
          <div class="mc-label">Operaciones hoy</div>
          <div class="mc-val" style="color:var(--teal)">INSERT</div>
        </div>
        <div class="doc-mini-card">
          <div class="mc-icon amber">↻</div>
          <div class="mc-label">Actualizaciones</div>
          <div class="mc-val" style="color:var(--amber)">UPDATE</div>
        </div>
        <div class="doc-mini-card">
          <div class="mc-icon red">✕</div>
          <div class="mc-label">Eliminaciones</div>
          <div class="mc-val" style="color:var(--red)">DELETE</div>
        </div>
      </div>

      <div class="code-wrap">
        <div class="code-hdr">
          <span class="code-lang csharp">C#</span>
          <span class="code-file">BLL/Fachada/AuditLogger.cs</span>
        </div>
        <pre class="code-block"><span class="kw">public static void</span> Registrar(<span class="kw2">string</span> accion, <span class="kw2">string</span> matricula,
    <span class="kw2">string</span> nombre, <span class="kw2">string</span> detalle)
{
    <span class="kw">using var</span> conn = <span class="kw">new</span> SqlConnection(Config.Cnn);
    <span class="kw">using var</span> cmd = <span class="kw">new</span> SqlCommand(<span class="str">"AuditLog_Insert"</span>, conn);
    cmd.CommandType = CommandType.StoredProcedure;

    cmd.Parameters.AddWithValue(<span class="str">"@Accion"</span>, accion);
    cmd.Parameters.AddWithValue(<span class="str">"@Matricula"</span>, matricula);
    cmd.Parameters.AddWithValue(<span class="str">"@Nombre"</span>, nombre);
    cmd.Parameters.AddWithValue(<span class="str">"@Detalle"</span>, detalle);
    cmd.Parameters.AddWithValue(<span class="str">"@Usuario"</span>,
        HttpContext.Current?.User?.Identity?.Name ?? <span class="str">"Sistema"</span>);

    conn.Open();
    cmd.ExecuteNonQuery();
}</pre>
      </div>
    </section>

    <%-- ════ EXPORTACIÓN ════ --%>
    <section class="doc-section" id="exportacion">
      <h2 class="doc-section-title">
        <span class="ds-icon blue">⬇</span>
        Exportación a Excel / CSV
      </h2>

      <p class="doc-p">
        Usa <strong>ClosedXML 0.105.0</strong> para exportar a Excel y StringBuilder para CSV.
        Respeta los filtros activos al exportar.
      </p>

      <div class="note info">
        <span>ℹ</span>
        <span>La exportación filtra por los mismos criterios que la UI: si hay búsqueda o filtro
        de materia, solo exporta los registros visibles.</span>
      </div>
    </section>

    <div class="doc-divider"></div>

    <%-- ════ DISTRIBUCIÓN MOSAICO ════ --%>
    <section class="doc-section" id="distribucion">
      <h2 class="doc-section-title">
        <span class="ds-icon teal">▦</span>
        Distribución de promedios — Mosaico
      </h2>

      <p class="doc-p">
        Visualización de la distribución de promedios mediante una cuadrícula de
        <strong>5 filas × 8 celdas</strong>. Cada fila representa un rango (0–1, 1–2, 2–3, 3–4, 4–5)
        y cada celda rellena representa un estudiante en ese rango. Incluye tooltip al hover,
        contador y porcentaje por fila, y leyenda inferior.
      </p>

      <div class="note tip">
        <span>💡</span>
        <span>Los tooltips usan <code>position:fixed</code> sobre <code>document.body</code>,
        lo que evita problemas de clipping por <code>overflow:hidden</code> del panel.</span>
      </div>

      <h3 class="doc-h3">Archivos involucrados</h3>
      <div class="ref-table-wrap">
        <table class="ref-table">
          <thead><tr><th>Archivo</th><th>Línea</th><th>Función</th></tr></thead>
          <tbody>
            <tr><td><code>Datos\Tect.aspx</code></td><td>98–115</td><td>&lt;style&gt; — CSS del mosaico (.mosaic-grid/row/cells/cell/count/pct/legend)</td></tr>
            <tr><td><code>Datos\Tect.aspx</code></td><td>373–393</td><td>HTML del panel .chart-panel con #mosaicGrid y leyenda</td></tr>
            <tr><td><code>Datos\Tect.aspx</code></td><td>~510–700</td><td>JS inicializarGrafico() — lee GridView, extrae promedios, renderiza mosaico</td></tr>
            <tr><td><code>Datos\Content\site-override.css</code></td><td>~1380–1425</td><td>CSS base del mosaico con !important</td></tr>
          </tbody>
        </table>
      </div>

      <h3 class="doc-h3">Lo que NO existe (eliminado)</h3>
      <div class="note warn">
        <span>⚠</span>
        <span>
          Los 4 mini-stat cards (Total / Aprobados / Reprobados / Promedio) fueron
          <strong>eliminados</strong> del panel — son redundantes con las stat-cards superiores.<br>
          El CSS <code>.dist-mini-stats/stat/val/lbl</code> y <code>.chart-panel &#123; overflow:visible &#125;</code>
          también fueron eliminados. El <code>overflow:hidden</code> de <code>site-override.css</code>
          recorta correctamente la barra gradiente <code>::before</code> a las esquinas del panel.
        </span>
      </div>

      <h3 class="doc-h3">Colores por rango</h3>
      <div class="code-wrap">
        <div class="code-hdr">
          <span class="code-lang aspx">JavaScript</span>
          <span class="code-file">Datos\Tect.aspx — inicializarGrafico()</span>
        </div>
        <pre class="code-block"><span class="kw">var</span> CONFIG = [
  &#123; label: <span class="str">'0–1'</span>, color: <span class="str">'#e05555'</span> &#125;,   <span class="cmt">// rojo</span>
  &#123; label: <span class="str">'1–2'</span>, color: <span class="str">'#e08840'</span> &#125;,   <span class="cmt">// naranja</span>
  &#123; label: <span class="str">'2–3'</span>, color: <span class="str">'#e0c040'</span> &#125;,   <span class="cmt">// amarillo</span>
  &#123; label: <span class="str">'3–4'</span>, color: <span class="str">'#68c464'</span> &#125;,   <span class="cmt">// verde</span>
  &#123; label: <span class="str">'4–5'</span>, color: <span class="str">'#2dd4a0'</span> &#125;    <span class="cmt">// teal</span>
];
<span class="cmt">// Extracción de promedio desde cells[8] que contiene "3,43Cuatro":</span>
<span class="kw">var</span> m = raw.replace(<span class="str">','</span>, <span class="str">'.'</span>).match(<span class="str">/^(\d+(?:\.\d+)?)/</span>);
<span class="kw">var</span> val = m ? parseFloat(m[<span class="num">1</span>]) : NaN;</pre>
      </div>
    </section>

    <%-- ════ HISTORIAL AUDITORÍA ════ --%>
    <section class="doc-section" id="historial-audit">
      <h2 class="doc-section-title">
        <span class="ds-icon purple">◉</span>
        Últimos eventos de auditoría — Panel
      </h2>

      <p class="doc-p">
        Panel colapsable que muestra las <strong>últimas 5 entradas</strong> del log de sesión actual,
        sin necesidad de descargar el Excel. Muestra: tipo de acción (INSERT / UPDATE / DELETE),
        nombre del estudiante, materia, detalle del cambio y hora exacta.
        Se actualiza automáticamente tras cada operación (postback).
      </p>

      <div class="note info">
        <span>ℹ</span>
        <span>
          <strong>Diferencia con el botón Log:</strong> el panel muestra solo los últimos 5 eventos
          en pantalla. El botón Log descarga un Excel/CSV con <em>todos</em> los eventos de la sesión.
          Los datos viven en <code>Session["AuditLog"]</code> — se pierden al cerrar el navegador.
        </span>
      </div>

      <h3 class="doc-h3">Flujo de datos</h3>
      <div class="code-wrap">
        <div class="code-hdr">
          <span class="code-lang aspx">Flujo</span>
          <span class="code-file">Datos\Tect.aspx.cs + AuditLogger.cs</span>
        </div>
        <pre class="code-block"><span class="cmt">// 1. El usuario acciona INSERT / UPDATE / DELETE</span>
btn_Click()           → AuditLogger.RegistrarInsercion(Session, info)
btnGuardarEdicion()   → AuditLogger.RegistrarActualizacion(Session, snapshot, actualizado)
EliminarRegistro()    → AuditLogger.RegistrarEliminacion(Session, personaAEliminar)

<span class="cmt">// 2. AuditLogger.Agregar() crea AuditEntry y lo guarda en Session</span>
session[<span class="str">"AuditLog"</span>] = lista;   <span class="cmt">// List&lt;AuditEntry&gt;</span>

<span class="cmt">// 3. Page_PreRender genera el HTML y lo asigna al Literal</span>
<span class="kw">protected void</span> Page_PreRender(object sender, EventArgs e)
    => litAuditEntries.Text = RenderAuditEntries();

<span class="cmt">// 4. RenderAuditEntries() lee las últimas 5 y genera history-items</span>
<span class="kw">var</span> ultimas = AuditLogger.ObtenerUltimas(Session, <span class="num">5</span>);
<span class="kw">foreach</span> (<span class="kw">var</span> e <span class="kw">in</span> ultimas) &#123;
    html.Append(<span class="str">"&lt;div class=\"history-item\"&gt;"</span>);
    html.AppendFormat(<span class="str">"&lt;div class=\"h-dot {0}\"&gt;&lt;/div&gt;"</span>, cls);
    html.AppendFormat(<span class="str">"&lt;div class=\"h-action {0}\"&gt;{1}&lt;/div&gt;"</span>, cls, e.Accion);
    html.AppendFormat(<span class="str">"&lt;div class=\"h-detail\"&gt;{0} · {1} · {2}&lt;/div&gt;"</span>,
        Nombre, Materia, Detalle);
    html.AppendFormat(<span class="str">"&lt;div class=\"h-time\"&gt;{0}&lt;/div&gt;"</span>,
        e.Timestamp.ToLongTimeString());
&#125;</pre>
      </div>

      <h3 class="doc-h3">Archivos involucrados</h3>
      <div class="ref-table-wrap">
        <table class="ref-table">
          <thead><tr><th>Archivo</th><th>Línea</th><th>Función</th></tr></thead>
          <tbody>
            <tr><td><code>Datos\Tect.aspx</code></td><td>395–409</td><td>HTML — .section-panel › #auditHeader › #auditPanel.history-body › litAuditEntries</td></tr>
            <tr><td><code>Datos\Tect.aspx</code></td><td>~725–733</td><td>JS toggleAudit() — colapsar/expandir #auditPanel</td></tr>
            <tr><td><code>Datos\Tect.aspx.cs</code></td><td>43–46</td><td>Page_PreRender → litAuditEntries.Text = RenderAuditEntries()</td></tr>
            <tr><td><code>Datos\Tect.aspx.cs</code></td><td>642–672</td><td>RenderAuditEntries() — genera HTML de los history-items</td></tr>
            <tr><td><code>BLL\Fachada\AuditLogger.cs</code></td><td>214–245</td><td>ObtenerUltimas(session, 5) — ordena por Timestamp desc</td></tr>
            <tr><td><code>BLL\Fachada\AuditLogger.cs</code></td><td>157–173</td><td>Agregar() — añade AuditEntry a Session["AuditLog"]</td></tr>
            <tr><td><code>Datos\Content\site-override.css</code></td><td>1427–1505</td><td>Sección 17 — CSS .history-panel/.header/.body/.item/.h-dot/.h-action/.h-detail/.h-time</td></tr>
          </tbody>
        </table>
      </div>

      <h3 class="doc-h3">Clases CSS de los items</h3>
      <div class="ref-table-wrap">
        <table class="ref-table">
          <thead><tr><th>Clase</th><th>Rol</th></tr></thead>
          <tbody>
            <tr><td><code>.h-dot.ins / .upd / .del</code></td><td>Punto de color: teal / amber / red</td></tr>
            <tr><td><code>.h-action.ins / .upd / .del</code></td><td>Etiqueta INSERT / UPDATE / DELETE coloreada</td></tr>
            <tr><td><code>.h-detail</code></td><td>Nombre · Materia · Detalle del cambio (flex:1)</td></tr>
            <tr><td><code>.h-time</code></td><td>Hora exacta (font-family monospace, white-space:nowrap)</td></tr>
          </tbody>
        </table>
      </div>
    </section>

    <div class="doc-divider"></div>

    <%-- ════ MEJORAS ════ --%>
    <section class="doc-section" id="mejoras">
      <h2 class="doc-section-title">
        <span class="ds-icon amber">✓</span>
        Mejoras implementadas
      </h2>

      <p class="doc-p">
        De un sistema base funcional, se implementaron las siguientes mejoras para alcanzar
        una aplicación profesional:
      </p>

      <div class="code-wrap">
        <div class="code-hdr">
          <span class="code-lang aspx">Checklist</span>
          <span class="code-file">Estado: ✅ Build OK — sin errores</span>
        </div>
        <pre class="code-block"> <span class="num">1</span>  Paginación              — AllowPaging=true · 10 reg/pág · GridDatos
 <span class="num">2</span>  RangeValidator          — Validación por campo: P1/P2 0–20, TP 0–10, EF 0–50
 <span class="num">3</span>  Columna Situación       — TemplateField · Aprobado / Reprobado con colores
 <span class="num">4</span>  Desglose auditoría      — strip INSERT / UPDATE / DELETE en tiempo real
 <span class="num">5</span>  Resaltar fila editada   — JS resaltarFilaEditando() via ScriptManager
 <span class="num">6</span>  Mosaico distribución    — 5 rangos × 8 celdas · tooltips position:fixed · sin Chart.js
 <span class="num">7</span>  Exportar filtrados      — ClosedXML · Excel + CSV con filtros activos
 <span class="num">8</span>  Nota en letras          — ObtenerNotaFinalLetras() en BLL/Fachada (midpoints)
 <span class="num">9</span>  Búsqueda tiempo real    — AutoPostBack · txtBuscar con TextChanged
<span class="num">10</span>  Panel historial audit   — litAuditEntries · toggleAudit() · h-dot coloreados</pre>
      </div>

      <div class="note info" style="margin-top:16px">
        <span>ℹ</span>
        <span>
          La mejora <strong>#6</strong> reemplaza la versión anterior basada en Chart.js 4.4.0.
          El nuevo mosaico no requiere dependencias externas y usa JS vanilla con
          <code>cell.style.setProperty('background', color, 'important')</code>
          para sobrescribir reglas CSS con <code>!important</code>.<br><br>
          La mejora <strong>#10</strong> usa <code>&lt;asp:Literal ID="litAuditEntries"&gt;</code>
          poblado en <code>Page_PreRender</code>, reemplazando el Repeater anterior.
        </span>
      </div>
    </section>

    <div class="doc-divider"></div>

    <%-- ════ NOVEDADES RECIENTES ════ --%>
    <section class="doc-section" id="novedades">
      <h2 class="doc-section-title">
        <span class="ds-icon amber">🆕</span>
        Materias múltiples y diseño compacto
      </h2>

      <p class="doc-p">
        Última iteración sobre <code>Tect.aspx</code> / <code>Tect.aspx.cs</code>: ahora un mismo
        estudiante (misma <strong>Matrícula</strong>) puede tener un registro por cada
        <strong>materia</strong> que cursa, la grilla lo indica con un badge y un popover de cambio
        rápido, el perfil del alumno muestra todas sus materias juntas, y los paneles inferiores se
        reorganizaron para aprovechar mejor el espacio.
      </p>

      <h3 class="doc-h3">Resumen visual</h3>
      <div class="doc-grid-cards">
        <div class="doc-mini-card">
          <div class="mc-icon amber">🏷</div>
          <div class="mc-label">Badge numérico</div>
          <div class="mc-val" style="font-size:14px">Junto al nombre de la Materia</div>
        </div>
        <div class="doc-mini-card">
          <div class="mc-icon teal">⇄</div>
          <div class="mc-label">Popover</div>
          <div class="mc-val" style="font-size:14px">Cambia la fila visible sin postback</div>
        </div>
        <div class="doc-mini-card">
          <div class="mc-icon blue">🗂</div>
          <div class="mc-label">Perfil del alumno</div>
          <div class="mc-val" style="font-size:14px">Una sección por materia</div>
        </div>
        <div class="doc-mini-card">
          <div class="mc-icon purple">▦</div>
          <div class="mc-label">Layout</div>
          <div class="mc-val" style="font-size:14px">Toolbar de 2 filas, paneles compactos</div>
        </div>
      </div>

      <h3 class="doc-h3">Validación de duplicados: Matrícula + Materia</h3>
      <p class="doc-p">
        Antes, dar de alta una matrícula que ya existía se rechazaba siempre, sin importar la
        materia. Ahora se permite si la <strong>Materia</strong> es distinta: la comprobación de
        duplicados pasó de <code>p.Matricula.Equals(matricula)</code> a
        <code>p.Matricula.Equals(matricula) &amp;&amp; p.Materia.Equals(materia)</code>. Este cambio
        se aplicó de forma consistente en el alta manual (<code>btn_Click</code>), en la edición
        (<code>btnGuardarEdicion_Click</code>, con verificación de colisión si se cambia la materia
        a una que el alumno ya tiene) y en la importación desde Excel/CSV
        (<code>btnPrevisualizarImportacion_Click</code> / <code>btnConfirmarImportacion_Click</code>).
      </p>

      <h3 class="doc-h3">Badge + popover en la grilla</h3>
      <p class="doc-p">
        <code>GridDatos_RowDataBound</code> marca cada fila <code>&lt;tr&gt;</code> con los atributos
        <code>data-matricula</code> y <code>data-materia</code>. En el cliente,
        <code>aplicarBadgesMultiMateria()</code> agrupa las filas renderizadas por matrícula: si un
        alumno tiene más de un registro, oculta todas las filas excepto la primera y agrega un
        <strong>badge</strong> (ícono 📚 + número) junto al nombre de la materia, indicando cuántas
        materias tiene registradas ese alumno en total.
      </p>
      <p class="doc-p">
        Al hacer clic en el badge, <code>mostrarPopoverMaterias()</code> despliega un popover
        flotante (<code>position: fixed</code>, posicionado con <code>getBoundingClientRect()</code>)
        con la lista de materias registradas para esa matrícula. La materia que se está mostrando
        actualmente aparece marcada como <strong>"actual"</strong> y no es clickeable; las demás sí
        lo son — al seleccionar una, se oculta la fila visible, se muestra la fila de la materia
        elegida, y el badge se reconstruye sobre la nueva fila. Todo ocurre en el cliente, sin
        postback ni modal.
      </p>

      <div class="note tip">
        <span>💡</span>
        <span>
          Las acciones de cada fila (Editar / Anular / Historial) usan
          <code>CommandArgument='&lt;%# Eval("Matricula") + "|" + Eval("Materia") %&gt;'</code>.
          <code>GridDatos_RowCommand</code> separa ese valor con <code>Split('|')</code> para
          identificar exactamente qué registro de materia se está accionando, incluso cuando dos
          filas comparten la misma matrícula. El botón de <strong>perfil</strong> sigue usando solo
          la matrícula, porque el perfil agrupa todas las materias del alumno.
        </span>
      </div>

      <h3 class="doc-h3">Perfil unificado del alumno (sin pestañas)</h3>
      <p class="doc-p">
        <code>MostrarPerfilAlumno()</code> fue reescrito: en vez de mostrar una sola materia,
        recolecta <strong>todos</strong> los registros que correspondan a la matrícula del alumno y
        los renderiza como bloques independientes (<code>.perfil-materia-section</code>), uno por
        materia. Cada bloque incluye el nombre de la materia (con su color habitual), la situación
        (Aprobado/Reprobado), la grilla de notas (P1 / P2 / TP / Final / Total / Promedio) y su
        propio historial de auditoría, obtenido con
        <code>AuditLogger.ObtenerPorMatriculaYMateria(Session, matricula, materia)</code>. Las
        secciones se separan con un borde superior (separador visual) — se descartó el enfoque de
        pestañas para que toda la información quede visible de un vistazo.
      </p>

      <h3 class="doc-h3">Diseño compacto del panel principal</h3>
      <p class="doc-p">
        La toolbar de <strong>Registros de Estudiantes</strong> distribuye sus botones en
        <strong>dos filas</strong> con las nuevas clases <code>.tb-actions--stack</code> /
        <code>.tb-actions-row</code>, reutilizando el estilo <code>.tbtn</code> existente: primera
        fila <em>Limpiar / Excel / CSV</em>, segunda fila <em>Importar / Imprimir / Log</em>. El
        contenedor <code>.toolbar</code> pasó de <code>flex-wrap: nowrap</code> a
        <code>flex-wrap: wrap</code> para que ambas filas entren sin desbordar horizontalmente.
      </p>
      <p class="doc-p">
        El mosaico de <strong>Distribución de promedios</strong> se redujo (celdas de 22px a 14px y
        luego a 18px, menos separación entre filas y leyenda) para liberar espacio vertical. Ese
        espacio se redistribuyó entre los paneles inferiores: <strong>Últimos eventos de
        auditoría</strong> ahora usa una lista con scroll interno
        (<code>#auditPanel { max-height: 320px; overflow-y: auto }</code>) en vez de crecer sin
        límite, y <strong>Estadísticas de la Clase</strong> recibió más espacio entre columnas y
        valores más grandes (<code>.stat-col-val</code> de 18px a 24px).
      </p>

      <h3 class="doc-h3">Limpieza de elementos redundantes</h3>
      <div class="note warn">
        <span>⚠</span>
        <span>
          <strong>Contador de tiempo de sesión activa</strong> ("00:00:00" junto al título de
          Registros de Estudiantes) — se quitó por completo, junto con la función JS
          <code>iniciarSessionTimer()</code>, su llamada en <code>init()</code> y el
          <code>sessionStorage["inicioSesion"]</code> que usaba. El badge
          <code>#tableBadge</code> ("X entradas" / "X entrada") se mantiene exactamente como estaba
          antes.<br><br>
          <strong>Comparación por Materia</strong> — el panel completo, junto con
          <code>RenderComparacionMaterias()</code> y su CSS (<code>.materia-bar-row/track/fill/...</code>)
          en <code>Tect.aspx</code> / <code>Tect.aspx.cs</code>, el método
          <code>PersonasService.CalcularEstadisticasPorMateria()</code> y el DTO
          <code>BLL\DTO\EstadisticasMateria.cs</code> fueron eliminados por completo. El espacio que
          ocupaba se reasignó a <strong>Estadísticas de la Clase</strong> y a los paneles vecinos.
        </span>
      </div>

      <h3 class="doc-h3">Mejora visual del badge</h3>
      <p class="doc-p">
        El badge numérico de materias múltiples pasó de números encerrados en círculo Unicode
        (① ② ③…) — que se veían diminutos e inconsistentes dentro del círculo ámbar de fondo — a
        una "pill" con ícono 📚 + número en texto plano, fondo en degradado ámbar, sombra suave y
        una animación de hover más marcada (<code>scale(1.12)</code> + sombra más intensa).
      </p>

      <h3 class="doc-h3">Archivos involucrados</h3>
      <div class="ref-table-wrap">
        <table class="ref-table">
          <thead><tr><th>Archivo</th><th>Elemento</th><th>Rol</th></tr></thead>
          <tbody>
            <tr><td><code>Datos\Tect.aspx</code></td><td>aplicarBadgesMultiMateria() / agregarBadgeMultiMateria()</td><td>Agrupa filas por matrícula y agrega el badge</td></tr>
            <tr><td><code>Datos\Tect.aspx</code></td><td>mostrarPopoverMaterias()</td><td>Popover flotante + swap de fila visible, sin postback</td></tr>
            <tr><td><code>Datos\Tect.aspx</code></td><td>.multi-materia-badge / .materia-popover / .pop-*</td><td>CSS del badge y del popover</td></tr>
            <tr><td><code>Datos\Tect.aspx</code></td><td>.tb-actions--stack / .tb-actions-row</td><td>Toolbar de "Registros de Estudiantes" en 2 filas</td></tr>
            <tr><td><code>Datos\Tect.aspx</code></td><td>.bottom-grid / .chart-panel / .section-panel / #auditPanel / .stats-3col</td><td>Paneles inferiores compactos con scroll interno</td></tr>
            <tr><td><code>Datos\Tect.aspx.cs</code></td><td>GridDatos_RowDataBound</td><td>Agrega data-matricula / data-materia a cada &lt;tr&gt;</td></tr>
            <tr><td><code>Datos\Tect.aspx.cs</code></td><td>GridDatos_RowCommand</td><td>Parsea CommandArgument "Matricula|Materia"</td></tr>
            <tr><td><code>Datos\Tect.aspx.cs</code></td><td>MostrarPerfilAlumno()</td><td>Renderiza .perfil-materia-section por cada materia del alumno</td></tr>
            <tr><td><code>BLL\Fachada\AuditLogger.cs</code></td><td>ObtenerPorMatriculaYMateria()</td><td>Historial filtrado por matrícula + materia</td></tr>
          </tbody>
        </table>
      </div>
    </section>

  </div><%-- /docs-content --%>
</div><%-- /docs-page --%>

<script>
// @ts-nocheck
(function () {
  var links = document.querySelectorAll('.docs-nav-link[href^="#"]');
  var sections = Array.from(links).map(function (l) {
    var href = l.getAttribute('href');
    return href ? document.querySelector(href) : null;
  });

  /* índice de la última sección válida */
  var lastValid = 0;
  sections.forEach(function (s, i) { if (s) lastValid = i; });

  function onScroll() {
    var active = 0;
    var atBottom = (window.innerHeight + window.scrollY) >= document.body.scrollHeight - 40;

    if (atBottom) {
      /* al fondo de la página → siempre activa el último link */
      active = lastValid;
    } else {
      sections.forEach(function (s, i) {
        if (s && s.getBoundingClientRect().top <= 120) active = i;
      });
    }

    links.forEach(function (l) { l.classList.remove('active'); });
    if (links[active]) links[active].classList.add('active');
  }

  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
})();
</script>

</asp:Content>