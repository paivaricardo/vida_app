import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';


class PdfViewScreen extends StatefulWidget {
  final pw.Document doc;
  final String pdfFileName;

  const PdfViewScreen({required this.doc, this.pdfFileName = 'document', Key? key}) : super(key: key);

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Visualizar PDF')),
      body: PdfPreview(
        initialPageFormat: PdfPageFormat.a4,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        pdfFileName: widget.pdfFileName,
        build: (format) => widget.doc.save(),
      ),
    );
  }
}
