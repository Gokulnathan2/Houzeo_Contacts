import '../entities/contact.dart';
import '../repositories/contact_repository.dart';
import 'usecase.dart';

class UpdateContactUseCase implements UseCase<void, Contact> {
  final ContactRepository _repository;

  UpdateContactUseCase(this._repository);

  @override
  Future<void> call(Contact contact) async {
    await _repository.updateContact(contact);
  }
} 