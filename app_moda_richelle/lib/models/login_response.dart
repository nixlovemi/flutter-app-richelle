import '../models/api_wrapper.dart';
import '../models/login_body.dart';

// Login response is now an ApiWrapper<LoginBody>
typedef LoginResponse = ApiWrapper<LoginBody>;