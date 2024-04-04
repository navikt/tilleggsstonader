
repositories {
    mavenCentral()
    mavenLocal()

    maven("https://jitpack.io")

    maven {
        url = uri("https://github-package-registry-mirror.gc.nav.no/cached/maven-release")
    }
}