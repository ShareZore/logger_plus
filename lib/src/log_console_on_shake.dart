part of logger_plus;

class LogConsoleOnShake extends StatefulWidget {
  final Widget child;
  final bool dark;
  final bool debugMode;

  const LogConsoleOnShake({
    Key? key,
    required this.child,
    required this.dark,
    this.debugMode = true,
  }) : super(key: key);

  @override
  _LogConsoleOnShakeState createState() => _LogConsoleOnShakeState();
}

class _LogConsoleOnShakeState extends State<LogConsoleOnShake> {
  ShakeDetector? _detector;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    if (widget.debugMode) {
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  _init() {
    LogConsole.init(bufferSize: 1024);
    _detector ??= ShakeDetector(onPhoneShake: _openLogConsole);
    _detector?.startListening();
  }

  _openLogConsole() async {
    if (_open) return;

    _open = true;

    var logConsole = LogConsole(
      showCloseButton: true,
      dark: widget.dark,
    );
    PageRoute route;
    if (Platform.isIOS) {
      route = CupertinoPageRoute(builder: (_) => logConsole);
    } else {
      route = MaterialPageRoute(builder: (_) => logConsole);
    }

    await Navigator.push(context, route);
    _open = false;
  }

  @override
  void dispose() {
    _detector?.stopListening();
    super.dispose();
  }
}
