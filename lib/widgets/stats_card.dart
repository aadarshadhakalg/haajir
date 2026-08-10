import 'package:flutter/material.dart';
import 'package:haajir/models/attendance_record.dart';
import 'package:haajir/widgets/container_dot.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({required this.records, super.key});

  final List<AttendanceRecord> records;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.secondary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL DAYS PRESENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: colorScheme.onSecondaryContainer.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '142',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'days in 2023',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSecondaryContainer.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Row(
                children: const [
                  ContainerDot(color: Color(0xFF2E7D32)),
                  SizedBox(width: 6),
                  Text(
                    '94% Attendance',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: const [
                  Icon(Icons.trending_up, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    '+2% vs last month',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
