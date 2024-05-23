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

#### Annet

-   For å laste ned avhengigheter for frontend så trenger man å sette opp github-token
    -   Gå til https://github.com/settings/tokens og lag en PAT (personal access token). Tokenet må minimum ha scopet "Packages:read"
        -   Etter tokenet er generet må du enable SSO for det. Trykk på "Configure SSO" og "Authorize" for navikt for relevant token på https://github.com/settings/tokens
    -   Logg inn med `npm login --scope=@navikt --registry=https://npm.pkg.github.com`
        -   Bruk brukernavn til github
        -   Bruk GITHUB_TOKEN som passord

## Dokumentasjon

### Nyttige lenker
 - Unleash https://tilleggsstonader-unleash-web.nav.cloud.nais.io 

### Developer

- Set opp pre-push hooks for kotlin-backends
  - Kjør `./dev/setupProject.sh` (må kjøres fra `./tilleggsstonader`)
-   [Gradle](./doc/dev/gradle.md)

### Hente nye repoen som eg lagt til

Mer dokumentasjon: https://github.com/mateodelnorte/meta-git

-   `git pull`
-   `meta git update`

### Opprettelse av nytt repo

Dette gjelder både for frontend og backend

#### Github

-   Opprett repo
-   Legg til Team tilleggstønader som admin under https://github.com/navikt/repo-navn/settings/access
-   Legg til `branch rules` https://github.com/navikt/repo-navn/settings/branches
    -   Require signed commits
    -   Do not allow bypassing the above settings
-   Settings:
    -   `Allow auto-merge`
    -   `Automatically delete head branches` efter PR
-   Repository secrets
    -   `SLACK_WEBHOOK_URL`
- Hvis appen skal deployes, autoriser appen
  - https://console.nav.cloud.nais.io/team/tilleggsstonader/repositories

#### tilleggstønader-repo

-   Kjør `meta project import <repo-navn> git@github.com:navikt/<repo-navn>`
-   Legg til repot i [Lenker til repo](#lenker-til-repo)
-   Legg til repo i [settings.gradle.kts](./settings.gradle.kts)

### Lenker til repo

Repoene som er inkludert i dette meta-repoet er

-   [tilleggsstonader-arena](https://github.com/navikt/tilleggsstonader-arena)
-   [tilleggsstonader-brev-sanity](https://github.com/navikt/tilleggsstonader-brev-sanity)
-   [tilleggsstonader-htmlify](https://github.com/navikt/tilleggsstonader-htmlify)
-   [tilleggsstonader-integrasjoner](https://github.com/navikt/tilleggsstonader-integrasjoner)
-   [tilleggsstonader-kontrakter](https://github.com/navikt/tilleggsstonader-kontrakter)
-   [tilleggsstonader-libs](https://github.com/navikt/tilleggsstonader-libs)
-   [tilleggsstonader-sak](https://github.com/navikt/tilleggsstonader-sak)
-   [tilleggsstonader-sak-frontend](https://github.com/navikt/tilleggsstonader-sak-frontend)
-   [tilleggsstonader-slackbot](https://github.com/navikt/tilleggsstonader-slackbot)
-   [tilleggsstonader-soknad](https://github.com/navikt/tilleggsstonader-soknad)
-   [tilleggsstonader-soknad-api](https://github.com/navikt/tilleggsstonader-soknad-api)
-   [tilleggsstonader-klage](https://github.com/navikt/tilleggsstonader-klage)
