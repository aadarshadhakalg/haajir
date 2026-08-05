import 'package:flutter/material.dart';
import 'package:haajir/models/attendance_record.dart';
import 'package:haajir/widgets/legend_item.dart';

class AttendanceGridCard extends StatelessWidget {
  const AttendanceGridCard({super.key, required this.records});

  final List<AttendanceRecord> records;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Map records by date key ('YYYY-MM-DD')
    final recordMap = <String, AttendanceRecord>{};
    for (final record in records) {
      final key =
          '${record.date.year}-${record.date.month.toString().padLeft(2, '0')}-${record.date.day.toString().padLeft(2, '0')}';
      recordMap[key] = record;
    }

    // Grid Status Array mapping to colors:
    // 1: Present (#2E7D32)
    // 0: Off (surfaceContainer)
    // 2: Leave/Absent (surfaceContainerHighest)
    final List<int> gridData = List.generate(35, (index) {
      final day = today.subtract(Duration(days: 34 - index));
      final key =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      final record = recordMap[key];
      if (record == null) return 0;
      return record.status ? 1 : 2;
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Days Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map(
                  (day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF45464D),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),

          // 7-Column Contribution Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final status = gridData[index];
              Color boxColor;

              switch (status) {
                case 1:
                  boxColor = const Color(0xFF2E7D32); // Present Green
                  break;
                case 2:
                  boxColor = colorScheme.surfaceContainerHighest; // Leave
                  break;
                case 0:
                default:
                  boxColor = colorScheme.surfaceContainer; // Off
                  break;
              }

              return Container(
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Legend
          Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LegendItem(color: Color(0xFF2E7D32), label: 'Present'),
              const SizedBox(width: 24),
              LegendItem(
                color: colorScheme.surfaceContainerHighest,
                label: 'Leave',
              ),
              const SizedBox(width: 24),
              LegendItem(color: colorScheme.surfaceContainer, label: 'Off'),
            ],
          ),
        ],
      ),
    );
  }
}
