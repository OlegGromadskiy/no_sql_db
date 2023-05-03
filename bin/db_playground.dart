import 'container.dart';
import 'data_base.dart';

void main() async {
  final db = await DataBase.init();

  final container = db.container<List<dynamic>>();
  await container.put([1000000, 'dddd', 1, 'ggg', false]);

  final list = await container.get();

  print(list);
}

