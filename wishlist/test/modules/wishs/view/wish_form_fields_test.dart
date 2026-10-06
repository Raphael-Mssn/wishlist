import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/modules/wishs/view/widgets/image_upload_field.dart';
import 'package:wishlist/modules/wishs/view/widgets/wish_form_fields.dart';
import 'package:wishlist/shared/theme/colors.dart';

import '../../../pump_app.dart';

void main() {
  imagePreviewTests();

  group('truncateWishName', () {
    test('keeps a name within the limit, trimmed', () {
      expect(truncateWishName('  Casque audio  '), 'Casque audio');
    });

    test('cuts a prefilled name to the field limit', () {
      const longTitle = 'Apple AirPods Pro (2nd Generation) Wireless Ear Buds '
          'with USB-C Charging, Up to 2X More Active Noise Cancelling';
      final result = truncateWishName(longTitle);
      expect(result.length, lessThanOrEqualTo(wishNameMaxLength));
      expect(longTitle.startsWith(result), isTrue);
    });
  });

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
          wishlistColor: AppColors.primary,
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

/// PNG 1x1 valide, pour que Image.file ait un vrai fichier à lire.
const _pngBytes = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
];

void imagePreviewTests() {
  group('image provided by the parent (link preview)', () {
    late Directory dir;
    late File previewA;
    late File previewB;
    late ValueNotifier<File?> initialImage;
    final controllers = List.generate(5, (_) => TextEditingController());

    setUp(() {
      dir = Directory.systemTemp.createTempSync('wish_form_fields_test');
      previewA = File('${dir.path}/a.png')..writeAsBytesSync(_pngBytes);
      previewB = File('${dir.path}/b.png')..writeAsBytesSync(_pngBytes);
      initialImage = ValueNotifier<File?>(previewA);
    });

    tearDown(() {
      initialImage.dispose();
      dir.deleteSync(recursive: true);
    });

    Future<void> pumpFields(WidgetTester tester) => tester.pumpApp(
          SingleChildScrollView(
            child: ValueListenableBuilder<File?>(
              valueListenable: initialImage,
              builder: (context, file, _) => WishFormFields(
                formKey: GlobalKey<FormState>(),
                nameController: controllers[0],
                priceController: controllers[1],
                quantityController: controllers[2],
                linkController: controllers[3],
                descriptionController: controllers[4],
                onImageSelected: (_) {},
                wishlistColor: AppColors.primary,
                initialImageFile: file,
              ),
            ),
          ),
        );

    File? displayedImage(WidgetTester tester) => tester
        .widget<ImageUploadField>(find.byType(ImageUploadField))
        .imageFile;

    testWidgets('shows the new preview image when the link changes',
        (tester) async {
      await pumpFields(tester);
      expect(displayedImage(tester)?.path, previewA.path);

      initialImage.value = previewB;
      await tester.pump();

      expect(displayedImage(tester)?.path, previewB.path);
    });

    testWidgets(
        'removes the previous preview image when the new link has none, '
        'so the form shows what will be saved', (tester) async {
      await pumpFields(tester);
      expect(displayedImage(tester)?.path, previewA.path);

      initialImage.value = null;
      await tester.pump();

      expect(displayedImage(tester), isNull);
    });
  });
}
