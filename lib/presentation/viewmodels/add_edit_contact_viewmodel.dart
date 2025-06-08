import 'package:flutter/foundation.dart';
import '../../domain/entities/contact.dart';
import '../../domain/usecases/add_contact_usecase.dart';
import '../../domain/usecases/update_contact_usecase.dart';
import '../../domain/usecases/get_contact_usecase.dart';

class AddEditContactViewModel extends ChangeNotifier {
  final AddContactUseCase _addContactUseCase;
  final UpdateContactUseCase _updateContactUseCase;
  final GetContactUseCase _getContactUseCase;

  AddEditContactViewModel({
    required AddContactUseCase addContactUseCase,
    required UpdateContactUseCase updateContactUseCase,
    required GetContactUseCase getContactUseCase,
  })  : _addContactUseCase = addContactUseCase,
        _updateContactUseCase = updateContactUseCase,
        _getContactUseCase = getContactUseCase;

  Contact? _contact;
  bool _isLoading = false;
  String? _errorMessage;
  String _firstName = '';
  String _lastName = '';
  String? _phoneNumber;
  String? _email;
  String? _profileImage;

  Contact? get contact => _contact;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String? get phoneNumber => _phoneNumber;
  String? get email => _email;
  String? get profileImage => _profileImage;

  void setContact(Contact contact) {
    _contact = contact;
    _firstName = contact.firstName;
    _lastName = contact.lastName;
    _phoneNumber = contact.phoneNumber;
    _email = contact.email;
    _profileImage = contact.profileImage;
    notifyListeners();
  }

  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setPhoneNumber(String? value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setEmail(String? value) {
    _email = value;
    notifyListeners();
  }

  void setProfileImage(String? value) {
    _profileImage = value;
    notifyListeners();
  }

  bool get isValid => _firstName.isNotEmpty && _lastName.isNotEmpty;

  Future<bool> saveContact() async {
    if (!isValid) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final contact = Contact(
        id: _contact?.id,
        firstName: _firstName,
        lastName: _lastName,
        phoneNumber: _phoneNumber,
        email: _email,
        profileImage: _profileImage,
        isFavorite: _contact?.isFavorite ?? false,
        createdAt: _contact?.createdAt ?? now,
        updatedAt: now,
      );

      if (_contact == null) {
        await _addContactUseCase(contact);
      } else {
        await _updateContactUseCase(contact);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadContact(String contactId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final contact = await _getContactUseCase(contactId);
      setContact(contact);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 