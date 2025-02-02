# Faithwave App

### :hammer: Building and Running the app

To run the app, you need to have the flutter sdk installed. If you don't have it installed, you can follow the instructions on the [official flutter website](https://flutter.dev/docs/get-started/install).

#### Build arguments

The app uses build arguments to inject the environment and tenant. The environment is used for setting the external services to use, and the tenant is used for setting the app flavor.

The following build arguments are available (optional):
- `--dart-define=ENV=<LOCAL|DEV|PROD>` - The environment to use. Defaults to `DEV`.
- `--dart-define=TENANT=<FAITHWAVE>` - The tenant to use. Defaults to `FAITHWAVE`.

#### Configuration

The environment variables are set in `<environment>.<tenant>.toml` file. Depending on the build arguments you set, the app will use the corresponding environment file.

For example, if you want to run the app using the `PROD` environment and `FAITHWAVE` tenant (which will read the `prod.faithwave.toml` file), you can use the following command:

```bash
flutter run --dart-define=ENV=PROD --dart-define=TENANT=FAITHWAVE
```

## 🎴 Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## 📁 Features

The `lib/src/features` directory contains the source code for the app's features. Features are distributed in vertical slices, with each feature having its own directory. It is important to note that features should be as self-contained as possible. Dependencies between features should be kept to a minimum.

Each feature directory contains the following subdirectories:
- `cubits` - Contains the [Cubit](https://bloclibrary.dev/#/coreconcepts?id=cubit) classes for the feature. The Cubit and its State goes in the same .dart file.
- `services` - Abstract classes that define the feature's service interfaces. Put repositories here as well. A service is defined as any functionality that is handled by something external to the app.
- `widgets` - Contains the widgets that are specific to the feature. These widgets should be reusable and should not contain any business logic.
- `screens` - Contains the screens that are specific to the feature. These screens are the entry points to the feature and should be built using the Cubit and Widgets from the feature.
- `models` - Contains the data models that are specific to the feature. These models should be used to represent the data that the feature uses.

Again, you may need to depend on other features to implement a feature. This is fine, but try to keep the dependencies to a minimum. Think of a feature as something that might become a package in the future. Having a dependency from one feature to another will result in package dependecies (if the features are split into packages some day).

## 📁 Adapters

The `lib/src/adapters` directory contains the source code for the app's adapters. Adapters are used to abstract the implementation of external services. This allows the app to switch between different implementations of the same service without impacting the rest of the app.

## 🧪 Tests

The `test` directory contains test code for the app. The tests are organized in the same way as the `lib` directory, with each feature having its own test file.

To run the tests, you can use the following command:

```bash
flutter test
```

Prioritize writing tests in the following order:
1. Bloc tests
2. Widget tests
3. Integration tests

*ALL* features should have at least bloc tests.

Try to follow good practices like [Test FIRST](https://hackernoon.com/test-f-i-r-s-t-65e42f3adc17).
