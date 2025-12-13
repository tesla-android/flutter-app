# Testing Guide

## Quick Start

```bash
# Run all tests (Fast VM tests)
flutter test

# With coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Test Status

**Total: 340 tests** ✅ All passing (VM)

**Coverage**: 80.1%

**Breakdown**:
- Base view model tests: 14
- Service tests: 13
- View model tests: 41
- Widget tests: 24
- Integration tests: 24
- Cubit tests: 202

---

## Test Architecture

### MVVM Pattern (Settings)

View models extend `BaseSettingsViewModel<TState>` for consistent state handling:

```dart
class SoundSettingsViewModel extends BaseSettingsViewModel<AudioConfigurationState> {
  @override
  bool isLoadingState(AudioConfigurationState state) =>
      state is AudioConfigurationStateLoading;
  // ...
}
```

**View Models**:
- `DisplaySettingsViewModel`
- `HotspotSettingsViewModel`
- `SoundSettingsViewModel`
- `RearDisplaySettingsViewModel`

### Reusable Components

Type-safe UI components in `lib/common/ui/components/`:
- `SettingsSwitch` - Boolean toggles
- `SettingsDropdown<T>` - Generic dropdowns
- `SettingsSlider` - Numeric sliders
- `SettingsErrorWidget` - Standardized error display

### Test Helpers

Located in `test/helpers/`:
- `SettingsTestHelpers` - Widget test utilities
- `CubitBuilders` - Mock cubit setup with defaults
- `TestFixtures` - Sample data and builders
- `setupGetItMocks()` - DI mocking

---

## Integration Tests

**24 tests** covering critical flows:

```bash
flutter test test/integration/
```

**Test Files**:
- `settings_flow_test.dart` - HotspotSettings banner (3)
- `device_info_flow_test.dart` - Device display (2)
- `gps_flow_test.dart` - GPS toggle (3)
- `rear_display_flow_test.dart` - Multi-switch (5)
- `audio_flow_test.dart` - Volume/enable (7)
- `connectivity_flow_test.dart` - Connection states (4)

---

## Factory Tests

Platform abstraction factories are tested in `test/unit/factories/`:

```bash
flutter test test/unit/factories/
```

**Covered Factories**:
- `AudioServiceFactory`
- `WindowServiceFactory`
- `MessageSenderFactory`
- `FlavorFactory`

---

## Browser & Web Testing

**Strategy**: VM-First.
Dependencies like `dart:html` or `package:web` are abstracted behind **Factory Patterns** and **Conditional Imports** to allow fast, reliable VM testing.

### Architecture
- **Stubs**: `WebAudioService`, `WebWindowService`, etc., use stubs for VM execution.
- **Factories**: `AudioServiceFactory`, `WindowServiceFactory` select the correct implementation at runtime.

### Running Browser Tests
If you need to validate actual browser behavior (e.g., JS interop):

```bash
flutter test --platform chrome test/path/to/test.dart
```

---

## Best Practices

### Testing Patterns

```dart
// View model test
test('extracts value', () {
  expect(viewModel.getValue(state), expectedValue);
});

// Integration test
testWidgets('user interaction', (tester) async {
  when(mockCubit.state).thenReturn(State(value: false));
  await tester.tap(find.byType(Switch));
  verify(mockCubit.setValue(true)).called(1);
});
```

### Guidelines

- ✅ Use view models for business logic
- ✅ Use `SettingsTestHelpers` for widget tests
- ✅ Use `CubitBuilders` for mock setup
- ✅ Mock dependencies with `@GenerateMocks`
- ✅ Use `bloc_test` for cubit testing
- ✅ Write integration tests for user flows
- ✅ Extend `BaseSettingsViewModel` for new settings

---

## Troubleshooting

```dart
// Ensure async/await in bloc tests
blocTest('test', act: (cubit) async => await cubit.doSomething());
```

**Coverage not updating:**
```bash
flutter clean
flutter test --coverage
```

**Mock generation:**
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

## Using Makefile

```bash
make test          # Run all tests
make coverage      # Generate and open coverage report
make quick-check   # Format, analyze, and test
```

---

## Resources

- [Flutter Testing](https://docs.flutter.dev/testing)
- [bloc_test](https://pub.dev/packages/bloc_test)
- [mockito](https://pub.dev/packages/mockito)
