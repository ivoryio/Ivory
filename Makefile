# Variables
APPVERSION=$(shell cat pubspec.yaml | grep 'version: ' | sed 's/version: //g' | sed 's/ //g' | sed 's/+.*//')

# Helpers
version:
	@echo $(APPVERSION)

###########################################################

# Commands
clean:
	flutter clean

install:
	flutter pub get

unit-test:
	flutter test

github-release:
	gh release create v$(APPVERSION) --generate-notes

build-android:
	flutter build appbundle --dart-define=CLIENT=$(CLIENT)

build-ios:
	flutter build ipa --dart-define=CLIENT=$(CLIENT)

update-splashscreen:
	dart run flutter_native_splash:create --path=splash_screen_$(CLIENT).yaml

###########################################################


# Release application

## Use 'make release CLIENT=default' command to release default application, use 'make release CLIENT=client_name' to release specific application
release: clean install unit-test update-splashscreen github-release build-android build-ios
