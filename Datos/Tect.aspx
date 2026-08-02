<%@ Page Title="Sistema de Calificaciones" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tect.aspx.cs" Inherits="Datos.Tect" ResponseEncoding="UTF-8" ContentType="text/html; charset=utf-8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="<%: ResolveUrl("~/Content/Calificaciones.css?v=9") %>" rel="stylesheet" type="text/css" />

    <style>
    /*
       OVERRIDES FINALES — React prototype colors !important
       Domina Bootstrap + site-rediseno.css
    */

    /* ── Bootstrap button reset completo ── */
    input[type="submit"], input[type="button"], button,
    input[type="submit"]:hover, input[type="button"]:hover, button:hover,
    input[type="submit"]:focus, input[type="button"]:focus, button:focus,
    input[type="submit"]:active, input[type="button"]:active, button:active {
      background-image: none !important;
      text-shadow: none !important;
      box-shadow: none !important;
      outline: none !important;
    }

    body { background: var(--bg) !important; color: var(--text) !important; }

    /* ── Toolbar: permite acomodar grupos en varias líneas si no entran ── */
    .toolbar { flex-wrap: wrap !important; overflow-x: visible !important; row-gap: 10px !important; }

    /* ── Acciones de la tabla en dos filas (Limpiar/Excel/CSV + Importar/Imprimir/Log) ── */
    .tb-actions--stack { display: flex !important; flex-direction: column !important; align-items: flex-start !important; gap: 6px !important; }
    .tb-actions-row { display: flex !important; align-items: center !important; gap: 6px !important; flex-wrap: nowrap !important; }

    /* ── Botones toolbar — override Bootstrap link ── */
    .tbtn, a.tbtn {
      display: inline-flex !important;
      align-items: center !important;
      text-decoration: none !important;
      white-space: nowrap !important;
      background-image: none !important;
    }
    .tbtn svg { flex-shrink: 0; }

    /* ── Botones de acción tabla — override Bootstrap input ── */
    input.act-edit, input.act-del,
    .act-btn {
      white-space: nowrap !important;
      background-image: none !important;
      text-shadow: none !important;
      box-shadow: none !important;
    }

    /* ── Tabla — override Bootstrap .table ── */
    .data-table { border-collapse: collapse !important; }
    .data-table thead tr { background: var(--bg3) !important; }
    .data-table th {
      background: var(--bg3) !important;
      color: var(--text2) !important;
      border-bottom: 2px solid var(--amber3) !important;
      border-top: none !important;
      font-size: 10px !important;
      font-weight: 700 !important;
      text-transform: uppercase !important;
      letter-spacing: 0.08em !important;
    }
    .data-table td {
      border-color: var(--border) !important;
      vertical-align: middle !important;
    }
    .data-table tbody tr:hover td { background: rgba(255,255,255,0.02) !important; }

    /* ── Campos formulario — override Bootstrap ── */
    .field, select.field {
      background: var(--bg4) !important;
      color: var(--text) !important;
      border: 1px solid var(--border2) !important;
    }
    .field:focus, select.field:focus {
      background: var(--bg4) !important;
      border-color: var(--amber) !important;
      box-shadow: 0 0 0 3px rgba(240,160,48,0.12) !important;
      outline: none !important;
    }
    .field::placeholder { color: var(--text3) !important; }

    /* ── Toolbar field ── */
    .tb-field, select.tb-field {
      background: var(--bg2) !important;
      color: var(--text) !important;
      border: 1px solid var(--border2) !important;
    }

    /* ── Input de archivo (restaurar sesión) ── */
    .tb-file-input {
      max-width: 150px !important;
      font-size: 11px !important;
      color: var(--text2) !important;
    }

    /* ── Perfil de alumno (modal) ── */
    .perfil-info div {
      padding: 6px 0;
      font-size: 13px;
      color: var(--text2);
      border-bottom: 1px solid var(--border);
    }
    .perfil-info div:last-child { border-bottom: none; }
    .perfil-info strong { color: var(--text); }
    .perfil-notas-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 10px;
      margin: 16px 0;
    }
    .perfil-nota-item {
      background: var(--bg3);
      border-radius: var(--r);
      padding: 10px 8px;
      text-align: center;
    }
    .perfil-nota-label {
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: .05em;
      color: var(--text3);
    }
    .perfil-nota-val {
      font-size: 15px;
      font-weight: 600;
      color: var(--text);
      margin-top: 4px;
    }
    .perfil-hist-title {
      font-size: 11px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: .05em;
      color: var(--text3);
      margin: 14px 0 10px;
    }

    /* ── Perfil con múltiples materias: separadores por sección ── */
    .perfil-materia-section {
      padding: 20px 0;
      border-top: 1px solid var(--border);
    }
    .perfil-materia-section:first-of-type { border-top: none; padding-top: 10px; }
    .perfil-materia-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 4px;
    }
    .perfil-materia-name { font-size: 14px; font-weight: 700; }

    /* ── Badge numérico de materias múltiples (grilla) ── */
    .multi-materia-badge {
      display: inline-flex;
      align-items: center;
      gap: 3px;
      height: 18px;
      padding: 0 6px;
      background: linear-gradient(135deg, var(--amber), #ffb84d);
      color: #1a0f00;
      font-size: 11px;
      font-weight: 800;
      line-height: 1;
      border-radius: 999px;
      margin-left: 6px;
      cursor: pointer;
      vertical-align: middle;
      box-shadow: 0 1px 3px rgba(0,0,0,.35);
      transition: transform .15s, box-shadow .15s;
    }
    .multi-materia-badge__icon { font-size: 10px; line-height: 1; }
    .multi-materia-badge__num { font-size: 11px; }
    .multi-materia-badge:hover {
      transform: scale(1.12);
      box-shadow: 0 2px 6px rgba(0,0,0,.45);
    }

    /* ── Popover flotante: materias registradas ── */
    .materia-popover {
      position: fixed;
      background: var(--bg2);
      border: 1px solid var(--border);
      border-radius: var(--r);
      padding: 6px 0;
      min-width: 190px;
      z-index: 1100;
      box-shadow: var(--shadow);
    }
    .pop-title {
      font-size: 10px;
      color: var(--text3);
      letter-spacing: .08em;
      text-transform: uppercase;
      padding: 4px 12px 8px;
      border-bottom: 1px solid var(--border);
      margin-bottom: 4px;
    }
    .pop-item {
      font-size: 12px;
      color: var(--text2);
      padding: 6px 12px;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 8px;
      transition: background .1s;
    }
    .pop-item:hover { background: var(--bg3); color: var(--text); }
    .pop-item-actual { color: var(--text3); cursor: default; }
    .pop-item-actual:hover { background: transparent; color: var(--text3); }
    .pop-dot { width: 6px; height: 6px; border-radius: 50%; background: var(--amber); flex-shrink: 0; }
    .pop-tag {
      font-size: 9px;
      background: var(--bg3);
      color: var(--text3);
      padding: 1px 5px;
      border-radius: 4px;
      margin-left: auto;
    }

    /* ── Importar desde Excel (modal) ── */
    .import-preview-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 12px;
      margin-bottom: 12px;
    }
    .import-preview-table th, .import-preview-table td {
      padding: 5px 8px;
      border-bottom: 1px solid var(--border);
      text-align: left;
      white-space: nowrap;
    }
    .import-preview-table th {
      color: var(--text3);
      font-size: 10px;
      text-transform: uppercase;
      letter-spacing: .05em;
    }
    .import-row-ok td:first-child { border-left: 3px solid var(--teal); }
    .import-row-duplicado td:first-child { border-left: 3px solid var(--amber); }
    .import-row-error td:first-child { border-left: 3px solid var(--red); }
    .import-row-estado { font-size: 11px; font-weight: 600; }
    .import-row-ok .import-row-estado { color: var(--teal); }
    .import-row-duplicado .import-row-estado { color: var(--amber); }
    .import-row-error .import-row-estado { color: var(--red); }
    .import-dup-options {
      display: block;
      background: var(--bg3);
      border-radius: var(--r);
      padding: 10px 12px;
      margin-bottom: 10px;
    }
    .import-rbl label { margin-right: 16px; font-size: 12px; color: var(--text2); }
    .import-summary { font-size: 12px; color: var(--text2); margin-bottom: 10px; }

    /* ── Aviso de nota muy baja (no bloquea el envío) ── */
    .field.warn { border-color: var(--amber) !important; }
    .hint-warn { display: block; color: var(--amber); font-size: 11px; margin-top: 3px; }

    /* ── Indicador de capacidad de sesión ── */
    .capacidad-info { font-size: 11px; color: var(--text3); margin-left: 10px; }
    .capacidad-warn { color: var(--amber) !important; }

    /* ── Paneles (variables = siguen el tema) ── */
    .panel { background: var(--bg2) !important; border-color: var(--border) !important; }
    .table-panel { background: var(--bg2) !important; border-color: var(--border) !important; }
    .section-panel { background: var(--bg2) !important; border-color: var(--border) !important; }
    .stat-card { background: var(--bg2) !important; border-color: var(--border) !important; }
    .chart-panel { background: var(--bg2) !important; border-color: var(--border) !important; }
    .history-panel { background: var(--bg2) !important; border-color: var(--border) !important; }
    .stats-bottom { background: var(--bg2) !important; border-color: var(--border) !important; }
    .stats-bottom-body { background: var(--bg2) !important; border-color: var(--border) !important; }

    /* ── Mosaico de distribución — layout fix (compacto) ── */
    .mosaic-grid     { display: flex !important; flex-direction: column !important; gap: 10px !important; margin-bottom: 10px !important; width: 100% !important; flex: 0 0 auto !important; justify-content: space-evenly !important; min-height: 180px !important; }
    .mosaic-row      { display: flex !important; align-items: center !important; gap: 8px !important; flex-wrap: nowrap !important; width: 100% !important; min-width: 0 !important; flex: 1 !important; }
    .mosaic-range    { font-size: 11px !important; color: #6a7e92 !important; width: 32px !important; min-width: 32px !important; flex-shrink: 0 !important; text-align: right !important; font-family: 'JetBrains Mono',monospace !important; }
    .mosaic-cells    { display: flex !important; gap: 3px !important; flex: 1 1 0% !important; min-width: 0 !important; height: 100% !important; overflow: visible !important; }
    .mosaic-cell     { height: 100% !important; min-height: 24px !important; border-radius: 3px !important; flex: 1 1 0% !important; min-width: 0 !important; position: relative !important; cursor: pointer !important; transition: transform .12s,opacity .12s !important; overflow: visible !important; box-sizing: border-box !important; }
    .mosaic-cell.empty  { opacity: .12 !important; cursor: default !important; }
    .mosaic-cell.filled { opacity: 1 !important; }
    .mosaic-cell.filled:hover { transform: scaleY(1.18) !important; z-index: 5 !important; opacity: .82 !important; }
    .mosaic-count    { font-size: 11px !important; font-weight: 600 !important; color: #dde8f0 !important; min-width: 18px !important; text-align: right !important; flex-shrink: 0 !important; font-family: 'JetBrains Mono',monospace !important; }
    .mosaic-pct      { font-size: 10px !important; color: #6a7e92 !important; min-width: 34px !important; text-align: right !important; flex-shrink: 0 !important; font-family: 'JetBrains Mono',monospace !important; }
    .mosaic-legend   { display: flex !important; align-items: center !important; gap: 6px !important; padding-top: 6px !important; border-top: 1px solid rgba(255,255,255,.07) !important; font-size: 11px !important; color: #6a7e92 !important; flex-wrap: wrap !important; }
    .mosaic-legend-hint { margin-left: auto !important; font-style: italic !important; font-size: 11px !important; color: #6a7e92 !important; }
    .mosaic-legend-sep  { display: inline-flex !important; align-items: center !important; gap: 6px !important; margin-left: 10px !important; }
    .mosaic-legend-dot  { width: 11px !important; height: 11px !important; border-radius: 3px !important; flex-shrink: 0 !important; display: inline-block !important; vertical-align: middle !important; }
    .mosaic-legend-dot--filled { background: #2dd4a0 !important; }
    .mosaic-legend-dot--empty  { background: #6a7e92 !important; opacity: .25 !important; }

    /* ── Paneles inferiores: mosaico, auditoría, estadísticas (compactos pero con más aire) ── */
    .bottom-grid       { gap: 16px !important; margin-top: 14px !important; align-items: stretch !important; }
    .chart-panel       { padding: 18px 20px !important; margin-top: 0 !important; display: flex !important; flex-direction: column !important; align-self: stretch !important; }
    .chart-panel__header { margin-bottom: 10px !important; }
    .section-panel     { padding: 0 !important; margin-top: 0 !important; align-self: stretch !important; display: flex !important; flex-direction: column !important; }
    .section-panel > .section-head { padding: 12px 20px !important; margin-bottom: 0 !important; flex-shrink: 0 !important; }
    .section-panel > .stats-bottom-body,
    .section-panel > .history-body {
      padding: 16px 20px !important; margin-top: 0 !important;
      border: none !important; box-shadow: none !important; border-radius: 0 !important;
    }
    #auditPanel        { max-height: 400px !important; overflow-y: auto !important; }
    .history-item      { padding: 14px 0 !important; gap: 14px !important; }
    .stats-3col        { gap: 14px !important; }
    .stat-col          { padding: 4px 14px !important; }
    .stat-col-label    { margin-bottom: 4px !important; }
    .stat-col-val      { font-size: 24px !important; }
    .stat-col-name     { margin-top: 2px !important; }

    /* ── Modal genérico (confirmaciones, perfil, historial por alumno) ── */
    .modal-overlay {
      position: fixed; inset: 0; background: rgba(0,0,0,.55);
      display: none; align-items: center; justify-content: center;
      z-index: 1000; padding: 20px;
    }
    .modal-overlay.show { display: flex !important; }
    .modal-box {
      background: var(--bg2) !important; border: 1px solid var(--border) !important;
      border-radius: var(--r2); box-shadow: var(--shadow);
      padding: 24px; max-width: 480px; width: 100%;
      max-height: 85vh; overflow-y: auto;
    }
    .modal-title { font-size: 15px; font-weight: 600; color: var(--text); margin-bottom: 14px; }
    .modal-body { font-size: 13px; color: var(--text2); }
    .modal-resumen div { padding: 4px 0; border-bottom: 1px solid var(--border); }
    .modal-resumen div:last-child { border-bottom: none; }
    .modal-resumen strong { color: var(--text); }
    .modal-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 18px; }
    .modal-actions .tbtn { cursor: pointer; border: none; padding: 8px 16px; border-radius: var(--r); font-size: 12px; }

    /* ── Igualar alturas: distribución vs auditoría ── */
.bottom-grid > .chart-panel,
.bottom-grid > .audit-card {
    height: 320px !important;
    max-height: 320px !important;
    overflow: hidden !important;
}

/* el body de auditoría ocupa el resto y scrollea adentro */
#auditPanel {
    flex: 1 1 auto !important;
    min-height: 0 !important;     /* clave: sin esto el overflow no funciona en flex */
    max-height: none !important;  /* anula el 400px viejo */
    overflow-y: auto !important;
}
    </style>

    <!-- ══════════════════════════════════════════════
         STATS ROW — 3 tarjetas ancho completo
    ══════════════════════════════════════════════ -->
    <div class="stats-row">
        <div class="stat-card c-neutral">
            <div class="stat-label">Estudiantes</div>
            <div class="stat-value v-default" id="statTotal">0</div>
        </div>
        <div class="stat-card c-teal">
            <div class="stat-label">Promedio general</div>
            <div class="stat-value v-teal" id="statProm">&mdash;</div>
        </div>
        <div class="stat-card c-amber">
            <div class="stat-label">Mejor calificaci&oacute;n</div>
            <div class="stat-value v-amber" id="statAprobados">&mdash;</div>
        </div>
    </div>

    <!-- ══════════════════════════════════════════════
         LAYOUT GRID: formulario 340px + columna derecha
    ══════════════════════════════════════════════ -->
    <div class="layout-grid">

        <!-- ── COLUMNA IZQUIERDA: FORMULARIO ── -->
        <div class="panel">

            <div class="panel-label" id="panelLabel">Nuevo registro</div>

            <div class="form-group">
                <label for="TxtMatricula">Matr&iacute;cula / N&uacute;mero</label>
                <asp:TextBox ID="TxtMatricula" runat="server" CssClass="field" placeholder="Ej: AB1234"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="TxtNombre">Nombre y Apellido</label>
                <asp:TextBox ID="TxtNombre" runat="server" CssClass="field" placeholder="Nombre completo..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="DdlMateria">Materia</label>
                <asp:DropDownList ID="DdlMateria" runat="server" CssClass="field">
                    <asp:ListItem Text="&#8212; Seleccione una materia &#8212;" Value=""></asp:ListItem>
                    <asp:ListItem Text="Lenguaje de Programaci&#243;n 2" Value="Lenguaje de Programación 2"></asp:ListItem>
                    <asp:ListItem Text="Historia y Filosof&#237;a de la Ciencia" Value="Historia y Filosofía de la Ciencia"></asp:ListItem>
                    <asp:ListItem Text="&#201;tica Personal" Value="Ética Personal"></asp:ListItem>
                    <asp:ListItem Text="F&#237;sica 3" Value="Física 3"></asp:ListItem>
                    <asp:ListItem Text="Matem&#225;tica para Inform&#225;ticos" Value="Matemática para Informáticos"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="TxtParcial1">Parcial 1 <span class="hint">(0&#8211;20)</span></label>
                    <asp:TextBox ID="TxtParcial1" runat="server" CssClass="field" TextMode="Number" min="0" max="20" step="0.5" placeholder="0-20"></asp:TextBox>
                    <span class="hint-warn" id="warnP1" style="display:none">Nota muy baja</span>
                </div>
                <div class="form-group">
                    <label for="TxtParcial2">Parcial 2 <span class="hint">(0&#8211;20)</span></label>
                    <asp:TextBox ID="TxtParcial2" runat="server" CssClass="field" TextMode="Number" min="0" max="20" step="0.5" placeholder="0-20"></asp:TextBox>
                    <span class="hint-warn" id="warnP2" style="display:none">Nota muy baja</span>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="TxtTP">TP <span class="hint">(0&#8211;10)</span></label>
                    <asp:TextBox ID="TxtTP" runat="server" CssClass="field" TextMode="Number" min="0" max="10" step="0.5" placeholder="0-10"></asp:TextBox>
                    <span class="hint-warn" id="warnTP" style="display:none">Nota muy baja</span>
                </div>
                <div class="form-group">
                    <label for="TxtExamenFinal">Examen Final <span class="hint">(0&#8211;50)</span></label>
                    <asp:TextBox ID="TxtExamenFinal" runat="server" CssClass="field" TextMode="Number" min="0" max="50" step="0.5" placeholder="0-50"></asp:TextBox>
                    <span class="hint-warn" id="warnEF" style="display:none">Nota muy baja</span>
                </div>
            </div>

            <asp:HiddenField ID="HfMatriculaEdicion" runat="server" Value="" />
            <asp:HiddenField ID="HfMateriaEdicion" runat="server" Value="" />

            <asp:Button ID="btnProcesar" runat="server" CssClass="btn-submit" Text="Procesar Registro" OnClick="btn_Click" />
            <asp:Button ID="btnGuardarEdicion" runat="server" CssClass="btn-submit btn-save" Text="Actualizar Registro" OnClick="btnGuardarEdicion_Click" Visible="false" />
            <asp:Button ID="btnCancelarEdicion" runat="server" CssClass="btn-submit btn-cancel" Text="Cancelar Edici&#243;n" OnClick="btnCancelarEdicion_Click" Visible="false" />

            <asp:Label ID="btnMensaje" runat="server" Text="" CssClass="msg-toast" style="display:none"></asp:Label>

            <!-- Vista previa del cálculo (JS la muestra) -->
            <div id="previewSection" style="display:none">
                <div class="divider"></div>
                <div class="panel-label">Vista previa</div>
                <div class="preview-grid">
                    <div class="preview-card">
                        <div class="preview-label">Total</div>
                        <div class="preview-val" id="prevTotal" style="color:var(--amber)">&mdash;</div>
                    </div>
                    <div class="preview-card">
                        <div class="preview-label">Promedio</div>
                        <div class="preview-val" id="prevProm">&mdash;</div>
                    </div>
                </div>
                <div id="prevSituacion" style="margin-top:8px;text-align:center;font-size:12px;font-weight:600;"></div>
            </div>

        </div><!-- /panel -->

        <!-- ── COLUMNA DERECHA: TABLA + SECCIONES INFERIORES ── -->
        <div>

            <!-- TABLE PANEL -->
            <div class="table-panel">

                <div class="table-head">
                    <span class="table-title">Registros de Estudiantes</span>
                    <span class="badge-count" id="tableBadge">0 entradas</span>
                </div>

                <!-- Toolbar -->
                <div class="toolbar">

                    <div class="tb-group">
                        <span class="tb-label">B&uacute;squeda r&aacute;pida</span>
                        <asp:TextBox ID="TxtBusqueda" runat="server" CssClass="tb-field"
                            placeholder="Matr&iacute;cula / nombre..."
                            Width="160px"
                            AutoPostBack="true"
                            OnTextChanged="TxtBusqueda_TextChanged" />
                    </div>

                    <div class="tb-sep"></div>

                    <div class="tb-group">
                        <span class="tb-label">Filtrar por materia</span>
                        <asp:DropDownList ID="DdlFiltroMateria" runat="server" CssClass="tb-field"
                            Width="150px"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="DdlFiltroMateria_SelectedIndexChanged">
                            <asp:ListItem Value="">&#8212; Todas &#8212;</asp:ListItem>
                            <asp:ListItem>Lenguaje de Programaci&#243;n 2</asp:ListItem>
                            <asp:ListItem>Historia y Filosof&#237;a de la Ciencia</asp:ListItem>
                            <asp:ListItem>&#201;tica Personal</asp:ListItem>
                            <asp:ListItem>F&#237;sica 3</asp:ListItem>
                            <asp:ListItem>Matem&#225;tica para Inform&#225;ticos</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="tb-sep"></div>

                    <div class="tb-group">
                        <span class="tb-label">Ordenar por</span>
                        <div style="display:flex;align-items:center;gap:6px">
                            <asp:DropDownList ID="DdlOrden" runat="server" CssClass="tb-field"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="DdlOrden_SelectedIndexChanged">
                                <asp:ListItem Value="Nombre">Nombre</asp:ListItem>
                                <asp:ListItem Value="Matricula">Matr&iacute;cula</asp:ListItem>
                                <asp:ListItem Value="Total">Total</asp:ListItem>
                                <asp:ListItem Value="Promedio">Promedio</asp:ListItem>
                            </asp:DropDownList>
                            <label class="chk-wrap">
                                <asp:CheckBox ID="ChkAscendente" runat="server" Checked="true"
                                    AutoPostBack="true"
                                    OnCheckedChanged="ChkAscendente_CheckedChanged" />
                                Asc
                            </label>
                        </div>
                    </div>

                    <div class="tb-actions tb-actions--stack">
                        <div class="tb-actions-row">
                            <asp:LinkButton ID="btnLimpiarFiltro" runat="server" CssClass="tbtn tbtn-ghost" OnClick="btnLimpiarFiltro_Click">
                                <svg viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                                Limpiar
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnExportar" runat="server" CssClass="tbtn tbtn-green" OnClick="btnExportar_Click">
                                <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                Excel
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnExportarCSV" runat="server" CssClass="tbtn tbtn-blue" OnClick="btnExportarCSV_Click">
                                <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                                CSV
                            </asp:LinkButton>
                        </div>
                        <div class="tb-actions-row">
                            <a href="javascript:void(0)" class="tbtn tbtn-green" onclick="abrirModalImportar(); return false;">
                                <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                                Importar
                            </a>
                            <a href="Imprimir.aspx" target="_blank" class="tbtn tbtn-ghost">
                                <svg viewBox="0 0 24 24"><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect x="6" y="14" width="12" height="8"/></svg>
                                Imprimir
                            </a>
                            <div style="position:relative;display:inline-flex">
                                <asp:LinkButton ID="btnDescargarLog" runat="server" CssClass="tbtn tbtn-purple"
                                    OnClick="btnDescargarLog_Click"
                                    ToolTip="Descargar historial de auditor&iacute;a">
                                    <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                                    Log
                                </asp:LinkButton>
                                <asp:Label ID="lblLogCount" runat="server" Text="0" CssClass="log-badge" />
                            </div>
                            <asp:Label ID="lblCapacidad" runat="server" CssClass="capacidad-info" Text="" />
                        </div>
                    </div>

                    <div class="tb-sep"></div>

                    <!-- Persistencia de sesión: backup/restauración manual vía JSON -->
                    <div class="tb-group">
                        <span class="tb-label">Sesi&oacute;n (backup)</span>
                        <div style="display:flex;align-items:center;gap:6px">
                            <asp:LinkButton ID="btnGuardarSesion" runat="server" CssClass="tbtn tbtn-purple"
                                OnClick="btnGuardarSesion_Click"
                                ToolTip="Descargar copia de seguridad (alumnos + auditor&iacute;a) en JSON">
                                <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                                Guardar
                            </asp:LinkButton>
                            <asp:FileUpload ID="FileSesion" runat="server" CssClass="tb-file-input" />
                            <asp:LinkButton ID="btnRestaurarSesion" runat="server" CssClass="tbtn tbtn-blue"
                                OnClick="btnRestaurarSesion_Click"
                                OnClientClick="return confirm('Esto reemplazará los alumnos y el log de auditoría actuales por los del archivo. ¿Continuar?');"
                                ToolTip="Restaurar alumnos y auditor&iacute;a desde un archivo JSON">
                                <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                                Restaurar
                            </asp:LinkButton>
                        </div>
                    </div>

                </div><!-- /toolbar -->

                <!-- Contador de resultados -->
                <div class="results-bar">
                    <asp:Label ID="LblResultados" runat="server" Text="0 registros" />
                </div>

                <!-- Tabla de datos -->
                <div class="table-scroll">
                    <asp:GridView
                        ID="GridDatos"
                        runat="server"
                        AutoGenerateColumns="false"
                        CssClass="data-table"
                        UseAccessibleHeader="true"
                        OnRowCommand="GridDatos_RowCommand"
                        OnRowDataBound="GridDatos_RowDataBound">
                        <EmptyDataTemplate>
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <svg viewBox="0 0 24 24"><path d="M9 5H7a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2h-2"/><rect x="9" y="3" width="6" height="4" rx="1"/><line x1="9" y1="12" x2="15" y2="12"/><line x1="9" y1="16" x2="12" y2="16"/></svg>
                                </div>
                                <div class="empty-title">Sin registros</div>
                                <div class="empty-text">Completa el formulario y presiona <strong>Procesar Registro</strong> para agregar el primer estudiante.</div>
                            </div>
                        </EmptyDataTemplate>
                        <Columns>
                            <asp:BoundField DataField="Matricula"     HeaderText="Matr&iacute;cula" />
                            <asp:TemplateField HeaderText="Nombre">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CssClass="link-perfil"
                                        CommandName="perfil"
                                        CommandArgument='<%# Eval("Matricula") %>'
                                        ToolTip="Ver perfil del alumno"
                                        Text='<%# Eval("NombreCompleto") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Materia"       HeaderText="Materia" />
                            <asp:BoundField DataField="Parcial1"      HeaderText="P1"    DataFormatString="{0:0.0}" />
                            <asp:BoundField DataField="Parcial2"      HeaderText="P2"    DataFormatString="{0:0.0}" />
                            <asp:BoundField DataField="TP"            HeaderText="TP"    DataFormatString="{0:0.0}" />
                            <asp:BoundField DataField="ExamenFinal"   HeaderText="Final" DataFormatString="{0:0.0}" />
                            <asp:BoundField DataField="Total"         HeaderText="Total" DataFormatString="{0:0.0}" />
                            <asp:TemplateField HeaderText="Prom.">
                                <ItemTemplate>
                                    <span class='<%# GetPromedioClass(Eval("Promedio")) %>'><%# Eval("Promedio", "{0:0.00}") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Situaci&oacute;n">
                                <ItemTemplate>
                                    <span class='<%# GetSituacionClass(Eval("Situacion")) %>'><%# GetSituacionText(Eval("Situacion")) %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Acciones" ItemStyle-CssClass="cell-actions">
                                <ItemTemplate>
                                    <asp:Button ID="btnEditar" runat="server"
                                        Text="Editar"
                                        CssClass="act-btn act-edit"
                                        CommandName="editar"
                                        CommandArgument='<%# Eval("Matricula") + "|" + Eval("Materia") %>' />
                                    <asp:Button ID="btnAnular" runat="server"
                                        Text="Anular"
                                        CssClass="act-btn act-del"
                                        CommandName="anular"
                                        CommandArgument='<%# Eval("Matricula") + "|" + Eval("Materia") %>'
                                        OnClientClick="return confirmarAnular(this);" />
                                    <asp:Button ID="btnHistorial" runat="server"
                                        Text="Historial"
                                        CssClass="act-btn act-hist"
                                        CommandName="historial"
                                        CommandArgument='<%# Eval("Matricula") + "|" + Eval("Materia") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

            </div><!-- /table-panel -->

            <!-- ════════════════════════════════════════
                 SECCIONES INFERIORES: gráfico + historia + estadísticas
            ════════════════════════════════════════ -->
            <div class="bottom-grid">

                <!-- Gráfico de distribución — mosaico -->
                <div class="chart-panel">
                    <div class="chart-panel__header">
                        <span class="chart-panel__title">
                            <span class="history-dot" aria-hidden="true"></span>
                            Distribuci&oacute;n de promedios
                        </span>
                        <span class="chart-panel__sub" id="mosaicSub">0 estudiantes</span>
                    </div>

                    <div class="mosaic-grid" id="mosaicGrid" role="img"
                         aria-label="Mosaico de distribución de promedios por rango"></div>
                    <div class="mosaic-legend">
                        <span class="mosaic-legend-dot mosaic-legend-dot--filled" aria-hidden="true"></span>
                        <span>Estudiante en rango</span>
                        <span class="mosaic-legend-sep">
                            <span class="mosaic-legend-dot mosaic-legend-dot--empty" aria-hidden="true"></span>
                            <span>Vac&iacute;o</span>
                        </span>
                        <span class="mosaic-legend-hint">Pas&aacute; el cursor sobre cada celda</span>
                    </div>
                </div>

                <!-- Historial de auditoría -->
                <div class="section-panel audit-card">
                    <div class="section-head" id="auditHeader" onclick="toggleAudit()" style="cursor:pointer">
                        <span class="section-title">
                            <span style="width:8px;height:8px;border-radius:50%;background:var(--teal);display:inline-block;flex-shrink:0"></span>
                            &Uacute;ltimos eventos de auditor&iacute;a
                        </span>
                        <span class="section-sub" id="auditToggle">&#9658; Expandir</span>
                    </div>
                    <div id="auditPanel" class="history-body" style="display:none">
                        <div id="auditList">
                            <asp:Literal ID="litAuditEntries" runat="server" />
                        </div>
                    </div>
                </div>

                <!-- Estadísticas de la clase (ancho completo) -->
                <div class="section-panel" style="grid-column:1/-1">
                    <div class="section-head">
                        <span class="section-title">Estad&iacute;sticas de la Clase</span>
                        <span class="section-sub">
                            <asp:Label ID="LblStatsCount" runat="server" Text=""></asp:Label>
                        </span>
                    </div>
                    <div class="stats-bottom-body">
                        <div class="stats-3col">
                            <div class="stat-col">
                                <div class="stat-col-label">Promedio de la clase</div>
                                <div class="stat-col-val">
                                    <asp:Label ID="LblPromedioClase" runat="server" Text="&mdash;"></asp:Label>
                                </div>
                            </div>
                            <div class="stat-col">
                                <div class="stat-col-label">Mejor calificaci&oacute;n</div>
                                <div class="stat-col-val" style="color:var(--teal)">
                                    <asp:Label ID="LblMejorCalificacion" runat="server" Text="&mdash;"></asp:Label>
                                </div>
                                <div class="stat-col-name">
                                    <asp:Label ID="LblAlumnoMejor" runat="server" Text=""></asp:Label>
                                    <asp:Label ID="LblMateriaMejor" runat="server" Text="" CssClass="grade-sub"></asp:Label>
                                    <asp:Label ID="LblSituacionMejor" runat="server" Text=""></asp:Label>
                                </div>
                            </div>
                            <div class="stat-col">
                                <div class="stat-col-label">Peor calificaci&oacute;n</div>
                                <div class="stat-col-val" style="color:var(--red)">
                                    <asp:Label ID="LblPeorCalificacion" runat="server" Text="&mdash;"></asp:Label>
                                </div>
                                <div class="stat-col-name">
                                    <asp:Label ID="LblAlumnoPeor" runat="server" Text=""></asp:Label>
                                    <asp:Label ID="LblMateriaPeor" runat="server" Text="" CssClass="grade-sub"></asp:Label>
                                    <asp:Label ID="LblSituacionPeor" runat="server" Text=""></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div><!-- /bottom-grid -->

        </div><!-- /columna derecha -->

    </div><!-- /layout-grid -->


    <!--
         MODAL GENÉRICO (confirmaciones / perfil / historial)
     -->
    <div id="modalOverlay" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-title" id="modalTitle"></div>
            <div class="modal-body" id="modalBody"></div>
            <div class="modal-actions">
                <button type="button" class="tbtn tbtn-ghost" onclick="cerrarModal()">Cancelar</button>
                <button type="button" class="tbtn tbtn-blue" id="modalConfirmBtn" onclick="_confirmModalAction()">Confirmar</button>
            </div>
        </div>
    </div>

    <!-- 
         MODAL HISTORIAL POR ALUMNO 
     -->
    <div id="modalHistorialAlumno" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-title">Historial de <asp:Literal ID="litHistorialAlumnoNombre" runat="server" /></div>
            <div class="modal-body">
                <div class="history-panel">
                    <asp:Literal ID="litHistorialAlumno" runat="server" />
                </div>
            </div>
            <div class="modal-actions">
                <button type="button" class="tbtn tbtn-ghost" onclick="cerrarModal('modalHistorialAlumno')">Cerrar</button>
            </div>
        </div>
    </div>

    <!-- 
         MODAL PERFIL DE ALUMNO 
     -->
    <div id="modalPerfilAlumno" class="modal-overlay">
        <div class="modal-box" style="max-width:560px">
            <div class="modal-title">Perfil del alumno</div>
            <div class="modal-body">
                <div class="perfil-info">
                    <div><strong>Nombre:</strong> <asp:Literal ID="litPerfilNombre" runat="server" /></div>
                    <div><strong>Matr&iacute;cula:</strong> <asp:Literal ID="litPerfilMatricula" runat="server" /></div>
                </div>
                <asp:Literal ID="litPerfilMaterias" runat="server" />
            </div>
            <div class="modal-actions">
                <button type="button" class="tbtn tbtn-ghost" onclick="cerrarModal('modalPerfilAlumno')">Cerrar</button>
            </div>
        </div>
    </div>

    <!-- 
         MODAL IMPORTAR DESDE EXCEL 
    -->
    <div id="modalImportar" class="modal-overlay">
        <div class="modal-box" style="max-width:680px">
            <div class="modal-title">Importar alumnos desde Excel</div>
            <div class="modal-body">
                <p style="margin-top:0">Descargue la plantilla, compl&eacute;tela y s&uacute;bala para previsualizar los registros antes de importarlos.</p>

                <div style="margin-bottom:14px">
                    <asp:LinkButton ID="btnDescargarPlantilla" runat="server" CssClass="tbtn tbtn-blue" OnClick="btnDescargarPlantilla_Click">
                        <svg viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
                        Descargar plantilla
                    </asp:LinkButton>
                </div>

                <div style="display:flex;align-items:center;gap:8px;margin-bottom:14px;flex-wrap:wrap">
                    <asp:FileUpload ID="FileImportar" runat="server" CssClass="tb-file-input" />
                    <asp:Button ID="btnPrevisualizarImportacion" runat="server" CssClass="tbtn tbtn-blue" Text="Previsualizar" OnClick="btnPrevisualizarImportacion_Click" />
                </div>

                <div id="importPreviewWrap">
                    <asp:Literal ID="litPreviewImportacion" runat="server" />
                </div>

                <asp:Panel ID="PnlDuplicados" runat="server" Visible="false" CssClass="import-dup-options">
                    <div class="perfil-hist-title">Alumnos duplicados encontrados</div>
                    <asp:RadioButtonList ID="rblDuplicados" runat="server" RepeatDirection="Horizontal" CssClass="import-rbl">
                        <asp:ListItem Value="omitir" Selected="True">Omitir duplicados</asp:ListItem>
                        <asp:ListItem Value="sobrescribir">Sobrescribir con los nuevos datos</asp:ListItem>
                    </asp:RadioButtonList>
                </asp:Panel>
            </div>
            <div class="modal-actions">
                <button type="button" class="tbtn tbtn-ghost" onclick="cerrarModal('modalImportar')">Cerrar</button>
                <asp:Button ID="btnConfirmarImportacion" runat="server" CssClass="tbtn tbtn-blue" Text="Confirmar importaci&oacute;n" OnClick="btnConfirmarImportacion_Click" Visible="false" />
            </div>
        </div>
    </div>

    <!-- 
         JAVASCRIPT
   -->
    <script type="text/javascript">
    // @ts-nocheck

    /* ── helpers ── */
    function _id(id) { return document.getElementById(id); }
    function getNotaLetra(p) {
        if (p >= 4.5) return 'Cinco';
        if (p >= 3.5) return 'Cuatro';
        if (p >= 2.5) return 'Tres';
        if (p >= 1.5) return 'Dos';
        return 'Uno';
    }

    /* ── normalizar texto para matching de materia ── */
    function norm(s) {
        return s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').trim();
    }

    /* ── modal genérico: confirmaciones / perfil / historial por alumno ── */
    var _modalConfirmCallback = null;
    function abrirModal(titulo, bodyHtml, onConfirm) {
        var overlay = _id('modalOverlay');
        var confirmBtn = _id('modalConfirmBtn');
        if (!overlay) return;
        _id('modalTitle').textContent = titulo;
        _id('modalBody').innerHTML = bodyHtml;
        _modalConfirmCallback = onConfirm || null;
        if (confirmBtn) confirmBtn.style.display = onConfirm ? '' : 'none';
        overlay.classList.add('show');
    }
    function abrirModalSoloLectura(titulo, bodyHtml) {
        abrirModal(titulo, bodyHtml, null);
    }
    function abrirModalImportar() {
        var overlay = _id('modalImportar');
        if (overlay) overlay.classList.add('show');
    }
    function cerrarModal(overlayId) {
        var overlay = _id(overlayId || 'modalOverlay');
        if (overlay) overlay.classList.remove('show');
        if (!overlayId || overlayId === 'modalOverlay') _modalConfirmCallback = null;
    }
    function _confirmModalAction() {
        var cb = _modalConfirmCallback;
        cerrarModal();
        if (cb) cb();
    }

    /* ── confirmación de "Anular" con resumen del registro ── */
    function confirmarAnular(btn) {
        if (btn.dataset.confirmado === '1') return true;
        var fila = btn.closest('tr');
        var celdas = fila ? fila.querySelectorAll('td') : [];
        var matricula = celdas[0] ? celdas[0].textContent.trim() : '';
        var nombre    = celdas[1] ? celdas[1].textContent.trim() : '';
        var materia   = celdas[2] ? celdas[2].textContent.trim() : '';
        var promedio  = celdas[8] ? celdas[8].textContent.trim() : '';
        var html =
            '<div class="modal-resumen">' +
            '<div><strong>Matrícula:</strong> ' + matricula + '</div>' +
            '<div><strong>Nombre:</strong> ' + nombre + '</div>' +
            '<div><strong>Materia:</strong> ' + materia + '</div>' +
            '<div><strong>Promedio:</strong> ' + promedio + '</div>' +
            '</div>' +
            '<p style="margin-top:12px;color:var(--red)">Esta acción no se puede deshacer.</p>';
        abrirModal('¿Anular este registro?', html, function () {
            btn.dataset.confirmado = '1';
            btn.click();
        });
        return false;
    }

    var MATERIA_MAP = {
        'lenguaje de programacion 2':          { cls: 'badge-prog',  label: 'Prog. 2' },
        'historia y filosofia de la ciencia':   { cls: 'badge-hist',  label: 'Hist. Filosofía' },
        'etica personal':                        { cls: 'badge-etica', label: 'Ética Personal' },
        'fisica 3':                              { cls: 'badge-fis',   label: 'Física 3' },
        'matematica para informaticos':          { cls: 'badge-mat-m', label: 'Mat. Inform.' }
    };

    /* ── tooltip flotante único para el mosaico ── */
    var _mTip = null;
    function _getMTip() {
        if (!_mTip) {
            _mTip = document.createElement('div');
            _mTip.style.cssText = 'position:fixed;background:#1a2636;border:1px solid rgba(255,255,255,.18);border-radius:6px;padding:4px 10px;font-size:11px;color:#dde8f0;white-space:nowrap;pointer-events:none;z-index:9999;opacity:0;transition:opacity .15s;font-family:DM Sans,sans-serif;';
            document.body.appendChild(_mTip);
        }
        return _mTip;
    }
    function _showMTip(cell, text) {
        var tip = _getMTip();
        tip.textContent = text;
        tip.style.opacity = '1';
        var r = cell.getBoundingClientRect();
        tip.style.left      = Math.round(r.left + r.width / 2) + 'px';
        tip.style.top       = Math.round(r.top - 6) + 'px';
        tip.style.transform = 'translateX(-50%) translateY(-100%)';
    }
    function _hideMTip() { _getMTip().style.opacity = '0'; }

    /* ── renderizar mosaico de distribución ── */
    function inicializarGrafico() {
        var grid = document.getElementById('mosaicGrid');
        if (!grid) return;

        var CONFIG = [
            { label: '0–1', color: '#e05555' },
            { label: '1–2', color: '#e07830' },
            { label: '2–3', color: '#e8a049' },
            { label: '3–4', color: '#4a9eff' },
            { label: '4–5', color: '#2dd4a0' }
        ];

        var MAX_CELLS = 8;
        var counts = [0, 0, 0, 0, 0];
        var totalEst = 0;

        var table = document.querySelector('#<%=GridDatos.ClientID%>');
        if (table) {
            var rows = table.querySelectorAll('tbody tr');
            rows.forEach(function(row) {
                var cells = row.querySelectorAll('td');
                if (cells.length >= 9) {
                    /* cells[8] contiene promedio + nota en letras; extraer solo el número */
                    var raw = (cells[8].innerText || cells[8].textContent || '').trim();
                    var m   = raw.replace(',', '.').match(/^(\d+(?:\.\d+)?)/);
                    var val = m ? parseFloat(m[1]) : NaN;
                    if (!isNaN(val)) {
                        totalEst++;
                        counts[Math.min(Math.floor(val), 4)]++;
                    }
                }
            });
        }

        /* cabecera */
        var elSub = document.getElementById('mosaicSub');
        if (elSub) elSub.textContent = totalEst + (totalEst === 1 ? ' estudiante' : ' estudiantes');

        /* sincronizar stat-cards superiores */
        var statTotalEl = document.getElementById('statTotal');
        if (statTotalEl) statTotalEl.textContent = totalEst;
        var promLabel = document.getElementById('<%=LblPromedioClase.ClientID%>');
        var statPromEl = document.getElementById('statProm');
        if (promLabel && statPromEl) statPromEl.innerHTML = promLabel.innerHTML;
        var mejorLabel = document.getElementById('<%=LblMejorCalificacion.ClientID%>');
        var statMejorEl = document.getElementById('statAprobados');
        if (mejorLabel && statMejorEl) statMejorEl.innerHTML = mejorLabel.innerHTML;

        /* renderizar mosaico */
        grid.innerHTML = '';

        CONFIG.forEach(function(cfg, i) {
            var count = counts[i];
            var pct   = totalEst > 0 ? Math.round(count / totalEst * 100) : 0;

            var rowEl = document.createElement('div');
            rowEl.className = 'mosaic-row';

            var lbl = document.createElement('span');
            lbl.className = 'mosaic-range';
            lbl.textContent = cfg.label;
            rowEl.appendChild(lbl);

            var cellsWrap = document.createElement('div');
            cellsWrap.className = 'mosaic-cells';

            for (var c = 0; c < MAX_CELLS; c++) {
                var cell = document.createElement('div');
                var filled = c < count;
                cell.className = 'mosaic-cell ' + (filled ? 'filled' : 'empty');
                cell.style.setProperty('background', cfg.color, 'important');

                if (filled) {
                    (function(el, tipText) {
                        el.addEventListener('mouseenter', function() { _showMTip(el, tipText); });
                        el.addEventListener('mouseleave', _hideMTip);
                    })(cell, 'Rango ' + cfg.label + ' · estudiante ' + (c + 1));
                }

                cellsWrap.appendChild(cell);
            }
            rowEl.appendChild(cellsWrap);

            var cnt = document.createElement('span');
            cnt.className = 'mosaic-count';
            cnt.textContent = count;
            rowEl.appendChild(cnt);

            var pctEl = document.createElement('span');
            pctEl.className = 'mosaic-pct';
            pctEl.textContent = pct + '%';
            rowEl.appendChild(pctEl);

            grid.appendChild(rowEl);
        });
    }

    /* ── estilizar filas de la tabla ── */
    function styleTableRows() {
        var table = _id('<%=GridDatos.ClientID%>');
        if (!table) return;

        var allRows = table.querySelectorAll('tr');
        var rows = [];
        for (var r = 0; r < allRows.length; r++) {
            if (allRows[r].querySelectorAll('th').length === 0 &&
                allRows[r].querySelectorAll('td').length > 0) {
                rows.push(allRows[r]);
            }
        }

        for (var i = 0; i < rows.length; i++) {
            var cells = rows[i].querySelectorAll('td');
            if (cells.length < 11) continue;

            /* matrícula */
            cells[0].classList.add('td-matricula');

            /* nombre */
            cells[1].classList.add('td-nombre');

            /* badge de materia */
            var matCell  = cells[2];
            var matTxt   = matCell.innerText || '';
            var matKey   = norm(matTxt);
            var matInfo  = MATERIA_MAP[matKey];
            if (matInfo) {
                matCell.innerHTML = '<span class="badge ' + matInfo.cls + '">' + matInfo.label + '</span>';
            }

            /* chip de situación */
            var sitCell  = cells[9];
            var sitText  = sitCell.innerText || '';
            if (sitText.indexOf('Aprobado') !== -1) {
                sitCell.innerHTML = '<span class="situ-ok">Aprobado &#10003;</span>';
            } else {
                sitCell.innerHTML = '<span class="situ-err">Reprobado &#10007;</span>';
            }

            /* total en ámbar */
            cells[7].classList.add('td-total');
        }

        /* actualizar contador de entradas */
        var total = rows.length;
        var tableBadgeEl = _id('tableBadge');
        if (tableBadgeEl) tableBadgeEl.innerText = String(total) + (total === 1 ? ' entrada' : ' entradas');
    }

    /* ── Multi-materia: badge numérico + popover para alumnos con varias materias ── */
    function aplicarBadgesMultiMateria() {
        var table = _id('<%=GridDatos.ClientID%>');
        if (!table) return;

        var filas = table.querySelectorAll('tr[data-matricula]');
        var mapa = {};
        for (var i = 0; i < filas.length; i++) {
            var mat = filas[i].getAttribute('data-matricula');
            if (!mapa[mat]) mapa[mat] = [];
            mapa[mat].push(filas[i]);
        }

        Object.keys(mapa).forEach(function (matricula) {
            var grupo = mapa[matricula];
            if (grupo.length <= 1) return;

            for (var j = 1; j < grupo.length; j++) grupo[j].style.display = 'none';

            agregarBadgeMultiMateria(grupo[0], matricula, grupo);
        });
    }

    function agregarBadgeMultiMateria(fila, matricula, grupo) {
        var celdaMateria = fila.querySelectorAll('td')[2];
        if (!celdaMateria) return;

        var existente = celdaMateria.querySelector('.multi-materia-badge');
        if (existente) existente.remove();

        var badge = document.createElement('span');
        badge.className = 'multi-materia-badge';
        badge.innerHTML = '<span class="multi-materia-badge__icon">&#128218;</span><span class="multi-materia-badge__num">' + grupo.length + '</span>';
        badge.title = grupo.length + ' materias registradas — clic para cambiar';
        badge.onclick = function (ev) {
            ev.stopPropagation();
            mostrarPopoverMaterias(ev, matricula, grupo);
        };
        celdaMateria.appendChild(badge);
    }

    function mostrarPopoverMaterias(ev, matricula, grupo) {
        document.querySelectorAll('.materia-popover').forEach(function (p) { p.remove(); });

        var visible = null;
        for (var i = 0; i < grupo.length; i++) {
            if (grupo[i].style.display !== 'none') { visible = grupo[i]; break; }
        }

        var pop = document.createElement('div');
        pop.className = 'materia-popover';

        var title = document.createElement('div');
        title.className = 'pop-title';
        title.textContent = 'Materias registradas';
        pop.appendChild(title);

        grupo.forEach(function (fila) {
            var materia = fila.getAttribute('data-materia') || '';
            var info = MATERIA_MAP[norm(materia)];
            var label = info ? info.label : materia;
            var esActual = (fila === visible);

            var item = document.createElement('div');
            item.className = 'pop-item' + (esActual ? ' pop-item-actual' : '');

            var dot = document.createElement('span');
            dot.className = 'pop-dot';
            item.appendChild(dot);
            item.appendChild(document.createTextNode(label));

            if (esActual) {
                var tag = document.createElement('span');
                tag.className = 'pop-tag';
                tag.textContent = 'actual';
                item.appendChild(tag);
            } else {
                item.onclick = function () {
                    var celdaOrigen = visible.querySelectorAll('td')[2];
                    var badgeEl = celdaOrigen ? celdaOrigen.querySelector('.multi-materia-badge') : null;

                    visible.style.display = 'none';
                    fila.style.display = '';

                    if (badgeEl) badgeEl.remove();
                    agregarBadgeMultiMateria(fila, matricula, grupo);

                    pop.remove();
                };
            }

            pop.appendChild(item);
        });

        document.body.appendChild(pop);
        var rect = ev.target.getBoundingClientRect();
        pop.style.top = (rect.bottom + 6) + 'px';
        pop.style.left = Math.max(8, rect.left - 80) + 'px';

        setTimeout(function () {
            document.addEventListener('click', function () { pop.remove(); }, { once: true });
        }, 50);
    }

    /* ── estilizar encabezados de tabla ── */
    function styleHeaders() {
        var headers = document.querySelectorAll('.data-table th');
        for (var h = 0; h < headers.length; h++) {
            var /** @type {HTMLElement} */ th = /** @type {HTMLElement} */ (headers[h]);
            th.style.setProperty('background', 'var(--bg-3)', 'important');
            th.style.setProperty('color', 'var(--text-2)', 'important');
            th.style.setProperty('border-bottom', '2px solid var(--border-2)', 'important');
        }
    }

    /* ── validación visual de un campo numérico ── */
    function validateNumField(el, min, max, warnId) {
        if (!el) return;
        var /** @type {HTMLInputElement} */ inp = /** @type {HTMLInputElement} */ (el);
        var val = inp.value.trim();
        var warnEl = warnId ? _id(warnId) : null;
        if (!val) {
            inp.classList.remove('ok', 'err', 'warn');
            if (warnEl) warnEl.style.display = 'none';
            return;
        }
        var n = parseFloat(val);
        if (isNaN(n) || n < min || n > max) {
            inp.classList.add('err'); inp.classList.remove('ok', 'warn');
            if (warnEl) warnEl.style.display = 'none';
        } else {
            inp.classList.add('ok'); inp.classList.remove('err');
            if (n === 0) {
                inp.classList.add('warn');
                if (warnEl) warnEl.style.display = 'block';
            } else {
                inp.classList.remove('warn');
                if (warnEl) warnEl.style.display = 'none';
            }
        }
    }

    function validateTextField(el) {
        if (!el) return;
        var /** @type {HTMLInputElement} */ inp = /** @type {HTMLInputElement} */ (el);
        var val = inp.value.trim();
        if (!val) { inp.classList.remove('ok', 'err'); return; }
        inp.classList.add('ok'); inp.classList.remove('err');
    }

    /* ── vista previa del formulario ── */
    function updatePreview() {
        var /** @type {HTMLInputElement} */ elP1 = /** @type {HTMLInputElement} */ (_id('<%=TxtParcial1.ClientID%>'));
        var /** @type {HTMLInputElement} */ elP2 = /** @type {HTMLInputElement} */ (_id('<%=TxtParcial2.ClientID%>'));
        var /** @type {HTMLInputElement} */ elTP = /** @type {HTMLInputElement} */ (_id('<%=TxtTP.ClientID%>'));
        var /** @type {HTMLInputElement} */ elEF = /** @type {HTMLInputElement} */ (_id('<%=TxtExamenFinal.ClientID%>'));
        var p1 = parseFloat(elP1?.value || '');
        var p2 = parseFloat(elP2?.value || '');
        var tp = parseFloat(elTP?.value || '');
        var ef = parseFloat(elEF?.value || '');
        validateNumField(elP1, 0, 20, 'warnP1');
        validateNumField(elP2, 0, 20, 'warnP2');
        validateNumField(elTP, 0, 10, 'warnTP');
        validateNumField(elEF, 0, 50, 'warnEF');
        var prev = _id('previewSection');
        if (!prev) return;
        if (isNaN(p1) || isNaN(p2) || isNaN(tp) || isNaN(ef)) { prev.style.display = 'none'; return; }
        var total  = p1 + p2 + tp + ef;
        var prom   = Math.round((total / 100) * 5 * 100) / 100;
        var passed = prom >= 3;
        prev.style.display = 'block';
        var totEl  = _id('prevTotal');
        var promEl = _id('prevProm');
        var situEl = _id('prevSituacion');
        if (totEl)  totEl.textContent  = total.toFixed(1).replace('.', ',');
        if (promEl) { promEl.textContent = prom.toFixed(2).replace('.', ','); promEl.style.color = passed ? 'var(--teal)' : 'var(--red)'; }
        if (situEl) { situEl.textContent = (passed ? '✓ Aprobado' : '✗ Reprobado') + ' — ' + getNotaLetra(prom); situEl.style.color = passed ? 'var(--teal)' : 'var(--red)'; }
    }

    /* ── badge de log ── */
    function syncLogBadge() {
        var badge = _id('<%=lblLogCount.ClientID%>');
        if (!badge) return;
        var txt   = (badge.textContent || badge.innerText || '').trim();
        var count = parseInt(txt, 10);
        badge.setAttribute('data-zero', (isNaN(count) || count === 0) ? 'true' : 'false');
    }

    /* ── toggle auditoría ── */
function toggleAudit() {
    var panel = _id('auditPanel');
    var toggle = _id('auditToggle');
    if (!panel || !toggle) return;

    var collapsed = panel.style.display === 'none';
    panel.style.display = collapsed ? '' : 'none';
    toggle.textContent = collapsed ? '▼ Colapsar' : '▶ Expandir';
}

    function syncAuditPanelHeight() { /* no se necesita */ }

    function syncMsgToast() {
        var msg = _id('<%=btnMensaje.ClientID%>');
        if (!msg) return;
        var txt = msg.innerText || msg.textContent || '';
        if (!txt.trim()) { msg.style.display = 'none'; return; }
        msg.style.display = 'flex';
        var isError = txt.toLowerCase().includes('error') || txt.toLowerCase().includes('ya existe');
        msg.className = 'msg-toast ' + (isError ? 'error' : 'success');
    }

    /* ── panel label al editar ── */
    function syncPanelLabel() {
        var hf = _id('<%=HfMatriculaEdicion.ClientID%>');
        var lbl = _id('panelLabel');
        if (!hf || !lbl) return;
        lbl.textContent = hf.value ? '✎ Editando registro' : 'Nuevo registro';
    }

    /* ── inicialización ── */
    function init() {
        styleTableRows();
        aplicarBadgesMultiMateria();
        styleHeaders();
        inicializarGrafico();
        syncLogBadge();
        syncMsgToast();
        syncPanelLabel();

        /* eventos de vista previa */
        var ids = [
            '<%=TxtParcial1.ClientID%>',
            '<%=TxtParcial2.ClientID%>',
            '<%=TxtTP.ClientID%>',
            '<%=TxtExamenFinal.ClientID%>'
        ];
        for (var k = 0; k < ids.length; k++) {
            var el = _id(ids[k]);
            if (el) el.addEventListener('input', updatePreview);
        }

        /* mayúsculas + validación en matrícula */
        var mat = _id('<%=TxtMatricula.ClientID%>');
        if (mat) {
            mat.addEventListener('input', function(e) {
                var /** @type {HTMLInputElement} */ inp = /** @type {HTMLInputElement} */ (e.target);
                inp.value = inp.value.toUpperCase();
                validateTextField(inp);
            });
        }

        /* title-case + validación en nombre */
        var nom = _id('<%=TxtNombre.ClientID%>');
        if (nom) {
            nom.addEventListener('input', function(e) { validateTextField(/** @type {HTMLInputElement} */ (e.target)); });
            nom.addEventListener('blur', function(e) {
                var /** @type {HTMLInputElement} */ inp = /** @type {HTMLInputElement} */ (e.target);
                if (!inp.value) return;
                inp.value = inp.value.trim().split(/\s+/).map(function(w) {
                    return w.charAt(0).toUpperCase() + w.slice(1).toLowerCase();
                }).join(' ');
                validateTextField(inp);
            });
        }

        /* validación en el selector de materia */
        var matSel = _id('<%=DdlMateria.ClientID%>');
        if (matSel) {
            matSel.addEventListener('change', function(e) {
                var /** @type {HTMLSelectElement} */ sel = /** @type {HTMLSelectElement} */ (e.target);
                if (sel.value) { sel.classList.add('ok'); sel.classList.remove('err'); }
                else           { sel.classList.remove('ok', 'err'); }
            });
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    /* re-init tras UpdatePanel / ASP.NET AJAX */
    var _sys = /** @type {any} */ (window)['Sys'];
    if (_sys && _sys.WebForms && _sys.WebForms.PageRequestManager) {
        _sys.WebForms.PageRequestManager.getInstance().add_endRequest(function() {
            init();
        });
    }

    </script>

</asp:Content>
