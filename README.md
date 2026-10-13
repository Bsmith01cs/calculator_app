# CSC 4360 — Calculator State Lab (undergraduate)

This is source code to copy into a fresh Flutter project named `calculator_app`. It is NOT a complete Android/iOS Flutter scaffold. Generate that scaffold with `flutter create calculator_app` first.

## Undergraduate feature choices (exactly three)
1. AC reset of display, accumulator, pending operator, and result/error state.
2. Error handling: divide-by-zero and incomplete-input guidance with recovery.
3. `InkWell` press effects on all 16 calculator buttons.

Core calculation is deliberately left-to-right: `2 + 3 × 4 = 20`.

## Fast Mac setup

1. Download `Calculator_State_Lab_Undergraduate_Code.zip` to Downloads.
2. Run in Terminal:

```bash
mkdir -p ~/flutter-projects
cd ~/flutter-projects
flutter create calculator_app
cd calculator_app
unzip -o ~/Downloads/Calculator_State_Lab_Undergraduate_Code.zip
flutter pub get
dart format lib test
flutter analyze
flutter test
```

If you downloaded somewhere other than Downloads, update the ZIP path. If your Flutter workspace is somewhere else, use that workspace instead of `~/flutter-projects`.

This ZIP replaces `lib/main.dart` and `test/widget_test.dart`, and includes this README. The package import in the tests expects the project name `calculator_app`.

## Manual smoke test

Start an Android emulator in Android Studio Device Manager, or attach a physical Android phone with USB debugging enabled:

```bash
flutter devices
flutter run
```

Verify the following by tapping the on-screen buttons:

| Buttons | Expected | Evidence |
| --- | --- | --- |
| `2 + 3 ×` | `5` | running total displayed after operator |
| `2 + 3 × 4 =` | `20` | left-to-right calculation |
| `9 + × 2 =` | `18` | second operator replaces first |
| `7 + =` | `7` + guidance | equals ignored while awaiting operand |
| `7 + = 3 =` | `10` | pending operator still works |
| `2 + 3 = 7` | `7` | digit after equals starts fresh |
| `9 × AC 2 + 3 =` | `5` | hidden state is reset |
| `8 ÷ 0 =` | `Error` | zero-division validation |
| `8 ÷ 0 = 4` | `4` | digit recovers from error |

Confirm the ripple animation is visible when tapping multiple buttons, with readable display text on a small Android screen.

## Release APK

```bash
flutter build apk --release
flutter install --release
mkdir -p submission
cp build/app/outputs/flutter-apk/app-release.apk submission/YourName_CalculatorApp.apk
```

If `flutter install --release` fails, use Android Studio / `adb install -r build/app/outputs/flutter-apk/app-release.apk` with an attached Android device. Test the actual release APK, not just the debug run.

## GitHub

```bash
git init
git add .
git commit -m "Complete calculator state lab"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/calculator_app.git
git push -u origin main
printf '%s\n' 'https://github.com/YOUR_USERNAME/calculator_app' > submission/github_link.txt
```

Create a new EMPTY GitHub repository called `calculator_app` **before** `git remote add origin`. If `git remote add origin` reports that origin already exists, use `git remote set-url origin ...` instead. If `git commit` reports that Git identity is missing, configure it according to your own Git account. Do not push a placeholder URL.

## Rationale DOCX

Use the separate downloadable Word template. Replace `YourName` and student-ID placeholders, verify the program locally, write your own reflections for topics 01–06, and actually compare two unchanged AI test prompts using two different AI agents. Do not invent agent responses, dates, or test results. Follow your course AI-use policy.

## Deliverables to upload to the course submission folder

- `github_link.txt` — publicly accessible or instructor-accessible full repository URL.
- `YourName_CalculatorApp.apk` — release APK that you installed and tested.
- `YourName_Implementation.docx` — finished implementation rationale.

Deadline in the supplied assignment: October 12, 2026, 11:59 PM (check LMS time zone).

**Validation status:** This package has been code-reviewed, but Flutter SDK is not installed in the preparation environment. `flutter analyze`, `flutter test`, Android emulator, and release APK must be executed on your machine. Passing is not asserted in advance.
