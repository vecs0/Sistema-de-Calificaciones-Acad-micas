<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Imprimir.aspx.cs" Inherits="Datos.Imprimir" ResponseEncoding="UTF-8" ContentType="text/html; charset=utf-8" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <title>Sistema de Calificaciones — Vista de impresi&oacute;n</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: 'DM Sans', Arial, sans-serif;
            color: #1a1a1a;
            background: #fff;
            margin: 24px;
        }
        h1 { font-size: 18px; margin: 0 0 4px; }
        .print-meta { font-size: 12px; color: #555; margin-bottom: 16px; }
        table.print-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        table.print-table th, table.print-table td {
            border: 1px solid #999;
            padding: 6px 8px;
            text-align: left;
        }
        table.print-table th {
            background: #eee;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 10px;
            letter-spacing: .05em;
        }
        .print-actions { margin-bottom: 16px; }
        .print-actions button {
            font-size: 13px;
            padding: 8px 16px;
            cursor: pointer;
        }
        @media print {
            .print-actions { display: none; }
            body { margin: 0; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="print-actions">
            <button type="button" onclick="window.print()">Imprimir</button>
        </div>
        <h1>Sistema de Calificaciones</h1>
        <div class="print-meta">
            <asp:Literal ID="litFecha" runat="server" />
            &middot;
            <asp:Literal ID="litCantidad" runat="server" />
        </div>
        <asp:Literal ID="litTabla" runat="server" />
    </form>
</body>
</html>
