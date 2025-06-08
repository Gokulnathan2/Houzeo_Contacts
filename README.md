# Houzeo Contacts

A modern, feature-rich contact management application built with Flutter. This app provides an intuitive interface for managing your contacts with a beautiful Material Design 3 UI.

## Features

- 📱 **Modern UI/UX**: Beautiful Material Design 3 interface with smooth animations and transitions
- 👥 **Contact Management**:
  - Add new contacts with detailed information
  - Edit existing contact details
  - Delete contacts
  - View contact details
  - Search contacts by name, phone, or email
- ⭐ **Favorites**: Mark contacts as favorites for quick access
- 📞 **Quick Actions**:
  - Direct phone calls
  - Send emails
- 🔄 **Real-time Updates**: Changes are reflected immediately across the app
- 💾 **Local Storage**: Contacts are stored locally using SQLite database
- 🎨 **Responsive Design**: Works seamlessly on different screen sizes
- 🌓 **Theme Support**: Adapts to system light/dark theme

## Installation

1. **Prerequisites**:
   - Flutter SDK (latest stable version)
   - Dart SDK (latest stable version)
   - Android Studio / VS Code with Flutter extensions
   - Git

2. **Clone the repository**:
   ```bash
   git clone https://github.com/Gokulnathan2/Houzeo_Contacts.git
   cd houzeo_contacts
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

## Usage

### Adding a Contact
1. Tap the "+" button on the home screen
2. Fill in the contact details:
   - First Name (required)
   - Last Name (required)
   - Phone Number (optional)
   - Email (optional)
3. Tap "Save" to create the contact

### Managing Contacts
- **View Contacts**: All contacts are listed on the main screen
- **Search**: Use the search bar to find contacts by name, phone, or email
- **Favorites**: 
  - Tap the star icon to mark/unmark a contact as favorite
  - Access favorite contacts from the "Favorites" tab
- **Edit Contact**: 
  - Open contact details
  - Tap the edit icon
  - Modify the information
  - Save changes
- **Delete Contact**:
  - Open contact details
  - Scroll to bottom
  - Tap "Delete Contact"
  - Confirm deletion

### Quick Actions
- **Call**: Tap the phone icon in contact details to initiate a call
- **Email**: Tap the email icon to compose an email

## Project Structure

```
lib/
├── core/
│   └── services/         # Database and other core services
├── data/
│   ├── models/          # Data models
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Business entities
│   ├── repositories/    # Repository interfaces
│   └── usecases/       # Business logic use cases
└── presentation/
    ├── views/          # UI screens
    ├── viewmodels/     # View models
    └── widgets/        # Reusable widgets
```

## Dependencies

- `flutter`: UI framework
- `provider`: State management
- `sqflite`: Local database
- `flutter_animate`: Animations
- `url_launcher`: Opening URLs (phone, email)
- `flutter_phone_direct_caller`: Direct phone calls
- `uuid`: Unique ID generation

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## Support

For support, please open an issue in the GitHub repository or contact the development team.
