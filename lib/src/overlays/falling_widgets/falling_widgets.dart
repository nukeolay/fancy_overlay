import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:fancy_overlay/fancy_overlay.dart';
import 'package:fancy_overlay/src/overlays/falling_widgets/falling_model.dart';

class FallingWidgets extends StatefulWidget {
  const FallingWidgets({required this.config, super.key});
  final FallingWidgetsOverlayConfig config;

  @override
  State<FallingWidgets> createState() => _FallingWidgetsState();
}

class _FallingWidgetsState extends State<FallingWidgets>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _repaint = ValueNotifier<int>(0);
  final List<FallingModel> _fallingWidgets = [];
  Size _screenSize = Size.zero;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncScreenSize(MediaQuery.of(context).size);
  }

  @override
  void didUpdateWidget(covariant FallingWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldResetModels(oldWidget.config, widget.config)) {
      _resetModels();
      return;
    }

    _syncModelCount();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _repaint.dispose();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    final delta = elapsed - _lastElapsed;
    _lastElapsed = elapsed;
    if (delta <= Duration.zero || _screenSize == Size.zero) {
      return;
    }

    for (final model in _fallingWidgets) {
      model.updatePosition(delta);
    }

    final removedCount = _fallingWidgets.length;
    _fallingWidgets.removeWhere((model) => model.isOffScreen);
    final hasRemovedModels = _fallingWidgets.length != removedCount;
    final hasAddedModels = _syncModelCount();

    if (hasRemovedModels || hasAddedModels) {
      setState(() {});
      return;
    }

    _repaint.value++;
  }

  void _syncScreenSize(Size screenSize) {
    if (_screenSize == screenSize) {
      return;
    }

    _screenSize = screenSize;
    _resetModels();
  }

  void _resetModels() {
    _fallingWidgets
      ..clear()
      ..addAll(
        List.generate(
          widget.config.numberOfWidgets,
          (_) => FallingModel(
            config: widget.config,
            screenSize: _screenSize,
          ),
        ),
      );

    if (mounted) {
      setState(() {});
    }
  }

  bool _syncModelCount() {
    final desiredCount = widget.config.numberOfWidgets;
    if (_fallingWidgets.length > desiredCount) {
      _fallingWidgets.removeRange(desiredCount, _fallingWidgets.length);
      return true;
    }

    if (_fallingWidgets.length < desiredCount) {
      _fallingWidgets.addAll(
        List.generate(
          desiredCount - _fallingWidgets.length,
          (_) => FallingModel(
            config: widget.config,
            screenSize: _screenSize,
          ),
        ),
      );
      return true;
    }

    return false;
  }

  bool _shouldResetModels(
    FallingWidgetsOverlayConfig oldConfig,
    FallingWidgetsOverlayConfig newConfig,
  ) {
    return oldConfig.children != newConfig.children ||
        oldConfig.positionStrategy != newConfig.positionStrategy ||
        oldConfig.minYSpeed != newConfig.minYSpeed ||
        oldConfig.maxYSpeed != newConfig.maxYSpeed ||
        oldConfig.minXSpeed != newConfig.minXSpeed ||
        oldConfig.maxXSpeed != newConfig.maxXSpeed ||
        oldConfig.minScale != newConfig.minScale ||
        oldConfig.maxScale != newConfig.maxScale ||
        oldConfig.rotationSpeed != newConfig.rotationSpeed;
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: _FallingWidgetsFlowDelegate(
        models: _fallingWidgets,
        appearDuration: widget.config.appearDuration,
        repaint: _repaint,
      ),
      children: _fallingWidgets.map(
        (model) {
          return KeyedSubtree(
            key: model.key,
            child: model.widget,
          );
        },
      ).toList(),
    );
  }
}

class _FallingWidgetsFlowDelegate extends FlowDelegate {
  _FallingWidgetsFlowDelegate({
    required this.models,
    required this.appearDuration,
    required Listenable repaint,
  }) : super(repaint: repaint);

  final List<FallingModel> models;
  final Duration appearDuration;

  @override
  Size getSize(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  BoxConstraints getConstraintsForChild(
    int i,
    BoxConstraints constraints,
  ) {
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    for (var index = 0; index < context.childCount; index++) {
      final model = models[index];
      final scale = model.scale * model.appearProgress(appearDuration);
      final childSize = context.getChildSize(index) ?? Size.zero;
      final childCenterX = childSize.width / 2;
      final childCenterY = childSize.height / 2;
      final transform = Matrix4.identity()
        ..translateByDouble(
          model.x + childCenterX,
          model.y + childCenterY,
          0,
          1,
        )
        ..rotateZ(model.rotation)
        ..scaleByDouble(scale, scale, scale, 1)
        ..translateByDouble(-childCenterX, -childCenterY, 0, 1);

      context.paintChild(
        index,
        transform: transform,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FallingWidgetsFlowDelegate oldDelegate) {
    return oldDelegate.models != models ||
        oldDelegate.appearDuration != appearDuration;
  }

  @override
  bool shouldRelayout(covariant _FallingWidgetsFlowDelegate oldDelegate) {
    return oldDelegate.models.length != models.length;
  }
}
