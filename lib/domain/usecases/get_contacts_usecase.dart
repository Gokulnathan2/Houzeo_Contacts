import '../entities/contact.dart';
import '../repositories/contact_repository.dart';
import 'usecase.dart';

class GetContactsUseCase implements UseCase<List<Contact>, NoParams> {
  final ContactRepository _repository;

  GetContactsUseCase(this._repository);

  @override
  Future<List<Contact>> call(NoParams params) async {
    return await _repository.getAllContacts();
  }
} 