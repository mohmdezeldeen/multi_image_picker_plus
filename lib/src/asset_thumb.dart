import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'asset.dart';

class AssetThumb extends StatefulWidget {
  const AssetThumb({
    required this.asset,
    required this.width,
    required this.height,
    super.key,
    this.quality = 100,
    this.spinner = const Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    ),
  });

  /// The asset we want to show thumb for.
  final Asset asset;

  /// The thumb width
  final int width;

  /// The thumb height
  final int height;

  /// The thumb quality
  final int quality;

  /// This is the widget that will be displayed while the
  /// thumb is loading.
  final Widget spinner;

  @override
  State<AssetThumb> createState() => _AssetThumbState();
}

class _AssetThumbState extends State<AssetThumb> {
  ByteData? _thumbData;

  int get width => widget.width;
  int get height => widget.height;
  int get quality => widget.quality;
  Asset get asset => widget.asset;
  Widget get spinner => widget.spinner;

  @override
  void initState() {
    super.initState();
    _loadThumb();
  }

  @override
  void didUpdateWidget(AssetThumb oldWidget) {
    if (oldWidget.asset.identifier != widget.asset.identifier) {
      _loadThumb();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadThumb() async {
    setState(() {
      _thumbData = null;
    });

    final ByteData thumbData = await asset.getThumbByteData(
      width,
      height,
      quality: quality,
    );

    if (mounted) {
      setState(() {
        _thumbData = thumbData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbData == null) {
      return spinner;
    }
    return Image.memory(
      _thumbData!.buffer.asUint8List(),
      key: ValueKey(asset.identifier),
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  }
}
