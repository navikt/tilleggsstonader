# Hvordan bruke gradle

* Generellt
  * Bygg og test `./gradlew build`
  * Bygg men skip linting `./gradlew build --info -PskipLint`
  * Nye versjoner? `./gradlew dependencyUpdates -Drevision=release` 

* Ktlint
  * `./gradlew spotlessCheck`
  * `./gradlew spotlessApply`