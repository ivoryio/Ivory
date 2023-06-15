# Variables
APPVERSION=$(shell python3 -c "import yaml;print(yaml.safe_load(open('pubspec.yaml'))['version'].split('+')[0])")

# Helpers
version:
	@echo $(APPVERSION)

# Release steps

# Step 0: Clean build files
clean:
	flutter clean
# Step 1: Get dependencies
install:
	flutter pub get

# Step 2: Run tests
unit-test:
	flutter test

# Step 3: Create Github release
github-release:
	gh release create v$(APPVERSION) --generate-notes

# Step 4: Build Android app
build-android:
	flutter build appbundle

# Step 5: Build iOS app
build-ios:
	flutter build ipa


# Release application
release: clean install unit-test github-release build-android build-ios