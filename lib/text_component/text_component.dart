import 'package:flutter/material.dart';
import 'text_group.dart';

class TextComponent extends StatefulWidget {
  const TextComponent({
    super.key,
    required this.text,
    this.textKey,
    this.style,
    this.strutStyle,
    this.minFontSize = 1,
    this.maxFontSize = double.infinity,
    this.stepGranularity = 1,
    this.presetFontSizes,
    this.group,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.wrapWords = true,
    this.overflow,
    this.overflowReplacement,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  }) : textSpan = null;

  const TextComponent.rich(
      this.textSpan, {
        super.key,
        this.textKey,
        this.style,
        this.strutStyle,
        this.minFontSize = 1,
        this.maxFontSize = double.infinity,
        this.stepGranularity = 1,
        this.presetFontSizes,
        this.group,
        this.textAlign,
        this.textDirection,
        this.locale,
        this.softWrap,
        this.wrapWords = true,
        this.overflow,
        this.overflowReplacement,
        this.textScaleFactor,
        this.maxLines,
        this.semanticsLabel,
      }) : text = null;

  final Key? textKey;
  final String? text;
  final TextSpan? textSpan;
  final TextStyle? style;
  static const double _defaultFontSize = 14;
  final StrutStyle? strutStyle;
  final double minFontSize;
  final double maxFontSize;
  final double stepGranularity;
  final List<double>? presetFontSizes;
  final AutoSizeGroup? group;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final bool wrapWords;
  final TextOverflow? overflow;
  final Widget? overflowReplacement;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;

  @override
  State<TextComponent> createState() => _TextComponentState();
}

class _TextComponentState extends State<TextComponent> {
  @override
  void initState() {
    super.initState();
    widget.group?.register(this);
  }

  @override
  void didUpdateWidget(TextComponent old) {
    super.didUpdateWidget(old);
    if (old.group != widget.group) {
      old.group?.remove(this);
      widget.group?.register(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      final defaultStyle = DefaultTextStyle.of(context);
      var style = widget.style;
      if (style == null || style.inherit) {
        style = defaultStyle.style.merge(widget.style);
      }
      if (style.fontSize == null) {
        style = style.copyWith(fontSize: TextComponent._defaultFontSize);
      }

      final maxLines = widget.maxLines ?? defaultStyle.maxLines;
      _validateProperties(style, maxLines);

      final result = _calculateFontSize(size, style, maxLines);
      final fontSize = result[0] as double;
      final textFits = result[1] as bool;

      Widget text;
      if (widget.group != null) {
        widget.group!.updateFontSize(this, fontSize);
        text = _buildText(widget.group!.fontSize, style, maxLines);
      } else {
        text = _buildText(fontSize, style, maxLines);
      }

      return (!textFits && widget.overflowReplacement != null)
          ? widget.overflowReplacement!
          : text;
    });
  }

  void _validateProperties(TextStyle style, int? maxLines) {
    assert(widget.overflow == null || widget.overflowReplacement == null);
    assert(maxLines == null || maxLines > 0);
    assert(widget.key == null || widget.key != widget.textKey);

    if (widget.presetFontSizes == null) {
      assert(widget.stepGranularity >= 0.1);
      assert(widget.minFontSize >= 0);
      assert(widget.maxFontSize > 0);
      assert(widget.minFontSize <= widget.maxFontSize);
      assert(widget.minFontSize / widget.stepGranularity % 1 == 0);
      if (widget.maxFontSize != double.infinity) {
        assert(widget.maxFontSize / widget.stepGranularity % 1 == 0);
      }
    } else {
      assert(widget.presetFontSizes!.isNotEmpty);
    }
  }

  List _calculateFontSize(BoxConstraints size, TextStyle style, int? maxLines) {
    final span = TextSpan(
      style: widget.textSpan?.style ?? style,
      text: widget.textSpan?.text ?? widget.text,
      children: widget.textSpan?.children,
    );

    final userScale = widget.textScaleFactor ?? MediaQuery.textScalerOf(context).scale(1);

    int left, right;
    final preset = widget.presetFontSizes?.reversed.toList();

    if (preset == null) {
      final df = style.fontSize!.clamp(widget.minFontSize, widget.maxFontSize);
      final defaultScale = df * userScale / style.fontSize!;
      if (_checkTextFits(span, defaultScale, maxLines, size)) {
        return <Object>[df * userScale, true];
      }
      left = (widget.minFontSize / widget.stepGranularity).floor();
      right = (df / widget.stepGranularity).ceil();
    } else {
      left = 0;
      right = preset.length - 1;
    }

    bool lastFits = false;
    while (left <= right) {
      final mid = ((left + right) / 2).floor();
      final scale = (preset == null)
          ? mid * userScale * widget.stepGranularity / style.fontSize!
          : preset[mid] * userScale / style.fontSize!;
      if (_checkTextFits(span, scale, maxLines, size)) {
        left = mid + 1;
        lastFits = true;
      } else {
        right = mid - 1;
      }
    }

    if (!lastFits) right++;
    final fs = (preset == null)
        ? right * userScale * widget.stepGranularity
        : preset[right] * userScale;

    return <Object>[fs, lastFits];
  }

  bool _checkTextFits(
      TextSpan text,
      double scale,
      int? maxLines,
      BoxConstraints constraints,
      ) {
    if (!widget.wrapWords) {
      final words = text.toPlainText().split(RegExp(r'\s+'));
      final painter = TextPainter(
        text: TextSpan(style: text.style, text: words.join('\n')),
        textAlign: widget.textAlign ?? TextAlign.left,
        textDirection: widget.textDirection ?? TextDirection.ltr,
        textScaler: TextScaler.linear(scale),
        maxLines: words.length,
        locale: widget.locale,
        strutStyle: widget.strutStyle,
      );
      painter.layout(maxWidth: constraints.maxWidth);
      if (painter.didExceedMaxLines || painter.width > constraints.maxWidth) {
        return false;
      }
    }

    final tp = TextPainter(
      text: text,
      textAlign: widget.textAlign ?? TextAlign.left,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      textScaler: TextScaler.linear(scale),
      maxLines: maxLines,
      locale: widget.locale,
      strutStyle: widget.strutStyle,
    );
    tp.layout(maxWidth: constraints.maxWidth);

    return !(tp.didExceedMaxLines || tp.height > constraints.maxHeight || tp.width > constraints.maxWidth);
  }

  Widget _buildText(double fontSize, TextStyle style, int? maxLines) {
    if (widget.text != null) {
      return Text(
        widget.text!,
        key: widget.textKey,
        style: style.copyWith(fontSize: fontSize),
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaler: const TextScaler.linear(1),
        maxLines: maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    } else {
      return Text.rich(
        widget.textSpan!,
        key: widget.textKey,
        style: style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaler: TextScaler.linear(fontSize / (style.fontSize ?? TextComponent._defaultFontSize)),
        maxLines: maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    }
  }

  @override
  void dispose() {
    widget.group?.remove(this);
    super.dispose();
  }
}
