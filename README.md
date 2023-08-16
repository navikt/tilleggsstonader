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

For å legge til et nytt repo kan man skrive

```
meta project import tilleggsstonader-whatnot git@github.com:navikt/tilleggsstonader-whatnot
```

Se [meta](https://github.com/mateodelnorte/meta) for flere kommandoer.

Dersom du nå åpner `build.gradle` med `Open` (som Project) i IntelliJ så får du alle komponentene inn i ett
IntelliJ-oppsett.

Repoene som er inkludert i dette meta-repoet er

- [tilleggsstonader-soknad] (https://github.com/navikt/tilleggsstonader-soknad)
