import 'dart:html';

import 'color.dart';
import 'column.dart';
import 'note.dart';

class Notefield {
  static final CanvasElement canvas = querySelector('#game');

  static const int columnCount = 6;
  static const int leftOffset = 220;
  static const int noteHeight = 24;

  static final List<Color> columnColors = [
    Color.yellow,
    Color.white,
    Color.violet,
    Color.white,
    Color.violet,
    Color.white,
  ];

  static final List<num> columnWidths = [50, 48, 46, 48, 46, 48];
  static final Color backgroundColor = Color.black.withOpacity(0.8);
  static final Color borderColor = Color.white.withOpacity(0.8);
  static final num totalWidth = columnWidths.reduce((a, b) => a + b);
  static final num center = leftOffset + totalWidth / 2;

  final List<Column> columns = [];

  Notefield() {
    num left = leftOffset;
    for (num i = 0; i < columnCount; i++) {
      final width = columnWidths[i];
      final color = columnColors[i];
      columns.add(new Column(left, width, color));
      left += width;
    }
  }

  setColumnPressed(int col, bool pressed) {
    if (col >= 0 && col < columnCount) {
      columns[col].pressed = pressed;
    }
  }

  update(num dt) {
    columns.forEach((col) => col.update(dt));
  }

  drawBackground() {
    canvas.context2D
      ..fillStyle = backgroundColor
      ..fillRect(leftOffset, 0, totalWidth, canvas.height);
  }

  drawBorders() {
    canvas.context2D
      ..fillStyle = borderColor
      ..fillRect(leftOffset - 4, 0, 4, canvas.height)
      ..fillRect(leftOffset + totalWidth, 0, 4, canvas.height);
  }

  drawNotes(List<Note> notes, num songTime) {
    for (final note in notes) {
      note.draw(columns[note.column], songTime);
    }
  }

  draw(List<Note> notes, num songTime) {
    drawBackground();
    drawBorders();
    columns.forEach((col) => col.drawBacklight());
    columns.forEach((col) => col.drawReceptor());
    drawNotes(notes, songTime);
    columns.forEach((col) => col.drawKey());
  }
}
