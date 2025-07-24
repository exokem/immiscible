import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiMode;
import 'package:flutter_fullscreen/flutter_fullscreen.dart'
    show FullScreen, FullScreenListener, isFullScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FullScreen.ensureInitialized();
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  final String title = 'Immiscible';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),
        home: App(title: title),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key, required this.title});

  final String title;

  @override
  State<App> createState() => _AppState();
}

class BottleWidget extends StatefulWidget {
  const BottleWidget({super.key});

  @override
  State<BottleWidget> createState() => _BottleWidgetState();
}

class _BottleWidgetState extends State<BottleWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey, width: 2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(25.0, 12.5),
          bottomRight: Radius.elliptical(25.0, 12.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(25.0, 12.5),
          bottomRight: Radius.elliptical(25.0, 12.5),
        ),
        child: OverflowBox(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
          child: UnconstrainedBox(
            child: RotationTransition(
              turns: _controller,
              child: Container(width: 200, height: 40, color: Colors.amber),
            ),
          )
        ),
      ),
    );
  }
}

class _AppState extends State<App> with FullScreenListener {
  bool isFullscreen = FullScreen.isFullScreen;

  @override
  void initState() {
    FullScreen.addListener(this);
    super.initState();
  }

  @override
  dispose() {
    FullScreen.removeListener(this);
    super.dispose();
  }

  @override
  void onFullScreenChanged(bool enabled, SystemUiMode? systemUiMode) {
    setState(() {
      isFullscreen = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[BottleWidget()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FullScreen.setFullScreen(!isFullscreen);
        },
        tooltip: isFullscreen ? 'Exit Fullscreen' : 'Fullscreen',
        child: Icon(
          isFullscreen
              ? Icons.fullscreen_exit_rounded
              : Icons.fullscreen_rounded,
        ),
      ),
    );
  }
}

// class RotatingRectangle extends StatefulWidget {
//   const RotatingRectangle({super.key});

//   @override
//   State<RotatingRectangle> createState() => _RotatingRectangleState();
// }

// class _RotatingRectangleState extends State<RotatingRectangle>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 4),
//       vsync: this,
//     )..repeat(); // Loop forever
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RotationTransition(
//       turns: _controller,
//       child: Container(
//         width: 100,
//         height: 50,
//         color: Colors.deepPurpleAccent,
//       ),
//     );
//   }
// }
