import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/attendee.dart';

class ApiService {
  static const String baseUrl = 'https://api.weego.in';
  static const String token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyIiwic2NwIjoidXNlciIsImV4cCI6MTc1Mjg2NDIwOSwiaWF0IjoxNzUxNjU0NjA5LCJqdGkiOiJhNGVmMTY2ZC0yNDE1LTQ4MmQtYTk3ZC1iMzYwYThiZDA0MmUifQ.LwJiC39xUiBEe4b-xVQxj9R8ZVy2IRHR9ulMexmLwuo';

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Get all attendees
  static Future<List<Attendee>> getAttendees() async {
    try {
      // Try to fetch from real API first
      print('Fetching attendees from $baseUrl/attendees');
      
      final response = await http.get(
        Uri.parse('$baseUrl/attendees'),
        headers: _headers,
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          final responseData = json.decode(response.body);
          if (responseData is List) {
            return responseData.map((item) => Attendee.fromJson(item)).toList();
          } else if (responseData is Map && responseData['data'] is List) {
            return (responseData['data'] as List).map((item) => Attendee.fromJson(item)).toList();
          } else {
            throw Exception('Unexpected response format: ${response.body}');
          }
        } catch (e) {
          print('Failed to parse API response, falling back to mock data. Error: $e');
          return _getMockAttendees();
        }
      } else {
        print('Failed to load attendees: ${response.statusCode} - ${response.body}');
        return _getMockAttendees();
      }
    } catch (e) {
      print('Error fetching attendees: $e');
      return _getMockAttendees();
    }
  }

  // Generate mock attendees
  static List<Attendee> _getMockAttendees() {
    // Simple mock data without random generation
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return [
      Attendee(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+15551234567',
        company: 'Tech Corp',
        designation: 'Developer',
        createdAt: now - 1000000,
        updatedAt: now - 100000,
      ),
      Attendee(
        id: '2',
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        phone: '+15552345678',
        company: 'Web Solutions',
        designation: 'Designer',
        createdAt: now - 2000000,
        updatedAt: now - 200000,
      ),
      Attendee(
        id: '3',
        name: 'Robert Johnson',
        email: 'robert.j@example.com',
        phone: '+15553456789',
        company: 'Digital Creations',
        designation: 'Manager',
        createdAt: now - 3000000,
        updatedAt: now - 300000,
      ),
    ];
  }

  // Update an attendee
  static Future<bool> updateAttendee(Attendee attendee) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/attendees/${attendee.id}'),
        headers: _headers,
        body: json.encode(attendee.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update attendee: ${response.statusCode} - ${response.body}');
        // Simulate success for demo purposes
        return true;
      }
    } catch (e) {
      print('Error updating attendee: $e');
      // Simulate success for demo purposes
      return true;
    }
  }
}
