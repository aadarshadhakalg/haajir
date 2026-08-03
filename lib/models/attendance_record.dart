import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.date,
    required this.livenessPassed,
    required this.photoMatchedScore,
    required this.status,
    required this.studentEmail,
    required this.studentName,
    required this.userId,
  });

  final String id;
  final DateTime date;
  final bool livenessPassed;
  final int photoMatchedScore;
  final bool status;
  final String studentEmail;
  final String studentName;
  final String userId;

  factory AttendanceRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? <String, dynamic>{};

    return AttendanceRecord(
      id: document.id,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime(1970),
      livenessPassed: data['livenessPassed'] as bool? ?? false,
      photoMatchedScore: (data['photoMatchedScore'] as num?)?.toInt() ?? 0,
      status: data['status'] as bool? ?? false,
      studentEmail: data['studentEmail'] as String? ?? '',
      studentName: data['studentName'] as String? ?? '',
      userId: data['userID'] as String? ?? '',
    );
  }
}
