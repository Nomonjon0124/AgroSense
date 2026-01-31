import 'package:equatable/equatable.dart';
import '../either_dart/either.dart';
import '../error/faliures.dart';

/// Barcha use case'lar uchun asosiy abstrakt sinf
///
/// Type: Return type (qaytariladigan tip)
/// Params: Parameters (parametrlar)
abstract class UseCase<Type, Params> {
  /// Use case'ni bajarish
  Future<Either<Failure, Type>> call(Params params);
}

/// Parametrsiz use case'lar uchun
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Sync (Sinxron) use case'lar uchun
abstract class SyncUseCase<Type, Params> {
  /// Sinxron use case'ni bajarish
  Either<Failure, Type> call(Params params);
}

/// Stream qaytaruvchi use case'lar uchun
abstract class StreamUseCase<Type, Params> {
  /// Stream qaytaruvchi use case'ni bajarish
  Stream<Either<Failure, Type>> call(Params params);
}

/// Pagination uchun parametrlar
class PaginationParams extends Equatable {
  final int page;
  final int limit;
  final String? searchQuery;
  final Map<String, dynamic>? filters;

  const PaginationParams({
    required this.page,
    required this.limit,
    this.searchQuery,
    this.filters,
  });

  @override
  List<Object?> get props => [page, limit, searchQuery, filters];

  PaginationParams copyWith({
    int? page,
    int? limit,
    String? searchQuery,
    Map<String, dynamic>? filters,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
    );
  }
}

/// ID bo'yicha olish uchun parametr
class IdParams extends Equatable {
  final String id;

  const IdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Multiple ID'lar uchun parametr
class IdsParams extends Equatable {
  final List<String> ids;

  const IdsParams({required this.ids});

  @override
  List<Object?> get props => [ids];
}

/// Date range uchun parametr
class DateRangeParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Query parametr
class QueryParams extends Equatable {
  final String query;
  final int? limit;
  final Map<String, dynamic>? filters;

  const QueryParams({
    required this.query,
    this.limit,
    this.filters,
  });

  @override
  List<Object?> get props => [query, limit, filters];
}