import 'package:get_it/get_it.dart';
import 'package:pokerapp/services/firebase/analytics_service.dart';

// This is our global ServiceLocator
GetIt locator = GetIt.instance;

void setupLocator() {
  //locator.registerLazySingleton(() => AnalyticsService());
}
