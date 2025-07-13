import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../Features/theme/app_colors.dart';
import '../../Models/order_model.dart';

class InvoiceButton extends StatelessWidget {
  final OrderModel order;

  const InvoiceButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.picture_as_pdf_outlined),
      label: Text('Download Invoice'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      onPressed: () => _generateAndSharePdf(context),
    );
  }

  Future<void> _generateAndSharePdf(BuildContext context) async {
    try {
      // Create PDF document
      final pdf = pw.Document();

      // Add content to PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Header(
                  level: 0,
                  child: pw.Text('INVOICE', style: pw.TextStyle(fontSize: 24)),
                ),
                pw.SizedBox(height: 20),

                // Order Info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Order #${order.id.substring(0, 8).toUpperCase()}'),
                        pw.Text('Date: ${_formatDate(order.orderDate)}'),
                      ],
                    ),
                    pw.BarcodeWidget(
                      data: order.id,
                      barcode: pw.Barcode.qrCode(),
                      width: 60,
                      height: 60,
                    ),
                  ],
                ),
                pw.Divider(),

                // Shipping Info
                pw.Text('SHIPPING TO:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(order.shippingAddress),
                pw.SizedBox(height: 10),

                // Payment Info
                pw.Text('PAYMENT METHOD:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text(order.paymentMethod),
                pw.Divider(thickness: 2),

                // Items Table Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('ITEM', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('QTY', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('PRICE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('TOTAL', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Divider(),

                // Order Items
                ...order.items.map((item) => pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: 10),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        flex: 3,
                        child: pw.Text(item.name),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(item.quantity.toString()),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text('\$${item.price.toStringAsFixed(2)}'),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                )),

                pw.Divider(thickness: 2),

                // Totals
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Subtotal: \$${order.totalAmount.toStringAsFixed(2)}'),
                        pw.Text('Shipping: \$5.99'),
                        pw.Text('Tax: \$${(order.totalAmount * 0.08).toStringAsFixed(2)}'),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'TOTAL: \$${(order.totalAmount + 5.99 + (order.totalAmount * 0.08)).toStringAsFixed(2)}',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Save and share PDF
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'invoice-${order.id.substring(0, 8)}.pdf',
      );

    } catch (e) {
      Get.snackbar('Error', 'Failed to generate invoice: ${e.toString()}');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}