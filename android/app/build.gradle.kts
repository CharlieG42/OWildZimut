plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.wildzimut.o_wild_zimut"
    compileSdk = 34

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets {
        main.java.srcDirs += "src/main/kotlin"
    }

    defaultConfig {
        applicationId = "com.wildzimut.o_wild_zimut"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "0.0.001"
    }

    lintOptions {
        disable("InvalidPackage")
        checkReleaseBuilds = false
    }
}

flutter {
    source = "../.."
}
