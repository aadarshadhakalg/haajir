import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
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
      Position currentPostion = await _determinePosition();
      double collegeLat = 27.7045121;
      double collegeLong = 85.3324544;

      double distanceFromCollege = Geolocator.distanceBetween(
        collegeLat,
        collegeLong,
        currentPostion.latitude,
        currentPostion.longitude,
      );

      print(distanceFromCollege);

      if (distanceFromCollege > 100) {
        emit(
          AttendanceError(
            "You're not in the college premises",
            previousRecords: _records,
          ),
        );
      } else {
        await _repository.logToday(livenessPassed: true, photoMatchedScore: 97);
        emit(AttendanceLoaded(_records));
      }
    } on FirebaseException catch (error) {
      if (error.code == 'permission-denied') {
        emit(
          AttendanceError(
            'Attendance Already Logged For Today',
            previousRecords: _records,
          ),
        );
      } else {
        emit(AttendanceError(error.toString(), previousRecords: _records));
      }
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
