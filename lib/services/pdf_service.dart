import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';
import '../core/constants/app_constants.dart';

/// Service for generating PDF inspection reports
class PdfService {
  /// Generate a PDF report from inspection result
  Future<File> generateInspectionReport(InspectionResult result) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(),
            pw.SizedBox(height: 20),
            _buildVehicleInfo(result.vehicle),
            pw.SizedBox(height: 20),
            _buildHealthScore(result),
            pw.SizedBox(height: 20),
            _buildCategoryResults(result.items),
            pw.SizedBox(height: 20),
            if (result.vibrationTest != null) ...[
              _buildVibrationTestResult(result.vibrationTest!),
              pw.SizedBox(height: 20),
            ],
            _buildRecommendation(result),
            pw.SizedBox(height: 20),
            _buildFooter(result),
          ];
        },
      ),
    );

    // Save to file
    final outputDir = await getApplicationDocumentsDirectory();
    final file = File(
      '${outputDir.path}/inspection_${result.id}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.Widget _buildHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue800,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            AppConstants.appName,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.Text(
            'Vehicle Inspection Report',
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildVehicleInfo(VehicleModel vehicle) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Vehicle Information',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Make/Model', vehicle.displayName),
                    _buildInfoRow('Registration', vehicle.registrationNumber ?? 'N/A'),
                    _buildInfoRow('Year', vehicle.year?.toString() ?? 'N/A'),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Chassis No.', vehicle.chassisNumber ?? 'N/A'),
                    _buildInfoRow('Mileage', vehicle.mileage != null ? '${vehicle.mileage} km' : 'N/A'),
                    _buildInfoRow('Fuel Type', vehicle.fuelType?.displayName ?? 'N/A'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildHealthScore(InspectionResult result) {
    final scoreColor = result.healthScore >= 70
        ? PdfColors.green
        : result.healthScore >= 40
            ? PdfColors.orange
            : PdfColors.red;

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: scoreColor.shade(0.9),
        border: pw.Border.all(color: scoreColor),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Health Score',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                result.riskLevel.displayName,
                style: pw.TextStyle(
                  fontSize: 12,
                  color: scoreColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: scoreColor,
            ),
            child: pw.Text(
              '${result.healthScore}',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCategoryResults(List<InspectionItem> items) {
    // Group items by category
    final categories = <String, List<InspectionItem>>{};
    for (final item in items) {
      categories.putIfAbsent(item.category, () => []).add(item);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Inspection Details',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 12),
        ...categories.entries.map((entry) => _buildCategorySection(entry.key, entry.value)),
      ],
    );
  }

  pw.Widget _buildCategorySection(String category, List<InspectionItem> items) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: PdfColors.grey200,
            child: pw.Text(
              category,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          ...items.map((item) => _buildInspectionItemRow(item)),
        ],
      ),
    );
  }

  pw.Widget _buildInspectionItemRow(InspectionItem item) {
    String answerText;
    PdfColor answerColor;

    switch (item.answer) {
      case InspectionAnswer.yes:
        answerText = '✓ Yes';
        answerColor = PdfColors.green;
        break;
      case InspectionAnswer.no:
        answerText = '✗ No';
        answerColor = PdfColors.red;
        break;
      case InspectionAnswer.notSure:
        answerText = '? Not Sure';
        answerColor = PdfColors.orange;
        break;
      case null:
        answerText = '- Not Checked';
        answerColor = PdfColors.grey;
        break;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Text(
              item.title,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
          pw.Text(
            answerText,
            style: pw.TextStyle(
              fontSize: 10,
              color: answerColor,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildVibrationTestResult(VibrationTestResult test) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Engine Vibration Test',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Stability Score', '${test.stability.toStringAsFixed(1)}%'),
                  _buildInfoRow('Average Acceleration', '${test.averageAcceleration.toStringAsFixed(2)} m/s²'),
                ],
              ),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: test.passed ? PdfColors.green : PdfColors.red,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  test.passed ? 'PASSED' : 'FAILED',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildRecommendation(InspectionResult result) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Recommendation',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            result.recommendation,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(InspectionResult result) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated by ${AppConstants.appName}',
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            'Report ID: ${result.id}',
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            'Date: ${result.inspectedAt.toString().split('.').first}',
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}
