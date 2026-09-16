import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing credentials, kept out of git (see .gitignore) — see
// docs/CONTRIBUTING.md for how to generate android/key.properties locally.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystoreProperties = keystorePropertiesFile.exists()
if (hasKeystoreProperties) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "dev.timmofto.BetterDrink"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "dev.timmofto.BetterDrink"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // Health Connect's client library requires API 26+; the health
        // plugin's own example project sets this same override.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasKeystoreProperties) {
            create("release") {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // A release build without a real signing key used to fall back to the debug
            // key silently — that produced release-variant APKs that Android then refuses
            // to install as an update over a properly release-signed build, with no error
            // beyond "App not installed". Require an explicit opt-in instead.
            val allowUnsignedRelease = (findProperty("allowUnsignedRelease") as String?).toBoolean()
            signingConfig = when {
                hasKeystoreProperties -> signingConfigs.getByName("release")
                allowUnsignedRelease -> signingConfigs.getByName("debug")
                else -> throw GradleException(
                    "Release build requested but android/key.properties is missing, so there's " +
                        "no release signing key configured. See docs/CONTRIBUTING.md to set up the " +
                        "keystore, or set the env var ORG_GRADLE_PROJECT_allowUnsignedRelease=true " +
                        "to explicitly build a debug-signed release APK for local testing only — " +
                        "never distribute one."
                )
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
