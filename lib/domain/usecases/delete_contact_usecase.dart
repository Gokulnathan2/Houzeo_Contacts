import '../repositories/contact_repository.dart';
import 'usecase.dart';

class DeleteContactUseCase implements UseCase<void, String> {
  final ContactRepository _repository;

  DeleteContactUseCase(this._repository);

  @override
  Future<void> call(String id) async {
    await _repository.deleteContact(id);
  }
} 