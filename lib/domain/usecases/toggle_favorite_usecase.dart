import '../repositories/contact_repository.dart';
import 'usecase.dart';

class ToggleFavoriteUseCase implements UseCase<void, String> {
  final ContactRepository _repository;

  ToggleFavoriteUseCase(this._repository);

  @override
  Future<void> call(String id) async {
    await _repository.toggleFavorite(id);
  }
} 