import '../bin/data_base.dart';
import 'package:test/test.dart';

Future<void> main() async {
  late DataBase db;

  setUpAll(() async {
    db = await DataBase.init();
  });

  test('bool test', () async {
    final container = db.container<bool>();

    await container.put(false);
    expect(await container.get(), false);

    await container.put(true);
    expect(await container.get(), true);
  });

  test('int test', () async {
    final container = db.container<int>();

    await container.put(10);
    expect(await container.get(), 10);

    await container.put(1000);
    expect(await container.get(), 1000);

    await container.put(1000000);
    expect(await container.get(), 1000000);

    await container.put(1000000000);
    expect(await container.get(), 1000000000);

    await container.put(1000000000000);
    expect(await container.get(), 1000000000000);

    await container.put(-10);
    expect(await container.get(), -10);

    await container.put(-1000);
    expect(await container.get(), -1000);

    await container.put(-1000000);
    expect(await container.get(), -1000000);

    await container.put(-1000000000);
    expect(await container.get(), -1000000000);

    await container.put(-1000000000000);
    expect(await container.get(), -1000000000000);
  });

  test('list test', () async {
    final container = db.container<List<dynamic>>();
    await container.put([1000000, 'dddd', 1, 'ggg', false]);

    final list = await container.get();

    expect(list[0], 1000000);
    expect(list[1], 'dddd');
    expect(list[2], 1);
    expect(list[3], 'ggg');
    expect(list[4], false);
  });
}
