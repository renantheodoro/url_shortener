# URL Shortener Flutter App

This is a Flutter app project for URL shortening, initially created as part of a test for Nubank. However, the project was adapted to create a URL shortening service, allowing users to shorten links directly within the app.

## Technologies and Architecture

- **Flutter**: Framework used to build the mobile application.
- **Dart**: Programming language used for the app.
- **Clean Architecture**: Development structure to keep the app scalable and maintainable.
- **Provider**: State management used to manage data and state within the app.
- **Testing**: The project includes tests to ensure code reliability and functionality.

## Features

- Shorten URLs using an API.
- User-friendly interface to interact with and view shortened URLs.
- Support for copying the shortened link to the clipboard.

## Folder Structure

- **lib**: Contains the main files for the app.
- **test**: Contains unit and widget tests to ensure code quality.

## Dependencies

- **Provider**: For state management.
- **http**: For making HTTP requests to the URL shortening API.

## References

The API that this app uses is available in this repository: [url-shortener-api](https://github.com/renantheodoro/url-shortener-api).

## How to Run the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/renantheodoro/url_shortener.git
   ```
   
## Install the dependencies:

```bash
flutter pub get
```

## Run the app:

```bash
flutter run
```

Open the app on your device or emulator to test the URL shortening service.


# Author

Renan Theodoro. To know more: https://renantheodoro.dev/
