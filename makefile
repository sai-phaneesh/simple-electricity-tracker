# Use FVM for Flutter commands
FLUTTER := fvm flutter
DART := fvm dart

.PHONY: generate clean get analyze run build-android build-ios

# Generate code with build_runner
generate:
	$(FLUTTER) pub run build_runner build --delete-conflicting-outputs

# Watch for changes and generate code
watch:
	$(FLUTTER) pub run build_runner watch --delete-conflicting-outputs

# Get dependencies
get:
	$(FLUTTER) pub get

# Clean build artifacts
clean:
	$(FLUTTER) clean
	rm -rf build/
	rm -rf .dart_tool/

# Run static analysis
analyze:
	$(FLUTTER) analyze

# Run the app
run:
	$(FLUTTER) run

# Build Android APK
build-android:
	$(FLUTTER) build apk --release

# Build Android App Bundle
build-aab:
	$(FLUTTER) build appbundle --release

# Build iOS
build-ios:
	$(FLUTTER) build ios --release

# Build web
build-web:
	$(FLUTTER) build web --release

# Run tests
test:
	$(FLUTTER) test

# Format code
format:
	$(DART) format lib/ test/

# Fix lint issues
fix:
	$(DART) fix --apply

# Full rebuild (clean, get deps, generate code)
rebuild: clean get generate
