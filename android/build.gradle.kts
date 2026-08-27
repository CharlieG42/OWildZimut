allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Force compileSdk=36 pour TOUTES les sous-projets (y compris file_picker)
subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library") || plugins.hasPlugin("com.android.application")) {
            android {
                compileSdkVersion = 36
            }
        }
    }
}
