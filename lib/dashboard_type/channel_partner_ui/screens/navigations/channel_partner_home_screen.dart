import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishco/screens/claim_invoice/create_claim_screen.dart';
import 'package:krishco/screens/orders/place_order_screen.dart';
import 'package:krishco/screens/product_catalogues/product_catalogue.dart';
import 'package:krishco/screens/redemeption_catalogues/redemption_catalogues.dart';




class ChannelPartnerHomeScreen extends StatelessWidget {
  final VoidCallback? onRefresh;
  ChannelPartnerHomeScreen({super.key,this.onRefresh});

  final List<FlSpot> loyaltyPoints = [
    FlSpot(0, 30),
    FlSpot(1, 38),
    FlSpot(2, 27),
    FlSpot(3, 45),
    FlSpot(4, 42),
    FlSpot(5, 82),
    FlSpot(6, 55),
  ];

  final List<FlSpot> redeemPoints = [
    FlSpot(0, 12),
    FlSpot(1, 30),
    FlSpot(2, 44),
    FlSpot(3, 29),
    FlSpot(4, 31),
    FlSpot(5, 50),
    FlSpot(6, 40),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu / Dashboard',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 14,
                    color: Color(0xFF6B7A99),
                  ),
                ),
                SizedBox(height: 12.0,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F2F66).withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      )
                    ],
                  ),
                  child: Center(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      // crossAxisSpacing: 8.0,
                      mainAxisSpacing: 18.0,
                      childAspectRatio: 1,
                      // childAspectRatio: 2.6,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        DashboardMenuButton(
                          icon: 'assets/icons/box-open-full.webp',
                          label: 'Product Catalogues',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => ProductCatalogueScreen(
                                title: 'Product Catalogues'
                              ),
                            ));
                          },
                        ),
                        DashboardMenuButton(
                          icon: 'assets/icons/sparkles.webp',
                          label: 'New Arrivals',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => ProductCatalogueScreen(
                                selectedTabIndex: 1,
                                showNewArrivalsOnly: true,
                                title: 'New Arrivals',
                              ),
                            ));
                          },
                        ),
                        DashboardMenuButton(
                          icon: 'assets/icons/gift.webp',
                          label: 'Redemption Catalogues',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (_) => RedemptionCataloguesScreen(
                                title: "Redemption Catalogues",
                              ),
                            ));
                          },
                        ),
                        DashboardMenuButton(
                          icon: 'assets/icons/features.webp',
                          label: 'Submit Claim',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_) => CreateClaimScreen(
                                  onSuccess: onRefresh,
                                )
                            ));
                          },
                        ),
                        DashboardMenuButton(
                          icon: 'assets/icons/dolly-flatbed-alt.webp',
                          label: 'Place Order',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (_) => PlaceOrderScreen()
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                // Top Summary Cards
                GridView.count(
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: const [
                    _SummaryCard(
                      title: 'QR Scanned',
                      subtitle: '| Today',
                      value: '0',
                      percentage: '0%',
                      increase: true,
                      icon: Icons.qr_code_2_outlined,
                      bgColor: Color(0xFFE6E9FF),
                    ),
                    _SummaryCard(
                      title: 'Redemption Points',
                      subtitle: '| This Month',
                      value: '0',
                      percentage: '0%',
                      increase: true,
                      icon: Icons.currency_rupee,
                      bgColor: Color(0xFFD9F0D9),
                    ),
                    _SummaryCard(
                      title: 'Customers',
                      subtitle: '| This Year',
                      value: '5',
                      percentage: '83.87%',
                      increase: false,
                      icon: Icons.groups_sharp,
                      bgColor: Color(0xFFFFEDD8),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Chart Placeholder
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16,8,0,16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F2F66).withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Redemption Points | ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F2F66),
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9AA7BF),
                            ),
                          ),
                          Spacer(),
                          _DateRangeMenu(
                            onSelected: (option) {
                              switch (option) {
                                case _DateRangeOption.today:
                                // handle today
                                  break;
                                case _DateRangeOption.thisMonth:
                                // handle this month
                                  break;
                                case _DateRangeOption.thisYear:
                                // handle this year
                                  break;
                                case _DateRangeOption.custom:
                                // show custom date picker
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: _LoyaltyRedeemLineChart(
                          loyaltyPoints: loyaltyPoints,
                          redeemPoints: redeemPoints,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Top Selling Placeholder
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16,8,0,16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F2F66).withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      )
                    ],
                  ),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Top Selling | ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F2F66),
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9AA7BF),
                            ),
                          ),
                          Spacer(),
                          _DateRangeMenu(
                            onSelected: (option) {
                              switch (option) {
                                case _DateRangeOption.today:
                                // handle today
                                  break;
                                case _DateRangeOption.thisMonth:
                                // handle this month
                                  break;
                                case _DateRangeOption.thisYear:
                                // handle this year
                                  break;
                                case _DateRangeOption.custom:
                                // show custom date picker
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Text(
                          'No Data Available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0F2F66),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Activity
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16,8,0,16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F2F66).withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      )
                    ],
                  ),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Recent Activity | ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F2F66),
                            ),
                          ),
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9AA7BF),
                            ),
                          ),
                          Spacer(),
                          _DateRangeMenu(
                            onSelected: (option) {
                              switch (option) {
                                case _DateRangeOption.today:
                                // handle today
                                  break;
                                case _DateRangeOption.thisMonth:
                                // handle this month
                                  break;
                                case _DateRangeOption.thisYear:
                                // handle this year
                                  break;
                                case _DateRangeOption.custom:
                                // show custom date picker
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: Text(
                          'No Activity Available',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0F2F66),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // QR OverView
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16,8,0,16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F2F66).withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'QR Overview | ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F2F66),
                            ),
                          ),
                          Text(
                            '2025',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9AA7BF),
                            ),
                          ),
                          Spacer(),
                          _DateRangeMenu(
                            onSelected: (option) {
                              switch (option) {
                                case _DateRangeOption.today:
                                // handle today
                                  break;
                                case _DateRangeOption.thisMonth:
                                // handle this month
                                  break;
                                case _DateRangeOption.thisYear:
                                // handle this year
                                  break;
                                case _DateRangeOption.custom:
                                // show custom date picker
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Center(child: _StatusDonutChart()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String percentage;
  final bool increase;
  final IconData icon;
  final Color bgColor;

  const _SummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.percentage,
    required this.increase,
    required this.icon,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16,8,0,16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2F66).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon,size:24 ,color: Colors.black,),
              // child: Image.network(imageUrl, width: 24, height: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$title $subtitle',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F2F66),
                        ),
                      ),
                    ),
                    // Spacer(),
                    _DateRangeMenu(
                      onSelected: (option) {
                        switch (option) {
                          case _DateRangeOption.today:
                          // handle today
                            break;
                          case _DateRangeOption.thisMonth:
                          // handle this month
                            break;
                          case _DateRangeOption.thisYear:
                          // handle this year
                            break;
                          case _DateRangeOption.custom:
                          // show custom date picker
                            break;
                        }
                      },
                    ),
                  ],
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F2F66),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  flex: 1,
                  child: Text(
                    '${increase ? '' : '-'}$percentage ${increase ? 'Increase' : 'Decrease'}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: increase ? const Color(0xFF1F6E2E) : const Color(0xFFB91C1C),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



class _LoyaltyRedeemLineChart extends StatelessWidget {
  final List<FlSpot> loyaltyPoints;
  final List<FlSpot> redeemPoints;

  const _LoyaltyRedeemLineChart({
    super.key,
    required this.loyaltyPoints,
    required this.redeemPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minY: 0,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 10,
                maxIncluded: false,
                minIncluded: false,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      value.toInt().toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  );
                },
              ),
            ),

            bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const times = ['00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00'];
                      return Text(times[value.toInt()], style: const TextStyle(fontSize: 10));
                    },
                    interval: 1,
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                _buildLine(loyaltyPoints, Colors.blue, const Color(0xFFEBF1FF)),
                _buildLine(redeemPoints, Colors.green, const Color(0xFFDFF6EB)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _LegendDot(color: Colors.blue, label: 'Loyalty Points'),
            SizedBox(width: 16),
            _LegendDot(color: Colors.green, label: 'Redeem Points'),
          ],
        ),
      ],
    );
  }

  LineChartBarData _buildLine(List<FlSpot> points, Color color, Color gradientColor) {
    return LineChartBarData(
      spots: points,
      isCurved: true,
      color: color,
      barWidth: 3,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [gradientColor.withOpacity(0.5), gradientColor.withOpacity(0.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: Colors.white,
          strokeColor: color,
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}


class _StatusDonutChart extends StatelessWidget {
  const _StatusDonutChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: const [
            _LegendItem(color: Color(0xFF4B67E2), label: 'Scanned'),
            _LegendItem(color: Color(0xFF88C984), label: 'Available'),
            _LegendItem(color: Color(0xFFF9CE5C), label: 'Transit'),
            _LegendItem(color: Color(0xFFEF6C6C), label: 'Dispatch'),
            _LegendItem(color: Color(0xFF6ACBE0), label: 'Ready To Scan'),
            _LegendItem(color: Color(0xFF3FAF92), label: 'Expired'),
            _LegendItem(color: Color(0xFFFFA561), label: 'Scan Completed'),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          width: 240,
          child: PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 60,
              startDegreeOffset: -90,
              sections: _buildSections(),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    final values = [
      _Status(color: const Color(0xFF4B67E2), value: 30), // Scanned
      _Status(color: const Color(0xFF88C984), value: 10), // Available
      _Status(color: const Color(0xFFF9CE5C), value: 70), // Transit
      _Status(color: const Color(0xFFEF6C6C), value: 8), // Dispatch
      _Status(color: const Color(0xFF6ACBE0), value: 42), // Ready To Scan
      _Status(color: const Color(0xFF3FAF92), value: 12), // Expired
      _Status(color: const Color(0xFFFFA561), value: 6), // Scan Completed
    ];

    return values
        .where((v) => v.value > 0)
        .map((v) => PieChartSectionData(
      value: v.value.toDouble(),
      color: v.color,
      showTitle: false,
      radius: 60,
    ))
        .toList();
  }
}

class _Status {
  final Color color;
  final int value;

  _Status({required this.color, required this.value});
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

enum _DateRangeOption { today, thisMonth, thisYear, custom }

class _DateRangeMenu extends StatelessWidget {
  final void Function(_DateRangeOption) onSelected;

  const _DateRangeMenu({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<_DateRangeOption>(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.grey.shade600),
          iconSize: const WidgetStatePropertyAll(22),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        menuPadding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.white,
        icon: const Icon(Icons.more_vert),
        onSelected: onSelected,
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: _DateRangeOption.today,
            child: Text('Today'),
          ),
          PopupMenuItem(
            value: _DateRangeOption.thisMonth,
            child: Text('This Month'),
          ),
          PopupMenuItem(
            value: _DateRangeOption.thisYear,
            child: Text('This Year'),
          ),
          PopupMenuItem(
            value: _DateRangeOption.custom,
            child: Text('Custom'),
          ),
        ],
      ),
    );
  }
}




// class DashboardMenuButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;
//
//   const DashboardMenuButton({
//     super.key,
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF0F2F66).withOpacity(0.1),
//               blurRadius: 15,
//               offset: const Offset(0, 0),
//             )
//           ]
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.blue.shade50,
//               radius: 22,
//               child: Icon(icon, size: 24, color: Colors.blue.shade700),
//             ),
//             const SizedBox(width: 8.0),
//             Expanded(
//               flex:2,
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


class DashboardMenuButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const DashboardMenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue.shade50,
            child: Image.asset(icon, width: 28,height: 28, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



