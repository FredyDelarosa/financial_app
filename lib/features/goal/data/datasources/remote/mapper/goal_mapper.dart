import '../model/goal_dto.dart';
import '../../../../domain/entities/goal.dart';

class GoalMapper {
  static Goal toEntity(GoalDto dto) => dto.toEntity();
}