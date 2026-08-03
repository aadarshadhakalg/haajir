import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haajir/models/attendance_record.dart';

class AttendanceRepository {
  AttendanceRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CollectionReference<Map<String, dynamic>> get _attendanceCollection =>
      _firestore.collection('attendance');

  Stream<List<AttendanceRecord>> watchCurrentStudentAttendance() {
    final user = _requireUser();

    return _attendanceCollection
        .where('userID', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          final records = snapshot.docs
              .map(AttendanceRecord.fromFirestore)
              .toList();

          // Sorting in the app avoids requiring a composite Firestore index
          // for userID + date during the classroom exercise.
          records.sort((a, b) => b.date.compareTo(a.date));
          return records;
        });
  }

  Future<void> logToday({
    required bool livenessPassed,
    required int photoMatchedScore,
  }) async {
    final user = _requireUser();
    final now = DateTime.now();
    final attendanceDate = DateTime(now.year, now.month, now.day);
    final documentId = '${user.uid}_${_dayId(attendanceDate)}';

    // A deterministic document ID makes the operation idempotent: one user
    // can have only one attendance document for a given calendar day.
    await _attendanceCollection.doc(documentId).set({
      'date': Timestamp.fromDate(attendanceDate),
      'livenessPassed': livenessPassed,
      'photoMatchedScore': photoMatchedScore,
      'status': livenessPassed && photoMatchedScore >= 80,
      'studentEmail': user.email ?? '',
      'studentName': user.displayName ?? '',
      'userID': user.uid,
    });
  }

  User _requireUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw StateError('A signed-in user is required.');
    }
    return user;
  }

  String _dayId(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
