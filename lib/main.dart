import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/preview_screen.dart';
import 'screens/loan_form_screen.dart';
import 'screens/pdf_tools_screen.dart';
import 'screens/recycle_bin_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/library_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: UniLoansApp()));
}

class UniLoansApp extends ConsumerWidget {
  const UniLoansApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    return MaterialApp(
      title: 'UniLoans',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D1E5C),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F3FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1E5C),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFD8E2F0)),
          ),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D1E5C),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0C1020),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF070D1F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF131D30),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF1C2A44)),
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/':            (context) => const HomeScreen(),
        '/camera':      (context) => const CameraScreen(),
        '/preview':     (context) => const PreviewScreen(),
        '/loan-form':   (context) => const LoanFormScreen(),
        '/pdf-tools':   (context) => const PdfToolsScreen(),
        '/recycle-bin': (context) => const RecycleBinScreen(),
        '/settings':    (context) => const SettingsScreen(),
        '/library':     (context) => const LibraryScreen(),
      },
    );
  }
}
