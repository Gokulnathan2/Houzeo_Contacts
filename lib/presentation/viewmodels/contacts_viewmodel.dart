import 'package:flutter/foundation.dart';
import '../../domain/entities/contact.dart';
import '../../domain/usecases/get_contacts_usecase.dart';
import '../../domain/usecases/get_favorite_contacts_usecase.dart';
import '../../domain/usecases/delete_contact_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/usecase.dart';

class ContactsViewModel extends ChangeNotifier {
  final GetContactsUseCase _getContactsUseCase;
  final GetFavoriteContactsUseCase _getFavoriteContactsUseCase;
  final DeleteContactUseCase _deleteContactUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  ContactsViewModel({
    required GetContactsUseCase getContactsUseCase,
    required GetFavoriteContactsUseCase getFavoriteContactsUseCase,
    required DeleteContactUseCase deleteContactUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
  })  : _getContactsUseCase = getContactsUseCase,
        _getFavoriteContactsUseCase = getFavoriteContactsUseCase,
        _deleteContactUseCase = deleteContactUseCase,
        _toggleFavoriteUseCase = toggleFavoriteUseCase;

  List<Contact> _contacts = [];
  List<Contact> _favoriteContacts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<Contact> get contacts => _searchQuery.isEmpty
      ? _contacts
      : _contacts.where((contact) =>
          contact.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (contact.phoneNumber?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (contact.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)).toList();

  List<Contact> get favoriteContacts => _favoriteContacts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> loadContacts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _contacts = await _getContactsUseCase(const NoParams());
      _favoriteContacts = await _getFavoriteContactsUseCase(const NoParams());
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      await _deleteContactUseCase(id);
      await loadContacts();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String id) async {
    try {
      await _toggleFavoriteUseCase(id);
      await loadContacts();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
} 