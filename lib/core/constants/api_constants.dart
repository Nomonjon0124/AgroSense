/// API sozlamalari va endpoint'lar uchun konstantlar
class ApiConstants {
  // Private constructor - instance yaratishni oldini olish
  ApiConstants._();

  // ================== BASE URLs ==================
  
  /// Production API URL
  static const String productionBaseUrl = 'https://api.agrosense.uz/v1';
  
  /// Development API URL
  static const String developmentBaseUrl = 'http://localhost:3000/api/v1';
  
  /// Staging API URL
  static const String stagingBaseUrl = 'https://staging-api.agrosense.uz/v1';

  // ================== TIMEOUTS ==================
  
  /// Ulanish timeout (sekundlarda)
  static const int connectTimeout = 30;
  
  /// Qabul qilish timeout (sekundlarda)
  static const int receiveTimeout = 30;
  
  /// Jo'natish timeout (sekundlarda)
  static const int sendTimeout = 30;

  // ================== AUTH ENDPOINTS ==================
  
  /// Login endpoint
  static const String login = '/auth/login';
  
  /// Register endpoint
  static const String register = '/auth/register';
  
  /// Logout endpoint
  static const String logout = '/auth/logout';
  
  /// Refresh token endpoint
  static const String refreshToken = '/auth/refresh-token';
  
  /// Parolni unutdim endpoint
  static const String forgotPassword = '/auth/forgot-password';
  
  /// Parolni tiklash endpoint
  static const String resetPassword = '/auth/reset-password';
  
  /// OTP yuborish endpoint
  static const String sendOtp = '/auth/send-otp';
  
  /// OTP tasdiqlash endpoint
  static const String verifyOtp = '/auth/verify-otp';

  // ================== USER ENDPOINTS ==================
  
  /// Joriy foydalanuvchi profili
  static const String profile = '/users/profile';
  
  /// Profilni yangilash
  static const String updateProfile = '/users/profile';
  
  /// Foydalanuvchilar ro'yxati (admin uchun)
  static const String users = '/users';
  
  /// Foydalanuvchi avatori yuklash
  static const String uploadAvatar = '/users/avatar';

  // ================== WEATHER ENDPOINTS ==================
  
  /// Joriy ob-havo ma'lumotlari
  static const String currentWeather = '/weather/current';
  
  /// Ob-havo prognozi
  static const String forecast = '/weather/forecast';
  
  /// Soatlik prognoz
  static const String hourlyForecast = '/weather/hourly';
  
  /// Kunlik prognoz
  static const String dailyForecast = '/weather/daily';
  
  /// Tarixiy ob-havo ma'lumotlari
  static const String historicalWeather = '/weather/historical';
  
  /// Ob-havo alertlari
  static const String weatherAlerts = '/weather/alerts';

  // ================== FIELD ENDPOINTS ==================
  
  /// Dalalar ro'yxati
  static const String fields = '/fields';
  
  /// Dala yaratish
  static const String createField = '/fields';
  
  /// Bitta dalani olish
  static String field(String id) => '/fields/$id';
  
  /// Dalani yangilash
  static String updateField(String id) => '/fields/$id';
  
  /// Dalani o'chirish
  static String deleteField(String id) => '/fields/$id';
  
  /// Dala ob-havo ma'lumotlari
  static String fieldWeather(String fieldId) => '/fields/$fieldId/weather';
  
  /// Dala statistikasi
  static String fieldStats(String fieldId) => '/fields/$fieldId/stats';

  // ================== ALERT ENDPOINTS ==================
  
  /// Barcha ogohlantirishlar
  static const String alerts = '/alerts';
  
  /// Aktiv ogohlantirishlar
  static const String activeAlerts = '/alerts/active';
  
  /// Ogohlantirish sozlamalari
  static const String alertSettings = '/alerts/settings';
  
  /// Ogohlantirishni o'qilgan deb belgilash
  static String markAlertRead(String id) => '/alerts/$id/read';

  // ================== SYNC ENDPOINTS ==================
  
  /// Sinxronizatsiya holati
  static const String syncStatus = '/sync/status';
  
  /// O'zgarishlarni yuborish
  static const String pushChanges = '/sync/push';
  
  /// O'zgarishlarni olish
  static const String pullChanges = '/sync/pull';
  
  /// Oxirgi sinxronizatsiya vaqti
  static const String lastSync = '/sync/last';

  // ================== MAP ENDPOINTS ==================
  
  /// OpenStreetMap tile URL
  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  
  /// Google Maps tile URL (agar kerak bo'lsa)
  static const String googleTileUrl = 
      'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}';
  
  /// Satellite tile URL
  static const String satelliteTileUrl = 
      'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}';

  // ================== SETTINGS ENDPOINTS ==================
  
  /// Ilova sozlamalari
  static const String appSettings = '/settings/app';
  
  /// Bildirishnoma sozlamalari
  static const String notificationSettings = '/settings/notifications';
  
  /// Til sozlamalari
  static const String languageSettings = '/settings/language';

  // ================== HEADERS ==================
  
  /// Default content type
  static const String contentTypeJson = 'application/json';
  
  /// Multipart content type
  static const String contentTypeMultipart = 'multipart/form-data';
  
  /// Authorization header nomi
  static const String authorizationHeader = 'Authorization';
  
  /// Bearer token prefiksi
  static const String bearerPrefix = 'Bearer ';
  
  /// Accept-Language header
  static const String acceptLanguageHeader = 'Accept-Language';
  
  /// X-App-Version header
  static const String appVersionHeader = 'X-App-Version';
  
  /// X-Platform header
  static const String platformHeader = 'X-Platform';

  // ================== RESPONSE KEYS ==================
  
  /// Muvaffaqiyat holat
  static const String statusSuccess = 'success';
  
  /// Xatolik holat
  static const String statusError = 'error';
  
  /// Ma'lumotlar kaliti
  static const String dataKey = 'data';
  
  /// Xabar kaliti
  static const String messageKey = 'message';
  
  /// Xatolik kaliti
  static const String errorKey = 'error';
  
  /// Pagination meta kaliti
  static const String metaKey = 'meta';
  
  /// Jami elementlar soni
  static const String totalKey = 'total';
  
  /// Sahifa kaliti
  static const String pageKey = 'page';
  
  /// Limit kaliti
  static const String limitKey = 'limit';
}

/// API muhitlari (environments)
enum ApiEnvironment {
  development,
  staging,
  production,
}

extension ApiEnvironmentExtension on ApiEnvironment {
  String get baseUrl {
    switch (this) {
      case ApiEnvironment.development:
        return ApiConstants.developmentBaseUrl;
      case ApiEnvironment.staging:
        return ApiConstants.stagingBaseUrl;
      case ApiEnvironment.production:
        return ApiConstants.productionBaseUrl;
    }
  }
  
  String get name {
    switch (this) {
      case ApiEnvironment.development:
        return 'Development';
      case ApiEnvironment.staging:
        return 'Staging';
      case ApiEnvironment.production:
        return 'Production';
    }
  }
}
