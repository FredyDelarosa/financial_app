import '../../../../domain/entities/user.dart';
import '../model/user_dto.dart';

class UserMapper {
  static User toEntity(UserDto dto) => User(
    id: dto.id,
    nombre: dto.nombre,
    email: dto.email,
    monedaPreferida: dto.monedaPreferida,
    createdAt: DateTime.parse(dto.createdAt),
  );
}