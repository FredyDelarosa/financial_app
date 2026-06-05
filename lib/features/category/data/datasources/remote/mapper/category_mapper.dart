import '../../../../domain/entities/category.dart';
import '../model/category_dto.dart';

class CategoryMapper {
  static Category toEntity(CategoryDto dto) => Category(
        id: dto.id,
        usuarioId: dto.usuarioId,
        nombre: dto.nombre,
        icono: dto.icono,
        color: dto.color,
        tipo: dto.tipo,
        esSistema: dto.esSistema,
      );
}