import 'dart:io';

import 'package:app_varillas/features/counting/presentation/pages/camera_screen.dart';
import 'package:app_varillas/features/history/presentation/pages/history_screen.dart';
import 'package:app_varillas/features/reports/presentation/pages/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/counting/presentation/bloc/counting_bloc.dart';
import 'features/history/presentation/bloc/history_bloc.dart';
import 'features/reports/presentation/bloc/report_bloc.dart';
import 'core/database/database_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.photos,
    Permission.storage,
  ].request();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkPythonInstallation();
  
  // Deshabilitar Impeller para emuladores
  if (await isRunningOnEmulator()) {
    debugPrint('Deshabilitando Impeller para emulador');
    // Impeller se deshabilita automáticamente en debug
  }
  
  await dotenv.load(fileName: ".env");
  await DatabaseHelper.instance.initDatabase();
  runApp(const MyApp());
}
Future<void> checkPythonInstallation() async {
  try {
    final result = await Process.run('python', ['--version']);
    print('✅ Python disponible: ${result.stdout}');
  } catch (e) {
    print('⚠️ Python no encontrado. La detección automática no funcionará.');
    print('   Instala Python desde: https://www.python.org/downloads/');
  }
}
Future<bool> isRunningOnEmulator() async {
  // Detectar si está en emulador
  return false; // Simplificado
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => CountingBloc()),
        BlocProvider(create: (_) => HistoryBloc()),
        BlocProvider(create: (_) => ReportBloc()),
      ],
      child: MaterialApp(
        title: 'Promart Contador Varillas',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const MainScreen();
            }
            return  LoginPage();
          },
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const CameraScreen(),
    const HistoryScreen(),
    const ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Contar'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.picture_as_pdf), label: 'Reportes'),
        ],
      ),
    );
  }
}