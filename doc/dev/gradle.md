# Hvordan bruke gradle

* Generellt
  * Bygg og test `./gradlew build`
  * Bygg men skip linting `./gradlew build --info -PskipLint`
  * Nye versjoner? `./gradlew dependencyUpdates -Drevision=release` 
  * Oppdater til siste versjonene `./gradlew useLatestVersions` 
  * Lag pr med oppdateringer? `gh pr create --title "Dependabot oppdateringer" --body ""` 

* Ktlint
  * `./gradlew spotlessCheck`
  * `./gradlew spotlessApply`