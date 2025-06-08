import '../entities/contact.dart';
import '../repositories/contact_repository.dart';
import 'usecase.dart';

class GetContactUseCase implements UseCase<Contact, String> {
  final ContactRepository _repository;

  GetContactUseCase(this._repository);

  @override
  Future<Contact> call(String contactId) async {
    return await _repository.getContact(contactId);
  }
} 