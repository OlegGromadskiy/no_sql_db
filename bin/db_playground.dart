import 'container.dart';
import 'data_base.dart';

void main() async {
  final db = await DataBase.init(showDebugPrints: true);

  final container = db.container<List<dynamic>>();
  await container.put([1000000, 'dddd', 1, 'ggg', false, 1488]);

  final lazy = container.getLazy();

  print(lazy[3]);
}

