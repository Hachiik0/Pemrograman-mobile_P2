import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sqlite_demo/models/note.dart';
import 'package:flutter_sqlite_demo/screens/note_form.dart';

void main() {
  group('Note', () {
    test('converts to and from a database map', () {
      final note = Note(
        id: 7,
        title: 'Tugas SQLite',
        content: 'Selesaikan CRUD',
        createdAt: '2026-10-26T12:00:00.000Z',
        category: 'Kuliah',
        color: Note.categoryColors['Kuliah']!,
      );

      final restored = Note.fromMap(note.toMap());

      expect(restored.id, 7);
      expect(restored.title, 'Tugas SQLite');
      expect(restored.content, 'Selesaikan CRUD');
      expect(restored.createdAt, '2026-10-26T12:00:00.000Z');
      expect(restored.category, 'Kuliah');
      expect(restored.color, Note.categoryColors['Kuliah']);
    });
  });

  testWidgets('requires a title and content before saving', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: NoteForm()),
    );

    await tester.tap(find.text('Simpan catatan'));
    await tester.pumpAndSettle();

    expect(find.text('Judul tidak boleh kosong'), findsOneWidget);
    expect(find.text('Isi catatan tidak boleh kosong'), findsOneWidget);
  });
}
