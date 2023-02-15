Browsr Flutter - Maurício Pessoa
---

### Navigating through the projects

The project files are structured as follows:

#### Native library

The Browsr native lib can be found inside the `BrowsrNativeLib` folder, and the library module is called `browsr`.

- common
	- This package contains some database related files;
- di
	- This package has some of the DI (Koin) modules used in this project;
- organizations
	- This package has the all the entities, repository, networking services, all data sources and more DI definitions;
- utils
	- This package has some utilitarian networking classes, used to check for connectivity;
- BrowsrSDK
	- This is the file that should be instantiated inside the flutter project;
- Consts
	- This file has some project wide constants.

OBS: The unit test files can be found inside the `BrowsrNativeLib/browsr/src/test` folder.

#### Flutter app

The Browsr flutter app can be found inside the `browsr_app` folder, the main dart file can be found inside `browsr_app/lib/main.dart`.

#### Flutter plugin

The Browsr flutter plugin can be found inside `browsr_app/libraries/browsr` and it exposes 4 methods from the native code:

- getOrganizations
	- This method will return a list of GitHub organizations
- setFavoriteOrg
	- This method is reponsible for saving a particular organization as a favorite
- removeFavoriteOrg
	- This method will remove a particular organization from the favorites
- removeAllFavoriteOrgs
	- This method can be used to remove all favorites

OBS: The `.aar` file can be found in the `browsr_app/libraries/browsr/android/libs` folder

### Dependencies

#### Native code

The native code relies on the following libraries:

- androidx.arch.core:core-testing
- org.jetbrains.kotlinx:kotlinx-coroutines-android
- org.jetbrains.kotlinx:kotlinx-coroutines-core
- org.jetbrains.kotlinx:kotlinx-coroutines-test
- junit
- org.koin:koin-android
- io.mockk:mockk
- com.squareup.moshi:moshi-kotlin
- com.squareup.moshi:moshi-kotlin-codegen
- com.squareup.retrofit2:converter-moshi
- com.squareup.okhttp3:okhttp
- com.squareup.okhttp3:logging-interceptor
- com.squareup.retrofit2:retrofit
- androidx.room:room-ktx
- com.jakewharton.timber:timber

#### Flutter code

The flutter code has the following dependencies:

- Browsr SDK in the aar file
- flutter_search_bar
