<%@ Page Title="Grilla de Ordenamiento" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Datos.Contact" ResponseEncoding="UTF-8" ContentType="text/html; charset=utf-8" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
/* @ts-nocheck */
:root {
  --prom-great: #34d89c;
  --prom-mid: #f0a030;
  --prom-low: #ef5a5a;
}
.grilla-wrap {
  max-width: 1200px; margin: 0 auto; padding: 20px 24px 40px;
}
.grilla-header {
  margin-bottom: 24px;
}
.grilla-header h2 {
  font-size: 22px; font-weight: 600; color: var(--text); margin-bottom: 6px;
}
.grilla-header p {
  font-size: 13px; color: var(--text3);
}
.grilla-demo {
  background: var(--bg2); border: 1px solid var(--border);
  border-radius: var(--r2); overflow: hidden; margin-bottom: 20px;
}
.table-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: 14px 20px; border-bottom: 1px solid var(--border);
}
.table-title { font-size: 15px; font-weight: 600; color: var(--text); }
.badge-count {
  background: rgba(232,160,73,.12); color: var(--amber);
  font-size: 11px; font-weight: 600; padding: 3px 11px; border-radius: 20px;
}
.grilla-demo-toolbar {
  display: flex; align-items: center; gap: 10px; flex-wrap: wrap;
  padding: 12px 18px; border-bottom: 1px solid var(--border);
  background: rgba(255,255,255,.02);
}
.grilla-demo-toolbar input,
.grilla-demo-toolbar select {
  background: var(--bg3); border: 1px solid var(--border);
  border-radius: var(--r); padding: 7px 11px;
  color: var(--text); font-family: var(--font); font-size: 12px;
  outline: none; transition: border-color .15s;
}
.grilla-demo-toolbar input:focus,
.grilla-demo-toolbar select:focus { border-color: var(--amber); }
.grilla-demo-toolbar select {
  appearance: none; cursor: pointer;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='10' height='10' viewBox='0 0 24 24' fill='none' stroke='%238fa8c0' stroke-width='2'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
  background-repeat: no-repeat; background-position: right 8px center; padding-right: 28px;
}
.grilla-table-wrap { overflow-x: auto; }
.grilla-table { width: 100%; border-collapse: collapse; font-size: 13px; }
.grilla-table thead tr { background: var(--bg3); }
.grilla-table th {
  padding: 10px 14px; text-align: left;
  font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .08em;
  color: var(--text2); white-space: nowrap; cursor: pointer; user-select: none;
  border-bottom: 2px solid var(--border2);
}
.grilla-table th:hover { color: var(--text); }
.grilla-table th.asc::after  { content: ' ↑'; color: var(--amber); }
.grilla-table th.desc::after { content: ' ↓'; color: var(--amber); }
.grilla-table td {
  padding: 11px 14px; border-bottom: 1px solid var(--border); color: var(--text2); vertical-align: middle;
}
.grilla-table tbody tr:hover td { background: rgba(255,255,255,.02); }
.grilla-table tbody tr:last-child td { border-bottom: none; }
.prom-great { color: var(--teal); font-weight: 600; }
.prom-mid   { color: var(--amber); font-weight: 600; }
.prom-low   { color: var(--red); font-weight: 600; }
.situ-ok  { color: var(--teal); font-weight: 500; font-size: 12px; }
.situ-err { color: var(--red);  font-weight: 500; font-size: 12px; }
.pagination {
  display: flex; align-items: center; justify-content: center;
  gap: 4px; padding: 12px; border-top: 1px solid var(--border);
}
.page-btn {
  min-width: 32px; height: 32px; padding: 0 6px;
  background: var(--bg3); border: 1px solid var(--border);
  border-radius: var(--r); font-size: 12px; color: var(--text2);
  cursor: pointer; display: inline-flex; align-items: center; justify-content: center;
  transition: all .15s; font-family: var(--font);
}
.page-btn:hover { border-color: var(--amber); color: var(--amber); }
.page-btn.active { background: rgba(232,160,73,.12); border-color: var(--amber); color: var(--amber); font-weight: 700; }
.page-info { font-size: 11px; color: var(--text3); padding: 0 8px; }
.empty-state { padding: 40px 20px; text-align: center; }
.empty-icon { font-size: 32px; margin-bottom: 10px; opacity: .4; }
.empty-text { font-size: 13px; color: var(--text3); }
.docs-grid {
  display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 14px; margin-bottom: 20px;
}
.docs-card {
  background: var(--bg2); border: 1px solid var(--border);
  border-radius: var(--r2); padding: 20px; transition: border-color .2s;
}
.docs-card:hover { border-color: var(--border2); }
.docs-card-title {
  display: flex; align-items: center; gap: 10px;
  font-size: 14px; font-weight: 600; color: var(--text); margin-bottom: 14px;
}
.docs-card-icon {
  width: 28px; height: 28px; border-radius: var(--r);
  display: flex; align-items: center; justify-content: center;
  font-size: 13px; font-weight: 700; flex-shrink: 0;
}
.dc-amber .docs-card-icon { background: rgba(232,160,73,.12); color: var(--amber); }
.dc-teal  .docs-card-icon { background: rgba(45,212,160,.12); color: var(--teal); }
.dc-blue  .docs-card-icon { background: rgba(74,158,255,.12); color: var(--blue); }
.dc-purple .docs-card-icon { background: rgba(160,100,230,.12); color: var(--purple); }
.tech-stack { display: flex; flex-direction: column; gap: 6px; }
.tech-item {
  display: flex; justify-content: space-between; align-items: center;
  font-size: 12px; color: var(--text2); padding: 5px 0;
  border-bottom: 1px solid var(--border);
}
.tech-item:last-child { border-bottom: none; }
.tech-name { color: var(--text2); }
.tech-version { font-size: 11px; font-weight: 600; background: rgba(255,255,255,.04); padding: 2px 7px; border-radius: 4px; color: var(--text2); }
.tech-version.amber { color: var(--amber); background: rgba(232,160,73,.1); }
.tech-version.blue  { color: var(--blue);  background: rgba(74,158,255,.1); }
.code-section {
  background: var(--bg2); border: 1px solid var(--border);
  border-radius: var(--r2); overflow: hidden; margin-bottom: 20px;
}
.code-section-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: 10px 16px; background: var(--bg3); border-bottom: 1px solid var(--border);
}
.code-section-title { font-size: 13px; font-weight: 600; color: var(--text2); }
.code-lang { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .06em; color: var(--amber); }
pre.code-block {
  padding: 16px; font-family: var(--mono,'JetBrains Mono',monospace);
  font-size: 12px; color: var(--text2); line-height: 1.65; overflow-x: auto; margin: 0; tab-size: 2;
}
pre.code-block .kw   { color: #c792ea; }
pre.code-block .kw2  { color: var(--blue); }
pre.code-block .str  { color: var(--teal); }
pre.code-block .cmt  { color: var(--text3); font-style: italic; }
pre.code-block .prop { color: var(--amber); }
pre.code-block .num  { color: #f78c6c; }
.badge { display: inline-block; padding: 3px 9px; border-radius: 6px; font-size: 11px; font-weight: 500; }
.badge-prog  { background: rgba(74,158,255,.12); color: #5aadff; }
.badge-hist  { background: rgba(160,100,230,.12); color: #b87eff; }
.badge-etica { background: rgba(45,212,160,.12);  color: var(--teal); }
.badge-fis   { background: rgba(232,160,73,.12);  color: var(--amber); }
.badge-mat   { background: rgba(224,85,85,.12);   color: #ff7a7a; }
.fade-up { animation: fadeUp .4s ease both; }
.fade-up-1 { animation-delay: .1s; }
.fade-up-2 { animation-delay: .2s; }
.fade-up-3 { animation-delay: .3s; }
@keyframes fadeUp { from { opacity:0; transform:translateY(12px); } to { opacity:1; transform:translateY(0); } }
</style>

<div class="grilla-wrap">

  <!-- Header -->
  <div class="grilla-header fade-up">
    <h2>Grilla de Ordenamiento</h2>
    <p>Demo interactiva — búsqueda, filtrado multicolumna y paginación sobre el GridView de ASP.NET</p>
  </div>

  <!-- Demo interactiva (JS puro — sin postback) -->
  <div class="grilla-demo fade-up fade-up-1">
    <div class="table-header">
      <span class="table-title">Demo en vivo</span>
      <span class="badge-count" id="grillaCount">10 registros</span>
    </div>

    <div class="grilla-demo-toolbar">
      <input type="text" id="grillaSearch" placeholder="🔍  Buscar por nombre o matrícula..." style="flex:1;min-width:180px" />
      <select id="grillaSubject">
        <option value="">— Todas las materias —</option>
        <option>Lenguaje de Programación 2</option>
        <option>Historia y Filosofía de la Ciencia</option>
        <option>Ética Personal</option>
        <option>Física 3</option>
        <option>Matemática para Informáticos</option>
      </select>
      <select id="grillaPageSize">
        <option value="5">5 por página</option>
        <option value="10" selected>10 por página</option>
        <option value="20">20 por página</option>
      </select>
    </div>

    <div class="grilla-table-wrap">
      <table class="grilla-table" id="grillaTable">
        <thead>
          <tr>
            <th data-col="matricula">Matrícula</th>
            <th data-col="nombre">Nombre</th>
            <th data-col="materia">Materia</th>
            <th data-col="p1">P1</th>
            <th data-col="p2">P2</th>
            <th data-col="tp">TP</th>
            <th data-col="final">Final</th>
            <th data-col="total">Total</th>
            <th data-col="prom">Prom.</th>
            <th data-col="situ">Situación</th>
          </tr>
        </thead>
        <tbody id="grillaBody"></tbody>
      </table>
    </div>

    <div class="pagination" id="grillaPag"></div>
  </div>

  <!-- Sección: ¿Qué implementa esta página? -->
  <div class="docs-grid fade-up fade-up-2">

    <div class="docs-card dc-amber">
      <div class="docs-card-title">
        <div class="docs-card-icon">↕</div>
        Ordenamiento multicolumna
      </div>
      <div class="tech-stack">
        <div class="tech-item"><span class="tech-name">Click en encabezado</span><span class="tech-version">ASC / DESC</span></div>
        <div class="tech-item"><span class="tech-name">AllowSorting</span><span class="tech-version amber">true</span></div>
        <div class="tech-item"><span class="tech-name">OnSorting</span><span class="tech-version amber">GridView1_Sorting</span></div>
        <div class="tech-item"><span class="tech-name">SortExpression</span><span class="tech-version amber">por columna</span></div>
      </div>
    </div>

    <div class="docs-card dc-teal">
      <div class="docs-card-title">
        <div class="docs-card-icon">⌕</div>
        Búsqueda en tiempo real
      </div>
      <div class="tech-stack">
        <div class="tech-item"><span class="tech-name">AutoPostBack</span><span class="tech-version">true</span></div>
        <div class="tech-item"><span class="tech-name">OnTextChanged</span><span class="tech-version">txtSearch_Changed</span></div>
        <div class="tech-item"><span class="tech-name">LIKE %valor%</span><span class="tech-version">SQL filter</span></div>
        <div class="tech-item"><span class="tech-name">Archivo</span><span class="tech-version">Tect.aspx.cs</span></div>
      </div>
    </div>

    <div class="docs-card dc-blue">
      <div class="docs-card-title">
        <div class="docs-card-icon">◫</div>
        Paginación
      </div>
      <div class="tech-stack">
        <div class="tech-item"><span class="tech-name">AllowPaging</span><span class="tech-version blue">true</span></div>
        <div class="tech-item"><span class="tech-name">PageSize</span><span class="tech-version blue">10</span></div>
        <div class="tech-item"><span class="tech-name">OnPageIndexChanging</span><span class="tech-version blue">evento</span></div>
        <div class="tech-item"><span class="tech-name">Archivo</span><span class="tech-version blue">Tect.aspx</span></div>
      </div>
    </div>

    <div class="docs-card dc-purple">
      <div class="docs-card-title">
        <div class="docs-card-icon">⬇</div>
        Exportar filtrados
      </div>
      <div class="tech-stack">
        <div class="tech-item"><span class="tech-name">btnExportar_Click</span><span class="tech-version">Excel</span></div>
        <div class="tech-item"><span class="tech-name">btnCSV_Click</span><span class="tech-version">CSV</span></div>
        <div class="tech-item"><span class="tech-name">Respeta filtros</span><span class="tech-version">activos</span></div>
        <div class="tech-item"><span class="tech-name">Archivo</span><span class="tech-version">Tect.aspx.cs</span></div>
      </div>
    </div>

  </div>

  <!-- Código de referencia -->
  <div class="code-section fade-up fade-up-3">
    <div class="code-section-header">
      <span class="code-section-title">GridView — atributos clave (Tect.aspx)</span>
      <span class="code-lang">ASP.NET / C#</span>
    </div>
    <pre class="code-block"><span class="cmt">&lt;!-- Atributos en el GridView de Tect.aspx --&gt;</span>
<span class="prop">&lt;asp:GridView</span> <span class="kw">ID</span>=<span class="str">"GridView1"</span> <span class="kw">runat</span>=<span class="str">"server"</span>
  <span class="kw">AllowPaging</span>=<span class="str">"True"</span>
  <span class="kw">PageSize</span>=<span class="str">"10"</span>
  <span class="kw">OnPageIndexChanging</span>=<span class="str">"GridView1_PageIndexChanging"</span>
  <span class="kw">AllowSorting</span>=<span class="str">"True"</span>
  <span class="kw">OnSorting</span>=<span class="str">"GridView1_Sorting"</span>
  <span class="kw">AutoGenerateColumns</span>=<span class="str">"False"</span> <span class="prop">&gt;</span>

  <span class="cmt">&lt;!-- Columna Situación (TemplateField) --&gt;</span>
  <span class="prop">&lt;asp:TemplateField</span> <span class="kw">HeaderText</span>=<span class="str">"Situación"</span><span class="prop">&gt;</span>
    <span class="prop">&lt;ItemTemplate&gt;</span>
      <span class="prop">&lt;asp:Label</span> <span class="kw">runat</span>=<span class="str">"server"</span>
        <span class="kw">Text</span>=<span class="str">'&lt;%# GetSituacion(Convert.ToDouble(Eval("Promedio"))) %&gt;'</span>
        <span class="kw">CssClass</span>=<span class="str">'&lt;%# GetSituacionClass(Convert.ToDouble(Eval("Promedio"))) %&gt;'</span> <span class="prop">/&gt;</span>
    <span class="prop">&lt;/ItemTemplate&gt;</span>
  <span class="prop">&lt;/asp:TemplateField&gt;</span>

<span class="prop">&lt;/asp:GridView&gt;</span>

<span class="cmt">// Tect.aspx.cs — Ordenamiento</span>
<span class="kw">protected void</span> GridView1_Sorting(<span class="kw">object</span> sender, GridViewSortEventArgs e)
{
    <span class="kw">string</span> sortExp  = e.SortExpression;
    <span class="kw">string</span> sortDir  = GetSortDirection(sortExp);  <span class="cmt">// "ASC" / "DESC"</span>
    ViewState[<span class="str">"SortCol"</span>] = sortExp;
    ViewState[<span class="str">"SortDir"</span>] = sortDir;
    BindGrid();
}

<span class="kw">protected void</span> GridView1_PageIndexChanging(<span class="kw">object</span> sender, GridViewPageEventArgs e)
{
    GridView1.PageIndex = e.NewPageIndex;
    BindGrid();
}</pre>
  </div>

</div>

<script>
// @ts-nocheck
// ── Datos desde Session (Tect.aspx) o vacío ──────────────────
var DEMO_DATA = typeof SESSION_DATA !== 'undefined' && SESSION_DATA.length > 0
  ? SESSION_DATA
  : [];
var NO_DATA = DEMO_DATA.length === 0;

/** @type {string} */
var sortCol = '';
var sortDir = 'asc', page = 0;
var filtered = DEMO_DATA.slice();

/** @param {number} p */
function promClass(p) { return p >= 4 ? 'prom-great' : p >= 3 ? 'prom-mid' : 'prom-low'; }
/** @param {number} p */
function situ(p)      { return p >= 3 ? '<span class="situ-ok">Aprobado ✓</span>' : '<span class="situ-err">Reprobado ✗</span>'; }
/** @param {string} m */
function matBadge(m)  {
  var map = /** @type {Record<string,string>} */ ({
    'Lenguaje de Programación 2': 'badge-prog',
    'Historia y Filosofía de la Ciencia': 'badge-hist',
    'Ética Personal':             'badge-etica',
    'Física 3':                   'badge-fis',
    'Matemática para Informáticos':'badge-mat'
  });
  return '<span class="badge ' + (map[m]||'') + '">' + m.split(' ').slice(0,2).join(' ') + '</span>';
}

function applyFilters() {
  /** @type {HTMLInputElement | null} */
  var qEl = document.getElementById('grillaSearch');
  /** @type {HTMLSelectElement | null} */
  var sbEl = document.getElementById('grillaSubject');
  var q  = (qEl ? qEl.value : '').toLowerCase();
  var sb = sbEl ? sbEl.value : '';
  filtered = DEMO_DATA.filter(function(r) {
    var matchQ  = !q  || r.nombre.toLowerCase().indexOf(q) !== -1 || r.matricula.toLowerCase().indexOf(q) !== -1;
    var matchSb = !sb || r.materia === sb;
    return matchQ && matchSb;
  });
  if (sortCol) {
    filtered.sort(/** @param {any} a @param {any} b */ function(a, b) {
      var av = a[sortCol], bv = b[sortCol];
      if (typeof av === 'string') av = av.toLowerCase(), bv = bv.toLowerCase();
      return sortDir === 'asc' ? (av > bv ? 1 : -1) : (av < bv ? 1 : -1);
    });
  }
  page = 0;
  render();
}

function render() {
  /** @type {HTMLSelectElement | null} */
  var psEl = document.getElementById('grillaPageSize');
  var ps   = parseInt(psEl ? psEl.value : '10');
  var total= filtered.length;
  var pages= Math.max(1, Math.ceil(total / ps));
  if (page >= pages) page = pages - 1;
  var slice = filtered.slice(page * ps, (page + 1) * ps);

  var tbody = document.getElementById('grillaBody');
  if (NO_DATA) {
    if (tbody) tbody.innerHTML = '<tr><td colspan="11" class="empty-state"><div class="empty-icon">📋</div><div class="empty-text">No hay estudiantes registrados. Ve a <strong>Sistema de Calificaciones</strong> para agregar registros.</div></td></tr>';
    var countEl = document.getElementById('grillaCount');
    if (countEl) countEl.textContent = 'Sin datos';
    var pag = document.getElementById('grillaPag');
    if (pag) pag.innerHTML = '';
    return;
  }
  if (tbody) {
    tbody.innerHTML = slice.map(function(r) {
      return '<tr>'
        + '<td style="font-family:var(--mono);font-size:12px;color:var(--text3)">' + r.matricula + '</td>'
        + '<td style="font-weight:500">' + r.nombre + '</td>'
        + '<td>' + matBadge(r.materia) + '</td>'
        + '<td>' + r.p1 + '</td><td>' + r.p2 + '</td><td>' + r.tp + '</td><td>' + r.final + '</td>'
        + '<td style="color:var(--amber);font-weight:600">' + r.total + '</td>'
        + '<td><span class="' + promClass(r.prom) + '">' + r.prom.toFixed(2) + '</span></td>'
        + '<td>' + situ(r.prom) + '</td>'
        + '</tr>';
    }).join('');
  }

  // count badge
  var countEl = document.getElementById('grillaCount');
  if (countEl) {
    if (NO_DATA) {
      countEl.textContent = 'Sin datos';
    } else {
      countEl.textContent = total + ' registro' + (total !== 1 ? 's' : '');
    }
  }

  // pagination
  var pag = document.getElementById('grillaPag');
  if (!pag) return;
  if (pages <= 1) { pag.innerHTML = ''; return; }
  var html = '<button class="page-btn" onclick="goPage(' + (page - 1) + ')">‹</button>';
  for (var i = 0; i < pages; i++) {
    html += '<button class="page-btn' + (i === page ? ' active' : '') + '" onclick="goPage(' + i + ')">' + (i + 1) + '</button>';
  }
  html += '<button class="page-btn" onclick="goPage(' + (page + 1) + ')">›</button>';
  html += '<span class="page-info">Pág. ' + (page + 1) + ' de ' + pages + '</span>';
  pag.innerHTML = html;
}

/** @param {number} p */
function goPage(p) {
  /** @type {HTMLSelectElement | null} */
  var psEl = document.getElementById('grillaPageSize');
  var ps = parseInt(psEl ? psEl.value : '10');
  var pages = Math.max(1, Math.ceil(filtered.length / ps));
  if (p < 0 || p >= pages) return;
  page = p;
  render();
}

// Encabezados ordenables
document.querySelectorAll('#grillaTable th').forEach(function(th) {
  th.addEventListener('click', function(e) {
    var col = th.getAttribute('data-col') || '';
    if (sortCol === col) {
      sortDir = sortDir === 'asc' ? 'desc' : 'asc';
    } else {
      sortCol = col;
      sortDir = 'asc';
    }
    document.querySelectorAll('#grillaTable th').forEach(function(h){ h.className = ''; });
    th.className = sortDir;
    applyFilters();
  });
});

// Eventos de filtro
var searchEl = document.getElementById('grillaSearch');
var subjectEl = document.getElementById('grillaSubject');
var pageSizeEl = document.getElementById('grillaPageSize');
if (searchEl) searchEl.addEventListener('input', applyFilters);
if (subjectEl) subjectEl.addEventListener('change', applyFilters);
if (pageSizeEl) pageSizeEl.addEventListener('change', applyFilters);

// Render inicial
applyFilters();
</script>

</asp:Content>
