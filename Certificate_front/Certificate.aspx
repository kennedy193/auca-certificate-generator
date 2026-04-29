<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Certificate.aspx.cs"
    Inherits="StudentCertificateApp.Certificate_front.Certificate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<style>
/* ═══════════════════════════════════════════════════════════════════
   ALL font/size/spacing values are taken directly from the Word XML:
   - Body:       Times New Roman, 12pt  (szCs=24 → half-points)
   - Dept name:  Edwardian Script ITC, bold, 22pt (sz=44)
   - Title:      bold, 13.5pt (sz=27), indented
   - Body lines: line-height ~1.8  (w:line="360" / 240 = 1.5× Word)
   - Page:       US Letter, top margin tiny (450 twips ≈ 0.31in)
═══════════════════════════════════════════════════════════════════ */

/* ── Reset ───────────────────────────────────────────────────────── */
.cert-page, .cert-page * { box-sizing: border-box; }

/* ── Print ───────────────────────────────────────────────────────── */
@media print {
    .no-print { display: none !important; }
    @page { size: letter portrait; margin: 0; }
    .cert-page {
        width: 100% !important;
        box-shadow: none !important;
        margin: 0 !important;
        /* mirror Word margins: top=450twip≈0.31in, sides=1440twip=1in */
        padding: 10px 96px 96px !important;
    }
}

