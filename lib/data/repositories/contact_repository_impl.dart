import '../../domain/entities/contact.dart';
import '../../domain/repositories/contact_repository.dart';
import '../models/contact_model.dart';
import '../../core/services/database_service.dart';

class ContactRepositoryImpl implements ContactRepository {
  final DatabaseService _databaseService;

  ContactRepositoryImpl({required DatabaseService databaseService})
      : _databaseService = databaseService;

  @override
  Future<List<Contact>> getAllContacts() async {
    final contacts = await _databaseService.getAllContacts();
    return contacts;
  }

  @override
  Future<List<Contact>> getFavoriteContacts() async {
    final contacts = await _databaseService.getFavoriteContacts();
    return contacts;
  }

  @override
  Future<Contact?> getContactById(String id) async {
    return await _databaseService.getContactById(id);
  }

  @override
  Future<void> addContact(Contact contact) async {
    final contactModel = ContactModel.fromEntity(contact);
    await _databaseService.insertContact(contactModel);
  }

  @override
  Future<void> updateContact(Contact contact) async {
    final contactModel = ContactModel.fromEntity(contact);
    await _databaseService.updateContact(contactModel);
  }

  @override
  Future<void> deleteContact(String id) async {
    await _databaseService.deleteContact(id);
  }

  @override
  Future<void> toggleFavorite(String id) async {
    await _databaseService.toggleFavorite(id);
  }

  @override
  Future<Contact> getContact(String id) async {
    try {
      final db = await _databaseService.database;
      final maps = await db.query(
        'contacts',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) {
        throw Exception('Contact not found');
      }

      return ContactModel.fromJson(maps.first);
    } catch (e) {
      throw Exception('Failed to get contact: $e');
    }
  }

  @override
  Future<List<Contact>> getContacts() async {
    try {
      final db = await _databaseService.database;
      final maps = await db.query('contacts', orderBy: 'firstName ASC');
      return maps.map((map) => ContactModel.fromJson(map)).toList();
    } catch (e) {
      throw Exception('Failed to get contacts: $e');
    }
  }
} 