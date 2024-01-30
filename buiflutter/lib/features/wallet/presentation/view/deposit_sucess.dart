import 'package:flutter/material.dart';
import 'package:talab/config/router/app_route.dart';
import 'package:talab/config/theme/app_color_constant.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DepositSuccessView extends StatelessWidget {
  final double amount;
  final String destination;
  final String transactionTime;

  const DepositSuccessView({
    Key? key,
    required this.amount,
    required this.destination,
    required this.transactionTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assume these are your logos for the different destinations.
    final Map<String, String> logos = {
      'eSewa': 'assets/images/esewa.png',
      'Khalti': 'assets/images/khalti.png',
      'Connect IPS': 'assets/images/ips.png',
    };

    String? logo = logos[destination];

    void _createPdf() async {
      final doc = pw.Document();

      /// for using an image from assets
      // final image = await imageFromAssetBundle('assets/image.png');

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text('Talab'),
            ); // Center
          },
        ),
      ); // Page

      /// print the document using the iOS or Android print service:
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => doc.save());
    }

    return Scaffold(
      backgroundColor:
          Colors.blueGrey[900], // Adjust the background color as needed
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => AppRoute.dashboardRoute,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.print, color: Colors.white),
              onPressed: _createPdf),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(height: 20),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Deposit Success',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Below is your transaction summary',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  // Top up destination section

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Top up destination",
                        style: TextStyle(
                            fontFamily: "sf-regular",
                            color: Colors.grey,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      if (logo != null)
                        CircleAvatar(
                          backgroundImage: AssetImage(logo),
                          radius: 16,
                          backgroundColor: Colors.transparent,
                        ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            transactionTime,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Top Up',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: "sf-regular",
                    ),
                  ),
                  Text(
                    'NPR $amount',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColorConstant.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorConstant.blue,
                padding: EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.dashboardRoute);
              },
              child: Text(
                'Back to home',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColorConstant.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PreviewScreen extends StatelessWidget {
  final pw.Document doc;

  const PreviewScreen({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "mydoc.pdf",
      ),
    );
  }
}
