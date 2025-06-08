import '../entities/contact.dart';
import '../repositories/contact_repository.dart';
import 'usecase.dart';

class AddContactUseCase implements UseCase<void, Contact> {
  final ContactRepository _repository;

  AddContactUseCase(this._repository);

  @override
  Future<void> call(Contact contact) async {
    await _repository.addContact(contact);
  }
} 