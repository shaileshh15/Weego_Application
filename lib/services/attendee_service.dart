import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../models/attendee.dart';
import 'api_service.dart';

class AttendeeService extends ChangeNotifier {
  List<Attendee> _attendees = [];
  bool _isLoading = false;
  String? _error;

  List<Attendee> get attendees => _attendees;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all attendees
  Future<void> fetchAttendees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      developer.log('Fetching attendees...', name: 'AttendeeService');
      _attendees = await ApiService.getAttendees();
      developer.log('Successfully fetched ${_attendees.length} attendees', name: 'AttendeeService');
      _error = null;
    } catch (e, stackTrace) {
      _error = e.toString();
      developer.log('Error fetching attendees: $e', 
                   name: 'AttendeeService', 
                   error: e,
                   stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an attendee
  Future<bool> updateAttendee(Attendee updatedAttendee) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await ApiService.updateAttendee(updatedAttendee);
      if (success) {
        final index = _attendees.indexWhere((a) => a.id == updatedAttendee.id);
        if (index != -1) {
          _attendees[index] = updatedAttendee;
          _error = null;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
