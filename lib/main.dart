import 'dart:async';

import 'package:dartnative/dartnative.dart';

import 'dartnative_plugin_registrant.dart';

void main() {
  DartNativePluginRegistrant.registerAll();
  runApp(const SizedBoxChildRepro());
}

const _label = TextStyle(fontSize: 18, color: Color(0xff17252b));
const _tile = ColoredBox(
  color: Color(0xff087e8b),
  child: SizedBox(
    width: 80,
    height: 80,
    child: Center(
      child: Text('CHILD', style: TextStyle(color: Color(0xffffffff))),
    ),
  ),
);

/// No image, cache, CanvasSurface, Skia dependency, or application services.
class SizedBoxChildRepro extends StatefulWidget {
  const SizedBoxChildRepro({super.key});

  @override
  State<SizedBoxChildRepro> createState() => _SizedBoxChildReproState();
}

class _SizedBoxChildReproState extends State<SizedBoxChildRepro> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => _visible = true);
      dnLog('[sized-box-repro] visible=true; both rows should have a CHILD tile');
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final edge = _visible ? 80.0 : 0.0;
    return Scaffold(
      brightness: Brightness.light,
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(title: const Text('SizedBox child update')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Visible: $_visible', style: _label),
            const Text('Reveals automatically after 4 seconds.', style: _label),
            const SizedBox(height: 24),
            const Text('A: Initially childless SizedBox', style: _label),
            SizedBox(
              height: 100,
              child: LayoutBuilder(
                builder: (_, _) => SizedBox(
                  width: edge,
                  height: edge,
                  child: _visible ? _tile : null,
                ),
              ),
            ),
            const Text('B: Initially an empty Stack child', style: _label),
            SizedBox(
              height: 100,
              child: LayoutBuilder(
                builder: (_, _) => SizedBox(
                  width: edge,
                  height: edge,
                  child: Stack(children: [if (_visible) _tile]),
                ),
              ),
            ),
            const Text('Expected when visible: two teal CHILD tiles.', style: _label),
            const SizedBox(height: 20),
            Button(
              title: 'Toggle',
              onPressed: () {
                _timer?.cancel();
                setState(() => _visible = !_visible);
                dnLog('[sized-box-repro] visible=$_visible');
              },
            ),
          ],
        ),
      ),
    );
  }
}
