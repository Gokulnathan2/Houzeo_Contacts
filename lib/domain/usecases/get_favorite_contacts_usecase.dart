import '../entities/contact.dart';
import '../repositories/contact_repository.dart';
import 'usecase.dart';

class GetFavoriteContactsUseCase implements UseCase<List<Contact>, NoParams> {
  final ContactRepository _repository;

  GetFavoriteContactsUseCase(this._repository);

  @override
  Future<List<Contact>> call(NoParams params) async {
    return await _repository.getFavoriteContacts();
  }
} 