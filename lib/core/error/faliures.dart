import 'package:equatable/equatable.dart';

/// Barcha xatolar uchun asosiy abstrakt sinf
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// Server xatoliklari
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });

  factory ServerFailure.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const ServerFailure(
          message: 'Noto\'g\'ri so\'rov',
          statusCode: 400,
        );
      case 401:
        return const ServerFailure(
          message: 'Autentifikatsiya talab qilinadi',
          statusCode: 401,
        );
      case 403:
        return const ServerFailure(
          message: 'Ruxsat yo\'q',
          statusCode: 403,
        );
      case 404:
        return const ServerFailure(
          message: 'Ma\'lumot topilmadi',
          statusCode: 404,
        );
      case 500:
        return const ServerFailure(
          message: 'Server xatosi',
          statusCode: 500,
        );
      case 503:
        return const ServerFailure(
          message: 'Server vaqtincha ishlamayapti',
          statusCode: 503,
        );
      default:
        return ServerFailure(
          message: 'Server xatosi: $statusCode',
          statusCode: statusCode,
        );
    }
  }
}

/// Kesh xatoliklari
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
  });

  factory CacheFailure.notFound([String? message]) {
    return CacheFailure(
      message: message ?? 'Keshda ma\'lumot topilmadi',
    );
  }

  factory CacheFailure.writeError() {
    return const CacheFailure(
      message: 'Keshga yozishda xatolik',
    );
  }

  factory CacheFailure.readError() {
    return const CacheFailure(
      message: 'Keshdan o\'qishda xatolik',
    );
  }
}

/// Ma'lumotlar bazasi xatoliklari
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
  });

  factory DatabaseFailure.notFound() {
    return const DatabaseFailure(
      message: 'Ma\'lumotlar bazasida topilmadi',
    );
  }

  factory DatabaseFailure.insertError() {
    return const DatabaseFailure(
      message: 'Ma\'lumotni qo\'shishda xatolik',
    );
  }

  factory DatabaseFailure.updateError() {
    return const DatabaseFailure(
      message: 'Ma\'lumotni yangilashda xatolik',
    );
  }

  factory DatabaseFailure.deleteError() {
    return const DatabaseFailure(
      message: 'Ma\'lumotni o\'chirishda xatolik',
    );
  }

  factory DatabaseFailure.queryError() {
    return const DatabaseFailure(
      message: 'So\'rov bajarilishida xatolik',
    );
  }
}

/// Network (Tarmoq) xatoliklari
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
  });

  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      message: 'Internet aloqasi yo\'q',
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'So\'rov vaqti tugadi',
    );
  }

  factory NetworkFailure.connectionError() {
    return const NetworkFailure(
      message: 'Ulanishda xatolik',
    );
  }
}

/// Validatsiya xatoliklari
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
  });

  factory ValidationFailure.emptyField(String fieldName) {
    return ValidationFailure(
      message: '$fieldName bo\'sh bo\'lmasligi kerak',
    );
  }

  factory ValidationFailure.invalidEmail() {
    return const ValidationFailure(
      message: 'Email manzil noto\'g\'ri',
    );
  }

  factory ValidationFailure.invalidPhone() {
    return const ValidationFailure(
      message: 'Telefon raqam noto\'g\'ri',
    );
  }

  factory ValidationFailure.passwordTooShort({int minLength = 6}) {
    return ValidationFailure(
      message: 'Parol kamida $minLength belgidan iborat bo\'lishi kerak',
    );
  }

  factory ValidationFailure.passwordsNotMatch() {
    return const ValidationFailure(
      message: 'Parollar mos kelmadi',
    );
  }
}

/// Autentifikatsiya xatoliklari
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.statusCode,
  });

  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      message: 'Login yoki parol noto\'g\'ri',
      statusCode: 401,
    );
  }

  factory AuthFailure.userNotFound() {
    return const AuthFailure(
      message: 'Foydalanuvchi topilmadi',
      statusCode: 404,
    );
  }

  factory AuthFailure.emailAlreadyExists() {
    return const AuthFailure(
      message: 'Bu email allaqachon ro\'yxatdan o\'tgan',
      statusCode: 409,
    );
  }

  factory AuthFailure.tokenExpired() {
    return const AuthFailure(
      message: 'Sessiya vaqti tugadi',
      statusCode: 401,
    );
  }

  factory AuthFailure.unauthorized() {
    return const AuthFailure(
      message: 'Tizimga kirishingiz kerak',
      statusCode: 401,
    );
  }
}

/// Ruxsat (Permission) xatoliklari
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
  });

  factory PermissionFailure.denied(String permission) {
    return PermissionFailure(
      message: '$permission ruxsati rad etildi',
    );
  }

  factory PermissionFailure.permanentlyDenied(String permission) {
    return PermissionFailure(
      message: '$permission ruxsati doimiy ravishda rad etildi. Sozlamalarga o\'ting.',
    );
  }

  factory PermissionFailure.locationDenied() {
    return const PermissionFailure(
      message: 'Geolokatsiya ruxsati rad etildi',
    );
  }

  factory PermissionFailure.cameraDenied() {
    return const PermissionFailure(
      message: 'Kamera ruxsati rad etildi',
    );
  }

  factory PermissionFailure.storageDenied() {
    return const PermissionFailure(
      message: 'Xotira ruxsati rad etildi',
    );
  }
}

/// Sinxronizatsiya xatoliklari
class SyncFailure extends Failure {
  const SyncFailure({
    required super.message,
  });

  factory SyncFailure.conflictDetected() {
    return const SyncFailure(
      message: 'Ma\'lumotlarda to\'qnashuv aniqlandi',
    );
  }

  factory SyncFailure.syncInProgress() {
    return const SyncFailure(
      message: 'Sinxronizatsiya jarayonida',
    );
  }

  factory SyncFailure.dataCorrupted() {
    return const SyncFailure(
      message: 'Ma\'lumotlar buzilgan',
    );
  }
}

/// File (Fayl) xatoliklari
class FileFailure extends Failure {
  const FileFailure({
    required super.message,
  });

  factory FileFailure.notFound() {
    return const FileFailure(
      message: 'Fayl topilmadi',
    );
  }

  factory FileFailure.readError() {
    return const FileFailure(
      message: 'Faylni o\'qishda xatolik',
    );
  }

  factory FileFailure.writeError() {
    return const FileFailure(
      message: 'Faylga yozishda xatolik',
    );
  }

  factory FileFailure.deleteError() {
    return const FileFailure(
      message: 'Faylni o\'chirishda xatolik',
    );
  }

  factory FileFailure.formatNotSupported() {
    return const FileFailure(
      message: 'Fayl formati qo\'llab-quvvatlanmaydi',
    );
  }

  factory FileFailure.tooLarge({required int maxSizeMB}) {
    return FileFailure(
      message: 'Fayl hajmi $maxSizeMB MB dan oshmasligi kerak',
    );
  }
}

/// Unknown (Noma'lum) xatoliklar
class UnknownFailure extends Failure {
  const UnknownFailure({
    String? message,
  }) : super(message: message ?? 'Noma\'lum xatolik yuz berdi');
}

/// Parse (Parsing) xatoliklari
class ParseFailure extends Failure {
  const ParseFailure({
    required super.message,
  });

  factory ParseFailure.jsonError() {
    return const ParseFailure(
      message: 'JSON ni parse qilishda xatolik',
    );
  }

  factory ParseFailure.invalidData() {
    return const ParseFailure(
      message: 'Ma\'lumot formati noto\'g\'ri',
    );
  }
}