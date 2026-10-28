# tilleggsstonader

Startpunkt (metarepo) for tilleggsstønader

## Komme i gang

[meta fra gitkb](https://github.com/gitkb/meta) brukes til å klone og administrere
teamets repoer. Vi bruker Rust-implementasjonen, ikke den gamle npm-pakken.

Har du installert den gamle pakken med npm, fjern den først:

```bash
npm uninstall --global meta
```

Installer den nye pakken med Homebrew:

```bash
brew install gitkb/tap/meta-cli
meta --version
```

Meta krever ikke Node.js eller npm. For andre plattformer, se
[installasjonsveiledningen](https://github.com/gitkb/meta#installation).

Klon dette repoet og alle underrepoene med:

```bash
meta git clone git@github.com:navikt/tilleggsstonader.git
```

Git kan brukes som normalt i hvert underrepo. Eksisterende kloner trenger ikke
klones på nytt: Den nye pakken leser samme [`.meta`](./.meta)-fil og bruker samme mapper.

Se [meta](https://github.com/gitkb/meta#commands) for flere kommandoer.

Dersom du nå åpner `build.gradle` med `Open` (som Project) i IntelliJ så får du alle komponentene inn i ett
IntelliJ-oppsett.

#### Annet

- For å laste ned avhengigheter for frontend så trenger man å sette opp github-token
    - Gå til https://github.com/settings/tokens og lag en PAT (personal access token). Tokenet må minimum ha scopet "
      Packages:read"
        - Etter tokenet er generet må du enable SSO for det. Trykk på "Configure SSO" og "Authorize" for navikt for
          relevant token på https://github.com/settings/tokens
    - Logg inn med `npm login --scope=@navikt --registry=https://npm.pkg.github.com`
        - Bruk brukernavn til github
        - Bruk GITHUB_TOKEN som passord

## Dokumentasjon

### Nyttige lenker

- Unleash https://tilleggsstonader-unleash-web.iap.nav.cloud.nais.io

### Developer

- Set opp pre-push hooks for kotlin-backends
    - Kjør `./dev/setupProject.sh` (må kjøres fra `./tilleggsstonader`)

### Hente nye repoer som er lagt til

Kjør fra roten av dette repoet:

```bash
git pull
meta git update
```

`git pull` henter den oppdaterte `.meta`-filen. `meta git update` kloner manglende
repoer og oppdaterer eksisterende repoer med `git pull`.
Bruk `meta --dry-run git update` for å se planen uten å endre repoene.

Mer dokumentasjon: https://github.com/gitkb/meta#commands

### Opprettelse av nytt repo

Dette gjelder både for frontend og backend

#### Github

- Opprett repo
- Legg til Team tilleggstønader som admin under https://github.com/navikt/repo-navn/settings/access
- Legg til `branch rules` https://github.com/navikt/repo-navn/settings/branches
    - Require signed commits
    - Do not allow bypassing the above settings
- Settings:
    - `Allow auto-merge`
    - `Automatically delete head branches` efter PR
- Repository secrets
    - `SLACK_WEBHOOK_URL`
- Hvis appen skal deployes, autoriser appen
    - https://console.nav.cloud.nais.io/team/tilleggsstonader/repositories

#### tilleggstønader-repo

- Legg til `"<repo-navn>": "git@github.com:navikt/<repo-navn>.git"` under `projects` i [`.meta`](./.meta).
  Den nye pakken har ikke den gamle `meta project import`-kommandoen.
- Kjør `meta git update` for å klone repoet hvis det ikke finnes lokalt.
- Legg til repot i [Lenker til repo](#lenker-til-repo)
- Legg til repo i [settings.gradle.kts](./settings.gradle.kts)

### Lenker til repo

Repoene som er inkludert i dette meta-repoet er

- [tilleggsstonader-arena](https://github.com/navikt/tilleggsstonader-arena)
- [tilleggsstonader-brev-sanity](https://github.com/navikt/tilleggsstonader-brev-sanity)
- [tilleggsstonader-docs](https://github.com/navikt/tilleggsstonader-docs)
- [tilleggsstonader-htmlify](https://github.com/navikt/tilleggsstonader-htmlify)
- [tilleggsstonader-integrasjoner](https://github.com/navikt/tilleggsstonader-integrasjoner)
- [tilleggsstonader-klage](https://github.com/navikt/tilleggsstonader-klage)
- [tilleggsstonader-kontrakter](https://github.com/navikt/tilleggsstonader-kontrakter)
- [tilleggsstonader-libs](https://github.com/navikt/tilleggsstonader-libs)
- [tilleggsstonader-sak](https://github.com/navikt/tilleggsstonader-sak)
- [tilleggsstonader-sak-frontend](https://github.com/navikt/tilleggsstonader-sak-frontend)
- [tilleggsstonader-slackbot](https://github.com/navikt/tilleggsstonader-slackbot)
- [tilleggsstonader-soknad](https://github.com/navikt/tilleggsstonader-soknad)
- [tilleggsstonader-soknad-api](https://github.com/navikt/tilleggsstonader-soknad-api)
