import '../model/transaction_dto.dart';
import '../../../../domain/entities/transaction.dart';

class TransactionMapper {
  static Transaction toEntity(TransactionDto dto) => dto.toEntity();
}