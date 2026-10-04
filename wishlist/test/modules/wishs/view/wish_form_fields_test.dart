import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_form_fields.dart';

import '../../../pump_app.dart';

void main() {
  testWidgets('shows the focused wish name counter from 80% of its limit', (
    tester,
  ) async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    final linkController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    addTearDown(() {
      nameController.dispose();
      priceController.dispose();
      quantityController.dispose();
      linkController.dispose();
      descriptionController.dispose();
    });

    await tester.pumpApp(
      SingleChildScrollView(
        child: WishFormFields(
          formKey: formKey,
          nameController: nameController,
          priceController: priceController,
          quantityController: quantityController,
          linkController: linkController,
          descriptionController: descriptionController,
          onImageSelected: (_) {},
        ),
      ),
    );

    final nameField = find.byType(TextFormField).first;
    expect(
      tester.widget<TextField>(find.byType(TextField).first).maxLength,
      80,
    );

    await tester.enterText(nameField, List.filled(63, 'a').join());
    await tester.pump();

    expect(find.text('63/80'), findsNothing);

    await tester.enterText(nameField, List.filled(64, 'a').join());
    await tester.pump();

    expect(find.text('64/80'), findsOneWidget);

    await tester.enterText(nameField, List.filled(72, 'a').join());
    await tester.pump();

    final warningCounter = tester.widget<Text>(find.text('72/80'));
    expect(warningCounter.style?.color, Colors.red);
    expect(warningCounter.style?.fontSize, 14);

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();

    expect(find.text('72/80'), findsNothing);

    await tester.tap(nameField);
    await tester.enterText(nameField, List.filled(81, 'a').join());
    await tester.pump();

    expect(nameController.text.length, 80);
    expect(find.text('80/80'), findsOneWidget);
  });
}
