import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  PdfViewerScreen({super.key,required this.pdfUrl});

  @override
  State<StatefulWidget> createState() => _PdfViewerStates();
}


class _PdfViewerStates extends State<PdfViewerScreen> {

  final TextEditingController _searchController = TextEditingController();
  final PdfViewerController _pdfViewerController = PdfViewerController();
  PdfTextSearchResult _searchResult = PdfTextSearchResult();


  @override
  void initState() {
    super.initState();
  }


  void _search(String query) {
    _searchResult = _pdfViewerController.searchText(query);
    _searchResult.addListener(() {
      setState(() {
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
          child: SfPdfViewer.network(widget.pdfUrl,
            currentSearchTextHighlightColor: Colors.blue.withValues(alpha: 0.3),
            controller: _pdfViewerController,
            otherSearchTextHighlightColor: Colors.yellow.withValues(alpha: 0.4),

          )),
    );
  }



  @override
  void dispose() {
    super.dispose();
    _pdfViewerController.dispose();
    _searchResult.removeListener((){});
  }


  AppBar _appBar() {
    return AppBar(
      title: Text(widget.pdfUrl.split('/').last),
    );
  }

}