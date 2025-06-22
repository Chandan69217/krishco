import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:krishco/api_services/api_service.dart';
import 'package:krishco/utilities/cust_colors.dart';
import 'package:krishco/widgets/custom_network_image/custom_network_image.dart';
import 'package:krishco/widgets/file_viewer/image_viewer.dart';
import 'package:krishco/widgets/file_viewer/pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


// class ConsumerProductCatalogueScreen extends StatefulWidget {
//   final Map<String, dynamic> jsonData;
//   final int? selectedTabIndex;
//   final String? title;
//   final bool? showNewArrivalsOnly;
//
//   const ConsumerProductCatalogueScreen({
//     super.key,
//     required this.jsonData,
//     this.selectedTabIndex = 0,
//     this.title = 'Product Catalogues',
//     this.showNewArrivalsOnly = false
//   });
//
//   @override
//   State<ConsumerProductCatalogueScreen> createState() => _ConsumerProductCatalogueScreenState();
// }
//
// class _ConsumerProductCatalogueScreenState extends State<ConsumerProductCatalogueScreen> {
//   int selectedTabIndex = 0;
//
//   final List<String> tabTitles = ['All', 'New Arrival'];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((duration){
//       setState(() {
//         selectedTabIndex = widget.selectedTabIndex??0;
//       });
//     });
//   }
//
//   void _onTabSelected(int index) {
//     setState(() {
//       selectedTabIndex = index;
//     });
//   }
//
//   String formatDate(String? input) {
//     if (input == null) return '-';
//     try {
//       final dateTime = DateTime.parse(input);
//       return DateFormat("hh:mm a • dd MMMM yyyy").format(dateTime);
//     } catch (e) {
//       return input;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List allData = widget.jsonData['data'] ?? [];
//     final List filteredData = selectedTabIndex == 0
//         ? allData
//         : allData.where((item) => item['new_arrivals'] == true).toList();
//
//     return Scaffold(
//       appBar: !widget.showNewArrivalsOnly! ? AppBar(
//         title: Text(widget.title??'Product Catalogues'),
//       ):null,
//       body: Column(
//         children: [
//           const SizedBox(height: 12),
//           if(!widget.showNewArrivalsOnly!)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: List.generate(tabTitles.length, (index) {
//                   final isSelected = selectedTabIndex == index;
//                   return Expanded(
//                     child: GestureDetector(
//                       onTap: () => _onTabSelected(index),
//                       child: AnimatedContainer(
//                         duration: Duration(milliseconds: 200),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.blue : Colors.transparent,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           tabTitles[index],
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black87,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           Expanded(
//             child: filteredData.isEmpty
//                 ? const Center(child: Text("No catalogue found"))
//                 : CatalogueListView(dataList: filteredData),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// class CatalogueListView extends StatelessWidget {
//   final List dataList;
//
//   const CatalogueListView({super.key, required this.dataList});
//
//   @override
//   Widget build(BuildContext context) {
//     if (dataList.isEmpty) {
//       return const Center(child: Text("No catalogue found"));
//     }
//
//     return ListView.builder(
//       itemCount: dataList.length,
//       itemBuilder: (context, index) {
//         final item = dataList[index];
//         final addBy = item['add_by'] ?? {};
//         final catalogues = item['catalogue'] ?? [];
//
//         return Container(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Icon(Icons.business, color: Colors.teal),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           addBy['name'] ?? 'Unknown Company',
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleMedium
//                               ?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   if (item['new_arrivals'] == true)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.orange.shade100,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         'New Arrival',
//                         style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                           color: Colors.deepOrange,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               GridView.builder(
//                 itemCount: catalogues.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                   childAspectRatio: 1,
//                 ),
//                 itemBuilder: (context, index) {
//                   final url = catalogues[index];
//                   final isPDF = url.toString().toLowerCase().endsWith('.pdf');
//
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) =>
//                           isPDF ? PdfViewerScreen(pdfUrl: url) : ImageViewerScreen(imageUrl: url,),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8.0),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             offset: Offset(0, 4),
//                             blurRadius: 3,
//                           )
//                         ],
//                       ),
//                       child: isPDF
//                           ? _PDFPreview(pdfUrl: url)
//                           : CustomNetworkImage(imageUrl: url,borderRadius: BorderRadius.circular(8.0),),
//                     ),
//                   );
//                 },
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }


class ProductCatalogueScreen extends StatefulWidget {
  final int? selectedTabIndex;
  final String? title;
  final bool? showNewArrivalsOnly;

  const ProductCatalogueScreen({
    super.key,
    this.selectedTabIndex = 0,
    this.title,
    this.showNewArrivalsOnly = false,
  });

  @override
  State<ProductCatalogueScreen> createState() => _ProductCatalogueScreenState();
}

