import 'package:firebase_core/firebase_core.dart';
import '../core/di/injection_container.dart' as di;
import '../shared/services/notification_service.dart';

class AppConfig {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    await NotificationService().initialize();
    await di.init();
  }
}