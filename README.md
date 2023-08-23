# tilleggsstonader

Startpunkt (metarepo) for tilleggsstønader

## Komme i gang

[meta](https://github.com/mateodelnorte/meta) brukes til å sette opp
repositories for alle repoene.

Enn så lenge må du sørge for å ha `npm` installert (`brew install node`).

```
npm install meta -g --no-save
```

Merk! meta foran vanlig clone-kommando:

```
meta git clone git@github.com:navikt/tilleggsstonader.git
```

Nå kan git brukes som normalt for hvert repo.

Se [meta](https://github.com/mateodelnorte/meta) for flere kommandoer.

Dersom du nå åpner `build.gradle` med `Open` (som Project) i IntelliJ så får du alle komponentene inn i ett
IntelliJ-oppsett.

## Dokumentasjon
### Developer
* [Gradle](./doc/dev/gradle.md)

### Hente nye repoen som eg lagt til
Mer dokumentasjon: https://github.com/mateodelnorte/meta-git
* `git pull`
* `meta git update`

### Opprettelse av nytt repo

Dette gjelder både for frontend og backend

#### Github
* Opprett repo
* Legg til Team tilleggstønader som admin under https://github.com/navikt/<repo-navn>/settings/access
* Legg til `branch rules` https://github.com/navikt/<repo-navn>/settings/branches
  * Require signed commits
  * Do not allow bypassing the above settings
* Settings: `Automatically delete head branches` efter PR
* Repository secrets
  * NAIS_DEPLOY_APIKEY (hentes fra [nais-console](https://console.nav.cloud.nais.io/team/tilleggsstonader/settings)
  * SLACK_WEBHOOK_URL

#### tilleggstønader-repo
* Kjør `meta project import <repo-navn> git@github.com:navikt/<repo-navn>`
* Legg til repot i [Lenker til repo](#lenker-til-repo) 
* Legg til repo i [settings.gradle.kts](./settings.gradle.kts)

### Lenker til repo
Repoene som er inkludert i dette meta-repoet er

- [tilleggsstonader-soknad] (https://github.com/navikt/tilleggsstonader-soknad)
- [tilleggsstonader-soknad-api] (https://github.com/navikt/tilleggsstonader-soknad-api)