class _ProductCatalogueScreenState extends State<ProductCatalogueScreen> {
  int selectedTabIndex = 0;
  final List<String> tabTitles = ['All', 'New Arrival'];
  late Future<Map<String,dynamic>?> _futureProductCatalogues;

  @override
  void initState() {
    super.initState();
    _futureProductCatalogues = APIService.getInstance(context).productCatalogues.getProductCatalogues();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedTabIndex = widget.selectedTabIndex ?? 0;
      });
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null
          ? AppBar(title: Text(widget.title ?? ''))
          : null,
      body: FutureBuilder(future: _futureProductCatalogues,
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: SizedBox.square(
                  dimension: 25.0,
                  child: CircularProgressIndicator(
                    color: CustColors.nile_blue,
                  ),
                ),
              );
            }

            if(snapshot.hasData){
              final data = snapshot.data;
              if(data != null){
                final List allData = data['data'] ?? [];
                final List filteredData = selectedTabIndex == 0
                    ? allData
                    : allData.where((item) => item['new_arrivals'] == true).toList();

               return Column(
                 children: [
                   if (!widget.showNewArrivalsOnly!)...[
                     const SizedBox(height: 12),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 12),
                       child: Container(
                         decoration: BoxDecoration(
                           color: Colors.grey[300],
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: Row(
                           children: List.generate(tabTitles.length, (index) {
                             final isSelected = selectedTabIndex == index;
                             return Expanded(
                               child: GestureDetector(
                                 onTap: () => _onTabSelected(index),
                                 child: AnimatedContainer(
                                   duration: const Duration(milliseconds: 200),
                                   padding: const EdgeInsets.symmetric(vertical: 12),
                                   decoration: BoxDecoration(
                                     color: isSelected ? Colors.blue : Colors.transparent,
                                     borderRadius: BorderRadius.circular(12),
                                   ),
                                   alignment: Alignment.center,
                                   child: Text(
                                     tabTitles[index],
                                     style: TextStyle(
                                       color: isSelected ? Colors.white : Colors.black87,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ),
                               ),
                             );
                           }),
                         ),
                       ),
                     ),
                     const SizedBox(height: 12),
                   ],
                   Expanded(
                     child: filteredData.isEmpty
                         ? const Center(child: Text("No catalogue found"))
                         : _CatalogueGalleryView(dataList: filteredData),
                   ),
                 ],
               );
              }else{
                return Center(
                  child: Text('No catalogue found'),
                );
              }
            }else{
              return Center(
                child: Text('Something went wrong !!'),
              );
            }
          }
      ),
    );
  }
}

class _CatalogueGalleryView extends StatelessWidget {
  final List dataList;

