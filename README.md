# Attendee Management Web Application

A Flutter-based web application for managing attendees with a clean, modern UI. The app allows viewing and editing attendee information through a RESTful API.

## Features

- View list of attendees with details
- Edit attendee information
- Responsive design that works on web and mobile
- Modern UI with smooth animations
- Error handling and loading states
- Mock data fallback when API is unavailable

## Screenshots

*Add screenshots here after running the app*

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (included with Flutter)
- Git

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/shaileshh15/weego.git
   cd weego
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Access**
   - Open `lib/services/api_service.dart`
   - Update the `token` constant with a valid Bearer token:
     ```dart
     static const String token = 'YOUR_VALID_BEARER_TOKEN';
     ```

4. **Run the application**
   ```bash
   flutter run -d chrome
   ```
   This will launch the app in Chrome in debug mode.

## Project Structure

```
lib/
├── main.dart          # Application entry point
├── models/           # Data models
│   └── attendee.dart
├── screens/          # App screens
│   ├── attendee_list_screen.dart
│   └── edit_attendee_screen.dart
├── services/         # Business logic and API calls
│   ├── api_service.dart
│   └── attendee_service.dart
└── widgets/          # Reusable UI components
    └── attendee_list_item.dart
```

## API Integration

The app communicates with a REST API with the following endpoints:

- `GET /attendees` - Fetch all attendees
- `PUT /attendees/:id` - Update an attendee

## Dependencies

- `http`: For making HTTP requests
- `provider`: For state management
- `flutter_easyloading`: For showing loading indicators and toast messages

## Troubleshooting

1. **API Authentication Failed**
   - Ensure the Bearer token in `api_service.dart` is valid
   - Check your internet connection

2. **Build Errors**
   - Run `flutter clean` and then `flutter pub get`
   - Ensure you're using the latest stable version of Flutter

## Contributing

Feel free to submit issues and enhancement requests. Pull requests are welcome!

## License

This project is open source and available under the MIT License.
