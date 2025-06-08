import 'package:get_it/get_it.dart';
import '../../core/services/database_service.dart';
import '../../data/repositories/contact_repository_impl.dart';
import '../../domain/repositories/contact_repository.dart';
import '../../domain/usecases/get_contacts_usecase.dart';
import '../../domain/usecases/get_favorite_contacts_usecase.dart';
import '../../domain/usecases/add_contact_usecase.dart';
import '../../domain/usecases/update_contact_usecase.dart';
import '../../domain/usecases/delete_contact_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/get_contact_usecase.dart';
import '../../presentation/viewmodels/contacts_viewmodel.dart';
import '../../presentation/viewmodels/contact_detail_viewmodel.dart';
import '../../presentation/viewmodels/add_edit_contact_viewmodel.dart';

final serviceLocator = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services
  serviceLocator.registerLazySingleton<DatabaseService>(
    () => DatabaseService(),
  );

  // Repositories
  serviceLocator.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(databaseService: serviceLocator()),
  );

  // Use cases
  serviceLocator.registerLazySingleton(
    () => GetContactUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetContactsUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetFavoriteContactsUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AddContactUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateContactUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteContactUseCase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ToggleFavoriteUseCase(serviceLocator()),
  );

  // ViewModels
  serviceLocator.registerFactory(
    () => ContactsViewModel(
      getContactsUseCase: serviceLocator(),
      getFavoriteContactsUseCase: serviceLocator(),
      deleteContactUseCase: serviceLocator(),
      toggleFavoriteUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => ContactDetailViewModel(
      getContactUseCase: serviceLocator(),
      toggleFavoriteUseCase: serviceLocator(),
      deleteContactUseCase: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => AddEditContactViewModel(
      addContactUseCase: serviceLocator(),
      updateContactUseCase: serviceLocator(),
      getContactUseCase: serviceLocator(),
    ),
  );
} 