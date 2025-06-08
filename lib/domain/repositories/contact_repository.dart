import '../entities/contact.dart';

abstract class ContactRepository {
  Future<List<Contact>> getAllContacts();
  Future<List<Contact>> getFavoriteContacts();
  Future<Contact?> getContactById(String id);
  Future<void> addContact(Contact contact);
  Future<void> updateContact(Contact contact);
  Future<void> deleteContact(String id);
  Future<void> toggleFavorite(String id);
  Future<List<Contact>> getContacts();
  Future<Contact> getContact(String id);
} 