/* ── Toolbar ─────────────────────────────────────────────────────── */
.cert-toolbar {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    max-width: 816px;
    margin: 14px auto 8px;
    font-family: 'Segoe UI', Arial, sans-serif;
}
.cert-toolbar button, .cert-toolbar a {
    padding: 8px 20px; border: none; border-radius: 4px;
    font-size: 14px; font-family: inherit;
    cursor: pointer; font-weight: 600; text-decoration: none;
}
.btn-print { background: #1f4e79; color: #fff; }
.btn-back  { background: #e5e7eb; color: #333; }
.btn-print:hover { background: #163a5b; }

/* ── Certificate page — US Letter 8.5×11 ───────────────────────── */
.cert-page {
    width: 816px;           /* 8.5in × 96dpi */
    min-height: 1056px;     /* 11in × 96dpi  */
    margin: 0 auto 40px;
    background: #fff;
    /* top=~30px, sides=96px (1in), bottom=96px */
    padding: 10px 96px 96px;
    /* All body text: Times New Roman 12pt */
    font-family: 'Times New Roman', Times, serif;
    font-size: 12pt;
    color: #000;
    line-height: 1.0;
    box-shadow: 0 4px 24px rgba(0,0,0,.15);
    position: relative;
}

/* ── LETTERHEAD IMAGE ────────────────────────────────────────────── */
/* The Word doc uses a full-width letterhead JPG (logo+university name)
   Place your Letterhead.jpg in ~/Images/ — it spans the full content width */
.lh-img {
    width: 100%;
    display: block;
    margin-bottom: 0;
}
/* Fallback letterhead if image missing */
.lh-fallback {
    display: none;
    text-align: center;
    margin-bottom: 4px;
}
.lh-img[src=""][onerror] ~ .lh-fallback,
.lh-img:not([src]) ~ .lh-fallback { display: block; }

/* ── DEPT NAME — Edwardian Script ITC, bold, 22pt, centered ─────── */
/* Exact match: w:rFonts ascii="Edwardian Script ITC", w:b, sz=44 (22pt) */
.lh-dept {
    font-family: 'Edwardian Script ITC', 'Palatino Linotype', 'Book Antiqua',
                 Palatino, 'URW Palladio L', serif;
    font-size: 22pt;
    font-weight: bold;
    font-style: normal;       /* Edwardian is already cursive by design */
    color: #000;
    text-align: center;
    line-height: 1.2;
    margin: 0 0 2px;
}

/* ── CONTACT LINE — 10pt (sz=20), centered ──────────────────────── */
.lh-contact {
    font-family: 'Times New Roman', Times, serif;
    font-size: 10pt;
    text-align: center;
    color: #000;
    line-height: 1.4;
    margin-bottom: 0;
}

/* ── BOTTOM BORDER on email line (w:pBdr bottom single sz=6) ───── */
.lh-email-line {
    font-family: 'Times New Roman', Times, serif;
    font-size: 10pt;        /* same as contact */
    text-align: center;
    color: #000;
    border-bottom: 1px solid #000;
    padding-bottom: 4px;
    margin-bottom: 14px;
}
.lh-email-line a { color: #1155cc; text-decoration: underline; }

/* ── DATE — 12pt, auto-spacing before/after ─────────────────────── */
.cert-date {
    font-size: 12pt;
    margin: 14px 0 0;
    line-height: 1.5;
}

/* ── TITLE — bold 13.5pt (sz=27), indented per XML ─────────────── */
/* XML: w:ind left=1440 firstLine=720, w:outlineLvl=2 */
.cert-title {
    font-size: 13.5pt;
    font-weight: bold;
    /* 1440 twips = 1in = 96px left; firstLine 720 twips = 0.5in = 48px extra */
    padding-left: 144px;   /* 1.5in total first-line position */
    margin: 14px 0 0;
    line-height: 1.5;
}

/* ── BLANK SPACER lines (w:line=360 empty paragraphs) ───────────── */
.cert-spacer { margin: 0; line-height: 2.0; min-height: 1.5em; }

/* ── BODY TEXT — 12pt Times New Roman ──────────────────────────── */
/* Paragraph spacing: w:after=300 on intro para */
.cert-intro {
    font-size: 12pt;
    margin: 0 0 18px 0;
    line-height: 1.5;
}

/* Student name line: bold, body size, w:line=360 (double spaced) */
/* XML: w:b on "Tuyizere Dieudonne", sz default, line=360 */
.cert-body-line {
    font-size: 12pt;
    line-height: 2.0;       /* w:line=360 / 240 baseline = 1.5× Word = ~2.0 CSS */
    margin: 0;
    display: block;
}

/* Detail lines: "Year:", "Faculty:" etc — normal weight label, bold value */
.cert-body-line .lbl { font-weight: normal; }
.cert-body-line .val { font-weight: bold;   }

/* Purpose line */
.cert-purpose {
    font-size: 12pt;
    line-height: 1.5;
    margin-top: 8px;
    display: block;
}

/* ── SIGNATURE + QR ROW ──────────────────────────────────────────── */
/* Word: signature is left-aligned text with underscores + line breaks.
   QR is a floating anchor image at right, "Scan to verify" is a
   floating text box above it. We replicate with flex. */
.cert-footer-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-top: 32px;
}

/* Signature: underscores as sig line, then name/title below */
.sig-block { flex: 1; }
.sig-underline {
    font-size: 12pt;
    font-weight: bold;
    letter-spacing: -1px;   /* tighten underscores */
    display: block;
}
.sig-name  { font-size: 12pt; font-weight: normal; display: block; }
.sig-title { font-size: 12pt; font-weight: bold;   display: block; }
.sig-org   { font-size: 12pt; font-weight: normal; display: block; }

/* Sig image (optional — shown if file exists) */
.sig-img { width: 160px; display: block; margin-bottom: 2px; }

/* QR block — right side */
.qr-block { text-align: center; min-width: 130px; }
.qr-block .qr-caption {
    font-size: 10pt;
    display: block;
    margin-bottom: 6px;
    font-family: 'Times New Roman', Times, serif;
}
.qr-block img { width: 110px; height: 110px; object-fit: contain; display: block; margin: 0 auto; }
</style>

<!-- ── Toolbar (screen only) ─────────────────────────────────────── -->
<div class="cert-toolbar no-print">
    <a href="Default.aspx" class="btn-back">&#8592; Back</a>
    <button class="btn-print" onclick="window.print(); return false;">&#128424; Print / Save PDF</button>
</div>

<!-- ═══════════════════════ CERTIFICATE PAGE ═══════════════════════ -->
<div class="cert-page">

    <!-- ── LETTERHEAD ────────────────────────────────────────────── -->
    <!-- Primary: use Letterhead.jpg exactly as in the Word document -->
    <img class="lh-img"
         src='<%= ResolveUrl("~/Images/Letterhead.jpg") %>'
         alt="AUCA Letterhead"
         onerror="this.style.display='none'; document.getElementById('lhFallback').style.display='block';" />

    <!-- Fallback if Letterhead.jpg not available -->
    <div id="lhFallback" style="display:none; text-align:center; margin-bottom:4px;">
        <img src='<%= ResolveUrl("~/Images/auca_logo.png") %>'
             style="width:80px; height:80px; vertical-align:middle; margin-right:10px;"
             alt="AUCA Logo"
             onerror="this.style.display='none'" />
        <span style="font-family:'Times New Roman',serif; font-size:20pt; font-weight:bold; color:#1f4e79; vertical-align:middle;">
            Adventist University of Central Africa
        </span>
        <div style="font-size:10pt; color:#333; margin-top:2px;">
            P.O. Box 2461 Kigali, Rwanda &nbsp;|&nbsp; www.auca.ac.rw &nbsp;|&nbsp; info@auca.ac.rw
        </div>
    </div>

    <!-- ── DEPT NAME: Edwardian Script ITC, bold, 22pt, centered ── -->
    <div class="lh-dept">Directorate for Admissions and Academic Records</div>

    <!-- ── CONTACT: 10pt, centered ──────────────────────────────── -->
    <div class="lh-contact">
        Mobile Phone : (+250)724 796 996 / 724 474 805/ 788 473 035
    </div>

    <!-- ── EMAIL LINE with bottom border ─────────────────────────── -->
    <div class="lh-email-line">
        Email: <a href="mailto:registrar@auca.ac.rw">registrar@auca.ac.rw</a>,
        &nbsp;||&nbsp;
        <a href="mailto:juvenal.nsengiyumva@auca.ac.rw">juvenal.nsengiyumva@auca.ac.rw</a>
    </div>

    <!-- ── BLANK LINE ─────────────────────────────────────────────── -->
    <div class="cert-spacer">&nbsp;</div>

    <!-- ── DATE: 12pt, "Kigali, [date field]" ────────────────────── -->
    <div class="cert-date">
        Kigali, <asp:Label ID="lblDate" runat="server" />
    </div>

    <!-- ── BLANK LINE ─────────────────────────────────────────────── -->
    <div class="cert-spacer">&nbsp;</div>

    <!-- ── TITLE: bold 13.5pt, indented (left=1in + firstLine=0.5in) -->
    <div class="cert-title">CERTIFICATE OF GOOD STANDING</div>

    <!-- ── TWO BLANK double-spaced lines (matching Word spacers) ──── -->
    <div class="cert-spacer">&nbsp;</div>
    <div class="cert-spacer">&nbsp;</div>

    <!-- ── INTRO PARAGRAPH ───────────────────────────────────────── -->
    <div class="cert-intro">
        I, the undersigned, <b><asp:Label ID="lblApprovedBy" runat="server" /></b>,
        <b>Director for Admissions and Academic Records</b>
        of the Adventist University of Central Africa, hereby certify that:
    </div>

    <!-- ── BODY LINES — double spaced (line=360) ─────────────────── -->
    <span class="cert-body-line">
        <b><asp:Label ID="lblName" runat="server" /></b>,
    </span>

    <span class="cert-body-line">
        Born on <b><asp:Label ID="lblDOB" runat="server" /></b>
    </span>

    <span class="cert-body-line">
        has been a regular student of this University, registered under ID No.
        <b><asp:Label ID="lblStudentID" runat="server" /></b>,
    </span>

    <span class="cert-body-line">
        From <b><asp:Label ID="lblFrom" runat="server" /></b>
        to <b><asp:Label ID="lblTo" runat="server" /></b>.
    </span>

    <span class="cert-body-line">
        <span class="lbl">Year: </span><span class="val"><asp:Label ID="lblYear" runat="server" /></span>
    </span>

    <span class="cert-body-line">
        <span class="lbl">Faculty: </span><span class="val"><asp:Label ID="lblFaculty" runat="server" /></span>
    </span>

    <span class="cert-body-line">
        <span class="lbl">Major: </span><span class="val"><asp:Label ID="lblMajor" runat="server" /></span>
    </span>

    <span class="cert-body-line">
        <span class="lbl">Academic year: </span><span class="val"><asp:Label ID="lblAcademicYear" runat="server" /></span>
    </span>

    <span class="cert-body-line">
        <span class="lbl">Validity: </span><span class="val"><asp:Label ID="lblValidity" runat="server" /></span>
    </span>

    <!-- ── PURPOSE STATEMENT ──────────────────────────────────────── -->
    <span class="cert-purpose">
        This certificate is issued for any legal or administrative purpose it may serve
    </span>

    <!-- ── SIGNATURE + QR ─────────────────────────────────────────── -->
    <div class="cert-footer-row">

        <!-- Left: signature image (optional) + underscores + name/title -->
        <div class="sig-block">
            <img class="sig-img"
                 src='<%= ResolveUrl("~/Images/signature.png") %>'
                 alt="Signature"
                 onerror="this.style.display='none'" />
            <!-- Underscores replicate Word's "__________________________" sig line -->
            <span class="sig-underline">__________________________________________</span>
            <span class="sig-name"><asp:Label ID="lblApprovedBy2" runat="server" /></span>
            <span class="sig-title">Director for Admissions and Academic Records</span>
            <span class="sig-org">Adventist University of Central Africa</span>
        </div>

        <!-- Right: QR code + "Scan to verify my Validity" caption above it -->
        <div class="qr-block">
            <span class="qr-caption">Scan to verify my<br />Validity</span>
            <asp:Image ID="imgQR" runat="server" Width="110px" Height="110px"
                AlternateText="QR Code" />
        </div>

    </div>

</div>
<!-- ══════════════════════════════════════════════════════════════════ -->

</asp:Content>