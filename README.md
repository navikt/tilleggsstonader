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

### Opprettelse av nytt repo

Dette gjelder både for frontend og backend

#### Github
* Opprett repo
* Repository secrets
  * NAIS_DEPLOY_APIKEY
  * SLACK_WEBHOOK_URL
* Kjør `meta project import <repo-navn> git@github.com:navikt/<repo-navn>`
* Legg til repot i [Lenker til repo](#lenker-til-repo) 
* Legg til repo i [settings.gradle.kts](./settings.gradle.kts)

### Lenker til repo
Repoene som er inkludert i dette meta-repoet er

- [tilleggsstonader-soknad] (https://github.com/navikt/tilleggsstonader-soknad)
- [tilleggsstonader-soknad-api] (https://github.com/navikt/tilleggsstonader-soknad-api)
