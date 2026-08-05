import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haajir/models/attendance_record.dart';
import 'package:haajir/repositories/attendance_repository.dart';

// The screen can only be loading, loaded, or in an error state.
sealed class AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  AttendanceLoaded(this.records, {this.isSaving = false});

  final List<AttendanceRecord> records;
  final bool isSaving;
}

class AttendanceError extends AttendanceState {
  AttendanceError(this.message, {this.previousRecords = const []});

  final String message;
  final List<AttendanceRecord> previousRecords;
}

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit({required AttendanceRepository repository})
    : _repository = repository,
      super(AttendanceLoading());

  final AttendanceRepository _repository;
  StreamSubscription<List<AttendanceRecord>>? _subscription;
  List<AttendanceRecord> _records = const [];
  bool _isSaving = false;

  void loadAttendance() {
    emit(AttendanceLoading());

    _subscription = _repository.watchCurrentStudentAttendance().listen(
      (records) {
        _records = records;
        emit(AttendanceLoaded(records, isSaving: _isSaving));
      },
      onError: (Object error) {
        emit(AttendanceError(error.toString(), previousRecords: _records));
      },
    );
  }

  Future<void> logAttendance() async {
    if (_isSaving) return;

    _isSaving = true;
    emit(AttendanceLoaded(_records, isSaving: true));

    try {
      // These are temporary values for the Firestore lesson.
      await _repository.logToday(livenessPassed: true, photoMatchedScore: 97);
      emit(AttendanceLoaded(_records));
    } catch (error) {
      emit(AttendanceError(error.toString(), previousRecords: _records));
    } finally {
      _isSaving = false;
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
