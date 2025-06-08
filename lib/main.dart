import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/di/service_locator.dart';
import 'app/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'presentation/viewmodels/contacts_viewmodel.dart';
import 'presentation/viewmodels/contact_detail_viewmodel.dart';
import 'presentation/viewmodels/add_edit_contact_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => serviceLocator<ContactsViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => serviceLocator<ContactDetailViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => serviceLocator<AddEditContactViewModel>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contacts',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}
