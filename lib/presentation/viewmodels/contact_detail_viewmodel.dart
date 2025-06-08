import 'package:flutter/foundation.dart';
import '../../domain/entities/contact.dart';
import '../../domain/usecases/get_contact_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/delete_contact_usecase.dart';

class ContactDetailViewModel extends ChangeNotifier {
  final GetContactUseCase _getContactUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;
  final DeleteContactUseCase _deleteContactUseCase;

  ContactDetailViewModel({
    required GetContactUseCase getContactUseCase,
    required ToggleFavoriteUseCase toggleFavoriteUseCase,
    required DeleteContactUseCase deleteContactUseCase,
  })  : _getContactUseCase = getContactUseCase,
        _toggleFavoriteUseCase = toggleFavoriteUseCase,
        _deleteContactUseCase = deleteContactUseCase;

  Contact? _contact;
  bool _isLoading = false;
  String? _errorMessage;

  Contact? get contact => _contact;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadContact(String contactId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _contact = await _getContactUseCase(contactId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _contact = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    if (_contact == null) return;

    try {
      await _toggleFavoriteUseCase(_contact!.id);
      _contact = _contact!.copyWith(isFavorite: !_contact!.isFavorite);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteContact() async {
    if (_contact == null) return;

    try {
      await _deleteContactUseCase(_contact!.id);
      _contact = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
} 