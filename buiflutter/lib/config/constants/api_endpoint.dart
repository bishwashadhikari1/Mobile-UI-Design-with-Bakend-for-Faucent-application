class ApiEndpoints {
  ApiEndpoints._();

  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const String baseUrl = "http://172.20.112.1:3001/api/";

  // ====================== Auth Routes ======================
  static const String login = "users/login";
  static const String register = "users/register";
  static const String uploadDocs = "users/uploadDocs";
  static const String loginWithToken = "users/loginWithToken";
  static const String getAllEmployees = "users/employees";

  //====================== Wallet Routes ======================
  static const String getWalletById = "wallets/";
  static const String updateWalletBalance = "wallets/";

  //====================== Contract Routes ======================
  static const String createContract = "contracts/";
  static const String getContractById = "contracts/filter";
  static const String getAllContracts = "contracts/";
  static const String updateContract = "contracts/";
  static const String deleteContract = "contracts/";
  static const String endContract = "contracts/endContract";

  //====================== User Profile Routes ======================
  static const String getUser = "users/"; //:id
  static const String updateUser = "users/"; //:id
  static const String deleteUser = "users/"; //:id
  static const String uploadImage = "users/uploadImage"; //:id
}
