import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ChannelPartnerHomeScreen extends StatelessWidget {
  const ChannelPartnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Home / Dashboard',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7A99),
                  ),
                ),
                const SizedBox(height: 24),
                // Top Summary Cards
                GridView.count(
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: const [
                    SummaryCard(
                      title: 'QR Scanned',
                      subtitle: '| Today',
                      value: '0',
                      percentage: '0%',
                      increase: true,
                      imageUrl:
                      'https://storage.googleapis.com/a1aa/image/155f1f5c-aa13-4f53-8fb1-3036eedaf55d.jpg',
                      bgColor: Color(0xFFE6E9FF),
                    ),
                    SummaryCard(
                      title: 'Redemption Points',
                      subtitle: '| This Month',
                      value: '0',
                      percentage: '0%',
                      increase: true,
                      imageUrl:
                      'https://storage.googleapis.com/a1aa/image/b1d98490-29ec-4cb8-e4e6-7b01072fdce1.jpg',
                      bgColor: Color(0xFFD9F0D9),
                    ),
                    SummaryCard(
                      title: 'Customers',
                      subtitle: '| This Year',
                      value: '5',
                      percentage: '83.87%',
                      increase: false,
                      imageUrl:
                      'https://storage.googleapis.com/a1aa/image/ed2d64ec-8011-48d9-279a-12e9b3757cd6.jpg',
                      bgColor: Color(0xFFFFEDD8),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Chart Placeholder
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Redemption Points',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F2F66),
                            ),
                          ),
                          Text(
                            '...',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9AA7BF),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 240,
                        child: Center(
                          child: Text('Chart Placeholder'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Top Selling Placeholder
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top Selling',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F2F66),
                            ),
                          ),
                          Text(
                            '...',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF9AA7BF),
                            ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final String percentage;
  final bool increase;
  final String imageUrl;
  final Color bgColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.percentage,
    required this.increase,
    required this.imageUrl,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              child: Image.network(imageUrl, width: 24, height: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title $subtitle',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F2F66),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F2F66),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${increase ? '' : '-'}$percentage ${increase ? 'Increase' : 'Decrease'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: increase ? const Color(0xFF1F6E2E) : const Color(0xFFB91C1C),
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
