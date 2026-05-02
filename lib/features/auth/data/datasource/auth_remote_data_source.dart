import '../../../../config/api/api_services.dart';
import '../../../../config/constants/app_constants.dart';
import '../models/user_model.dart';
import '../../../../config/local/local_storage_services.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiServices apiServices;

  AuthRemoteDataSourceImpl(this.apiServices);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiServices.postRequest(
      UrlConstants.login,
      body: {'email': email, 'password': password},
    );
    
    if (response != null) {
      final data = response['data'] ?? response;
     
      
      String? token = data['token'] ?? data['access_token'];
      if (token == null && response['authorisation'] != null) {
        token = response['authorisation']['token'];
      }
      
      if (token != null) {
        await LocalStorageServices.saveToken(token);
      }
      return UserModel.fromJson(data['user'] ?? data);
    } else {
      throw 'Login failed';
    }
  }
}
