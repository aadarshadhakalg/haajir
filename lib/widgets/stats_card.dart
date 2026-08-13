import 'package:flutter/material.dart';
import 'package:haajir/models/attendance_record.dart';
import 'package:haajir/widgets/container_dot.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({required this.records, super.key});

  final List<AttendanceRecord> records;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final currentDate = DateTime.now();
    final totalDaysPresent = records
        .where((record) => record.date.year == currentDate.year)
        .length;

    final percentageAttendance = (totalDaysPresent / 365) * 100;

    final totalDaysPresentLastMonth = records
        .where((record) => record.date.month == currentDate.month - 1)
        .length;

    final totalDaysPresentThisMonth = records
        .where((record) => record.date.month == currentDate.month)
        .length;

    final difference = totalDaysPresentThisMonth - totalDaysPresentLastMonth;
    final percentageChange = totalDaysPresentLastMonth == 0
        ? 100
        : (difference / (totalDaysPresentLastMonth)) * 100;

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
                totalDaysPresent.toString(),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'days in ${currentDate.year}',
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
                children: [
                  ContainerDot(color: Color(0xFF2E7D32)),
                  SizedBox(width: 6),
                  Text(
                    '${percentageAttendance.ceil()}% Attendance',
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
                children: [
                  Icon(Icons.trending_up, size: 16, color: Colors.white),
                  SizedBox(width: 4),
                  Text(
                    '${(difference.sign == -1) ? '-' : '+'}${percentageChange.ceil()}% vs last month',
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
