// lib/widgets/export_dialog.dart

import 'package:flutter/material.dart';
import 'package:exosky_tango/models/export_format.dart';

class ExportDialog extends StatelessWidget {
  final Function(ExportFormat) onExport;

  const ExportDialog({Key? key, required this.onExport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('CSV'),
            onTap: () => onExport(ExportFormat.csv),
          ),
          ListTile(
            title: const Text('JSON'),
            onTap: () => onExport(ExportFormat.json),
          ),
          ListTile(
            title: const Text('PDF'),
            onTap: () => onExport(ExportFormat.pdf),
          ),
        ],
      ),
    );
  }
}