  const _CatalogueGalleryView({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> catalogueItems = [];
    for (var item in dataList) {
      final List catalogues = item['catalogue'] ?? [];
      for (var url in catalogues) {
        catalogueItems.add({
          'url': url,
          'isPDF': url.toString().toLowerCase().endsWith('.pdf'),
          'company': item['add_by']?['name'] ?? 'Unknown',
          'newArrival': item['new_arrivals'] == true,
        });
      }
    }

    if (catalogueItems.isEmpty) {
      return const Center(child: Text("No catalogue found"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: catalogueItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        final item = catalogueItems[index];
        final url = item['url'];
        final isPDF = item['isPDF'];
        final company = item['company'];
        final isNew = item['newArrival'];

        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => isPDF
                  ? PdfViewerScreen(pdfUrl: url)
                  : ImageViewerScreen(imageUrl: url),
            ));
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: isPDF
                    ? SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: _PDFPreview(pdfUrl: url))
                    : CustomNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(4.0),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              if (isNew)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: Container(
              //     color: Colors.black.withOpacity(0.5),
              //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              //     child: Text(
              //       company,
              //       maxLines: 1,
              //       overflow: TextOverflow.ellipsis,
              //       style: const TextStyle(
              //         fontSize: 11,
              //         color: Colors.white,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }
}

class _PDFPreview extends StatefulWidget {
  final String pdfUrl;
  const _PDFPreview({super.key, required this.pdfUrl});

  @override
  State<_PDFPreview> createState() => _PDFPreviewState();
}

class _PDFPreviewState extends State<_PDFPreview> {
  File? pdfFile;
  ImageProvider? pdfImage;
  String? message;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = Uri.parse(widget.pdfUrl).pathSegments.last;
      final filePath = '${tempDir.path}/$fileName';

      final uri = Uri.parse(widget.pdfUrl);
      final response = await get(uri);

      if (response.statusCode != 200 || response.bodyBytes.isEmpty ||
          (response.contentLength != null &&
              response.bodyBytes.length < response.contentLength!)) {
        setState(() => message = "Invalid or failed PDF");
        return;
      }

      final file = File(filePath)..writeAsBytesSync(response.bodyBytes);

      final doc = await PdfDocument.openFile(file.path);
      final page = await doc.getPage(1);
      final pageImage = await page.render(width: 400, height: 400);
      await page.close();
      await doc.close();

      if (!mounted) return;
      setState(() {
        pdfFile = file;
        message = null;
        pdfImage = MemoryImage(pageImage!.bytes);
      });
    } catch (e, trace) {
      debugPrint("PDF Preview Error: $e\n$trace");
      if (!mounted) return;
      setState(() => message = 'Preview Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      return Center(child: Text(message!, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.red)));
    }

    return pdfImage != null
        ? Image(
      image: pdfImage!,
      height: 200,
      fit: BoxFit.cover,
    )
        : const SizedBox.square(
      dimension: 25.0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}




// class ProductCatalogueScreen extends StatelessWidget {
//   final Map<String, dynamic> jsonData;
//
//   const ProductCatalogueScreen({super.key, required this.jsonData});
//
//   String formatDate(String? input) {
//     if (input == null) return '-';
//     try {
//       final dateTime = DateTime.parse(input);
//       return DateFormat("hh:mm a • dd MMMM yyyy").format(dateTime);
//     } catch (e) {
//       return input;
//     }
//   }
//
//   void _launchCaller(BuildContext context, String number) async {
//     final uri = Uri.parse("tel:$number");
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not launch phone dialer")),
//       );
//     }
//   }
//
//   void _launchEmail(BuildContext context, String email) async {
//     final uri = Uri(scheme: 'mailto', path: email);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Could not open email client")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final List dataList = jsonData['data'] ?? [];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Catalogue'),
//       ),
//       body: dataList.isEmpty
//           ? const Center(child: Text("No catalogue found"))
//           : ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           final item = dataList[index];
//           final addBy = item['add_by'] ?? {};
//           final catalogues = item['catalogue'] ?? [];
//           final addDate = formatDate(item['add_date']);
//           final updateDate = formatDate(item['update_date']);
//
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12.0),
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 12.0,
//                   offset: Offset(0, 4),
//                   color: Colors.black12,
//                   // blurStyle: BlurStyle.outer
//                 )
//               ]
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Icon(Icons.business, color: Colors.teal),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             addBy['name'] ?? 'Unknown Company',
//                             style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//                           ),
//                           if (addBy['email'] != null)
//                             Text("📧 ${addBy['email']}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13)),
//                           if (addBy['number'] != null)
//                             Text("📞 ${addBy['number']}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13),),
//                         ],
//                       ),
//                     ),
//                     if (item['new_arrivals'] == true)
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.orange.shade100,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'New Arrival',
//                           style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.deepOrange, fontSize: 12, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(Icons.watch_later,color: Colors.teal,),
//                     const SizedBox(width: 8.0,),
//                     Text("Uploaded: $addDate", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13, color: Colors.black87)),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.update,color: Colors.teal,),
//                     const SizedBox(width: 8.0,),
//                     Text('Updated: $updateDate', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13, color: Colors.black87)),
//                   ],
//                 ),
//
//                 const SizedBox(height: 10),
//                 Wrap(
//                   spacing: 12,
//                   runSpacing: 8,
//                   children: [
//                     if (addBy['email']?.isNotEmpty ?? false)
//                       OutlinedButton.icon(
//                         icon: const Icon(Icons.email, color: Colors.teal),
//                         label: Text("Email", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.teal)),
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Colors.teal),
//                         ),
//                         onPressed: () => _launchEmail(context, addBy['email']),
//                       ),
//                     if (addBy['number']?.isNotEmpty ?? false)
//                       OutlinedButton.icon(
//                         icon: const Icon(Icons.call, color: Colors.teal),
//                         label: Text("Call", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.teal)),
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Colors.teal),
//                         ),
//                         onPressed: () => _launchCaller(context, addBy['number']),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Text("📂 Catalogues", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 8),
//                 ...catalogues.asMap().entries.map<Widget>((entry) {
//                   final index = entry.key;
//                   final url = entry.value;
//                   final fileName = Uri.parse(url).pathSegments.last;
//
//                   return ListTile(
//                     contentPadding: EdgeInsets.zero,
//                     leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
//                     title: Text("Catalogue ${index + 1}", style: const TextStyle(fontWeight: FontWeight.w600)),
//                     subtitle: Text(fileName, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.open_in_new, color: Colors.teal),
//                       onPressed: () async {
//                         final uri = Uri.parse(url);
//                         if (await canLaunchUrl(uri)) {
//                           await launchUrl(uri, mode: LaunchMode.externalApplication);
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Could not open catalogue")),
//                           );
//                         }
//                       },
//                     ),
//                   );
//                 }).toList(),
//                 const SizedBox(height: 12),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton.icon(
//                     icon: const Icon(Icons.info_outline, size: 18),
//                     label: const Text("View Full Details"),
//                     onPressed: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (_) => CatalogueDetailsScreen(catalogueData: item),
//                       //   ),
//                       // );
//                     },
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }





