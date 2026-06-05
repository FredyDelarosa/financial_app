import '../model/budget_dto.dart';
import '../../../../domain/entities/budget.dart';

class BudgetMapper {
  static Budget toEntity(BudgetDto dto) => dto.toEntity();
}