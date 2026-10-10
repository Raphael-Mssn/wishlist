import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishlist/shared/navigation/floating_nav_bar_navigator.dart';
import 'package:wishlist/shared/widgets/floating_nav_bar.dart';

import '../../fixtures/fake_providers.dart';

void main() {
  testWidgets('calls onTabChanged once per tap, even after rebuilds',
      (tester) async {
    final calls = <FloatingNavBarTab>[];
    final tabController = TabController(
      length: FloatingNavBarTab.values.length,
      vsync: const TestVSync(),
    );
    addTearDown(tabController.dispose);
    late StateSetter rebuild;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [friendshipsRealtimeOverride()],
        child: MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return FloatingNavBar(
                  onTabChanged: calls.add,
                  currentTab: FloatingNavBarTab.home,
                  tabController: tabController,
                );
              },
            ),
          ),
        ),
      ),
    );

    for (var i = 0; i < 3; i++) {
      rebuild(() {});
      await tester.pump();
    }

    await tester.tap(find.byIcon(Icons.group));
    await tester.pumpAndSettle();

    expect(calls, [FloatingNavBarTab.friends]);
  });
}
