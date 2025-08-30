// api_service_provider.dart

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/ApiService.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
