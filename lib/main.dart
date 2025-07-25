import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiMode;
import 'package:flutter_fullscreen/flutter_fullscreen.dart'
	show FullScreen, FullScreenListener;

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

const fluidContainerSize = (width: 50.0, height: 100.0);
const fluidContainerRadius = Radius.elliptical(25.0, 12.5);

final fluidLayerWidth = fluidContainerSize.height * 1.5;

class FluidContainerShape extends StatelessWidget {
	const FluidContainerShape({super.key, this.onTap, this.child});

	final Widget? child;
	final Function()? onTap;

	@override
	Widget build(BuildContext context) {
		return Container(
			width: fluidContainerSize.width,
			height: fluidContainerSize.height,
			decoration: BoxDecoration(
				border: Border.all(color: Colors.blueGrey, width: 2),
				borderRadius: BorderRadius.only(
					bottomLeft: fluidContainerRadius,
					bottomRight: fluidContainerRadius,
				),
			),
			child: ClipRRect(
				borderRadius: BorderRadius.only(
					bottomLeft: fluidContainerRadius,
					bottomRight: fluidContainerRadius,
				),
				child: GestureDetector(
					onTap: onTap,
					// child: OverflowBox(
					// 	maxHeight: double.infinity,
					// 	maxWidth: double.infinity,
						child: child,
					// ),
				),
			),
		);
	}
}

// class FluidLayer extends StatelessWidget {
//	 const FluidLayer({super.key, required this.color});

//	 final Color color;

//	 @override
//	 Widget build(BuildContext context) {
//	 }
// }

class _BottleWidgetState extends State<BottleWidget>
	with SingleTickerProviderStateMixin {
	late final AnimationController _controller;
	late final Animation<double> _rotation;

	final rotateLimit = 3 * math.pi / 8;

	@override
	void initState() {
		super.initState();

		_controller = AnimationController(
			duration: const Duration(seconds: 4),
			vsync: this,
		)..repeat();

		_rotation = Tween<double>(
			begin: 0,
			end: rotateLimit,
		).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
	}

	@override
	Widget build(BuildContext context) {
		return AnimatedBuilder(
			animation: _rotation, 
			builder: (context, child) {
				return Transform.rotate(
					angle: _rotation.value,
					child: FluidContainerShape(
						child: LayoutBuilder(
							builder: (context, constraints) {
								return Stack(
									children: [
										Positioned(
											top: constraints.maxHeight / 2,
											left: -(constraints.maxWidth - fluidLayerWidth).abs() / 2,
											child: Transform.rotate(
												angle: -_rotation.value,
												alignment: Alignment.topCenter,
												child: Container(
													width: fluidLayerWidth,
													height: fluidContainerSize.width,
													color: Colors.red,
													child: Stack(
														children: [
															Positioned(
																// (1 - (_rotation.value / rotateLimit)) * 
															top: constraints.maxHeight / 4,
															left: -(constraints.maxWidth - fluidLayerWidth * 2).abs() / 2,
															// TODO: CHANGE PARENT ROTATION PIVOT BASED ON HIGHEST LAYER - SHOULD BE CENTERED ON THE LAYER BEING POURED
															// TODO: LOWER LAYERS NEED TO MOVE UP AS THE CONTAINER ROTATES SO THE LAYER ABOVE APPEARS TO SHRINK
															// child: Transform.rotate(
																// angle: -_rotation.value,
																// alignment: Alignment.topCenter,
																// origin: Offset(0, 3 * constraints.maxHeight / 4),
																child: Container(
																	width: fluidLayerWidth * 2,
																	height: fluidContainerSize.width,
																	color: Colors.amber,
																),
														// )
													),
														]
													)
												),
											)
										),
										
									],
								);
							},
						),
					),
				);
			}
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
//	 const RotatingRectangle({super.key});

//	 @override
//	 State<RotatingRectangle> createState() => _RotatingRectangleState();
// }

// class _RotatingRectangleState extends State<RotatingRectangle>
//		 with SingleTickerProviderStateMixin {
//	 late final AnimationController _controller;

//	 @override
//	 void initState() {
//		 super.initState();
//		 _controller = AnimationController(
//			 duration: const Duration(seconds: 4),
//			 vsync: this,
//		 )..repeat(); // Loop forever
//	 }

//	 @override
//	 void dispose() {
//		 _controller.dispose();
//		 super.dispose();
//	 }

//	 @override
//	 Widget build(BuildContext context) {
//		 return RotationTransition(
//			 turns: _controller,
//			 child: Container(
//				 width: 100,
//				 height: 50,
//				 color: Colors.deepPurpleAccent,
//			 ),
//		 );
//	 }
// }
