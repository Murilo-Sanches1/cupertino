import 'package:cupertino/model/app_state_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

// ! flutter pub add intl provider shrine_images
import 'app.dart';

void main() {
  return runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppStateModel>(
      create: (_) => AppStateModel()..loadProducts(),
      child: const CupertinoStoreApp(),
    );
  }
}
