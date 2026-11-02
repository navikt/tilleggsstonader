---
name: oppdatere-vilkartekster
description: Oppdater vilkårtekster (inngangsvilkår og stønadsvilkår) i sak-frontend og htmlify, og generer nye eksempler på internt vedtak i sak. Bruk når en tekst, label, legend eller spørsmål om et vilkår, en vilkårperiode eller en vurdering skal endres eller byttes ut, også i internt vedtak.
---

# Oppdatere vilkårtekster

En endring i en vilkårtekst berører tre repoer. Gjør dem i denne rekkefølgen.
Skillen committer, pusher og lager aldri PR. Brukeren gjør det selv.

Forutsetning: repoene ligger side om side i meta-repoet
(`tilleggsstonader-sak`, `tilleggsstonader-sak-frontend`, `tilleggsstonader-htmlify`).
Stier under er relative til meta-repoets rot.

## Forutsetninger for sandbox

Skillen kjøres alltid i cplt-sandbox. Sandboxen blokkerer flere kommandoer, og
innstillingene kan bare endres av brukeren utenfor sandboxen. Sjekk dette før steg 1,
og be brukeren fikse manglene før du går videre:

| Behov | Sandbox-oppførsel | Løsning |
|---|---|---|
| `yarn` | Feiler med `EPERM` på `~/.yarnrc` | Bruk `node_modules/.bin/...` direkte (se under) |
| `node_modules` mangler i htmlify | Kan ikke kjøre `yarn install` | Brukeren kjører `yarn install` utenfor sandboxen |
| PDF-generering i steg 5 | Kaller `familie-dokument.intern.dev.nav.no`, som cplt blokkerer | Brukeren kjører `cplt config set proxy.allow_private_domains familie-dokument.intern.dev.nav.no` (naisdevice må være på) |
| `idea format` i steg 6 | IntelliJ kan ikke åpnes | Bruk IntelliJs MCP-server (`reformat_file`), ellers be brukeren kjøre `Reformat Code` |
| `git fetch origin` i steg 3 | Feiler med tilgangsfeil | Bruk GitHub MCP-serveren, se steg 3 |
| `pkill`, `timeout` | Ikke tillatt / finnes ikke | Bruk `kill <PID>` med PID fra `lsof -ti :8001` |

Blokkeres hosten, står feilmeldingen som tekst i de genererte `.pdf`-filene (ca. 145 byte).

Kommandoer i htmlify uten yarn:

- Lint: `node_modules/.bin/eslint 'src/**/*'` (`--fix` retter prettier-advarsler)
- Start: `NODE_ENV=development node_modules/.bin/tsx src/server.ts`

## 0. Avklar endringen

Be om gammel og ny tekst hvis brukeren ikke har oppgitt dem. Spør også hvilke
stønadstyper og vilkår endringen gjelder, hvis det ikke er tydelig.

Lag et regulært uttrykk for den nye teksten som brukes til å verifisere i steg 2 og 7,
for eksempel `Er utgiften nødvendig`. Skriv det uten `?` og `:` på slutten, så det treffer
både frontend og internt vedtak.

## 1. Finn og oppdater teksten i sak-frontend

Søk i hele `tilleggsstonader-sak-frontend/src/frontend` etter teksten brukeren oppgir.
Prøv hele setningen, deretter nøkkelord, og søk både med og uten `?` og `:` på slutten.
Teksten kan ligge i stønadsspesifikke mapper, for eksempel
`Sider/Behandling/Stønadsvilkår/<Stønadstype>/EndreFakta/`. Vanlige steder:

- `Sider/Behandling/Vilkårvurdering/tekster.ts`
- `Sider/Behandling/Inngangsvilkår/Vilkårperioder/VilkårperiodeKort/tekstmapping.ts`
- `Sider/Behandling/Inngangsvilkår/Målgruppe/hjelpetekstVurdereMålgruppe.ts`

Vis treffene og bekreft hvilke som skal endres hvis det er flere eller uklare treff.
Finner du ingenting, stopp og spør brukeren. Ikke gjett.

## 2. Finn og oppdater tilhørende tekst i htmlify

Søk i `tilleggsstonader-htmlify/src/internt-vedtak` (særlig `typer/`, `vilkårperioder/`,
`VilkårContent.tsx`, `VilkårFakta.tsx`) etter samme tekst. Teksten i internt vedtak
kan være formulert annerledes enn i frontend, så søk også på nøkkelord og enum-navn.

Søk også i `tilleggsstonader-sak/src/main` (særlig `RegelId.kt`, parameteren
`beskrivelse`). Spørsmålstekster for vilkårregler står både i `tekster.ts` i frontend og
i `RegelId.kt`. Strengen kan være brutt over flere linjer, så søk på en kort del av den.
Teksten fra `RegelId.kt` havner i `internt_vedtak.json` (feltet `regel`) og i html.

Treff i `RegelId.kt` og frontend, men ikke i htmlify, er normalt for regelspørsmål.
htmlify viser `regel` som den er, og trenger ingen endring. Si fra til brukeren om det
og gå videre. Finner du ingenting i htmlify og heller ikke i `RegelId.kt` eller
`internt_vedtak.json`, stopp og spør brukeren om htmlify skal endres eller hoppes over.

Er teksten bare i frontend (ingen treff i htmlify, `RegelId.kt` eller eksemplene i sak),
hopp over steg 3 til 7 og si fra om det i rapporten.

Endres kontrakten mot sak (`typer/`) eller `RegelId.kt`, må
`tilleggsstonader-sak/src/test/resources/interntVedtak/*/internt_vedtak.json`
oppdateres. Test med `json til htmlify er riktig`. Ikke bruk `SKRIV_TIL_FIL=true` for å
skrive json-filene: de committede filene er ikke sortert slik testen skriver dem, så
diffen blir flere hundre linjer per fil. Bytt i stedet bare den gamle teksten med den nye
i berørte `internt_vedtak.json` (testen sammenligner semantisk).

Kjør også regeltestene i sak når `RegelId.kt` er endret:
`./gradlew cleanTest test --tests "no.nav.tilleggsstonader.sak.vilkår.stønadsvilkår.regler.*"`.

Søk også etter teksten i `tilleggsstonader-docs` og i `.feature`-filer i sak, og si fra
om treff uten å endre dem.

Før du endrer noe, lag en samlet liste over alle treff på den gamle teksten i
frontend, htmlify og `interntVedtak/*/internt_vedtak.html`:

```bash
grep -rn -I --exclude='.env*' "<gammel tekst>" tilleggsstonader-sak-frontend/src tilleggsstonader-htmlify/src \
  tilleggsstonader-sak/src/test/resources/interntVedtak
```

`--exclude='.env*'` hindrer «Operation not permitted» fra sandboxen
(`tilleggsstonader-sak-frontend/src/backend/.env`).

Etter at hele skillen er kjørt (og alle `internt_vedtak.html` er regenerert), skal samme
søk ikke gi treff i frontend og htmlify. I html-filene skal treff finnes bare for
stønadstyper som ikke berøres. Gjenstående treff i frontend eller htmlify betyr at en
forekomst er glemt.

Kjør lint i `tilleggsstonader-htmlify` etter endringen. Blir en tekst kortere, slår
prettier ofte sammen linjer. Kjør da `eslint --fix` på filen og lint på nytt.

```bash
cd tilleggsstonader-htmlify
node_modules/.bin/eslint 'src/**/*'
```

## 3. Sjekk at htmlify er oppdatert

Bruk GitHub MCP-serveren som standard, siden `git fetch` normalt feiler i sandboxen:

Steget er uavhengig av steg 1 og 2, så MCP-kallet og `rev-parse` kan kjøres i samme
batch som tekstendringene.

1. Les lokal commit: `git -C tilleggsstonader-htmlify rev-parse HEAD`.
2. Kall `github-mcp-server-get_file_contents` med `owner: navikt`,
   `repo: tilleggsstonader-htmlify`, `path: .nvmrc`, `ref: refs/heads/main`.
   Bruk `.nvmrc` (to tegn), ikke `package.json`, som gir et langt svar.
   Commit-SHA for `main` står i resource-URI-en i svaret
   (`repo://navikt/tilleggsstonader-htmlify/sha/<SHA>/contents/.nvmrc`). Filens
   egen «SHA» i teksten er en annen verdi og skal ikke brukes.
3. Sjekk om main-commiten finnes lokalt og er en forgjenger av `HEAD`:

   ```bash
   git -C tilleggsstonader-htmlify merge-base --is-ancestor <SHA> HEAD && echo OK
   ```

   Er kommandoen OK (inkludert når SHA-ene er like), er grenen à jour. Lokale commits
   foran `main` er greit. Feiler den (commiten mangler lokalt eller er ikke en
   forgjenger), mangler brukeren noe fra origin: stopp og be brukeren hente nyeste
   versjon (`git pull`). Ikke pull eller stash selv. Lokale endringer fra steg 2 er
   forventet.

Feiler MCP-kallet, prøv `git -C tilleggsstonader-htmlify fetch origin` og
`git -C tilleggsstonader-htmlify status -sb`. Feiler også dette, fortsett, men ta med i
rapporten at dette ikke ble sjekket.

## 4. Start htmlify lokalt

Start først når lint er grønt. `tsx` uten `watch` leser ikke nye endringer, så
restart tjenesten hvis du endrer htmlify etter oppstart.

Start tjenesten i bakgrunnen med `nohup` i en subshell, så kommandoen returnerer med en
gang. Dette fungerte bedre enn async-modus i verktøyet:

```bash
cd tilleggsstonader-htmlify
(NODE_ENV=development nohup node_modules/.bin/tsx src/server.ts > /tmp/htmlify.log 2>&1 &)
sleep 6; lsof -ti :8001
```

Tjenesten lytter på port 8001. `lsof -ti :8001` gir PID. Du stopper tjenesten med `kill <PID>` med PID som
tall (`kill $(...)`, variabler og `pkill` er ikke tillatt).
Verifiser før du går videre:

```bash
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8001/
```

Alt annet enn tilkoblingsfeil (selv 404) betyr at tjenesten kjører.

## 5. Generer internt vedtak i sak

```bash
cd tilleggsstonader-sak
SKRIV_TIL_FIL=true ./gradlew cleanTest test --tests \
  "no.nav.tilleggsstonader.sak.interntVedtak.InterntVedtakGenereringTest.lag html og pdf"
```

Testen skriver `internt_vedtak.html` og `internt_vedtak.pdf` for hver stønadstype
under `src/test/resources/interntVedtak/<STØNADSTYPE>/`.

Miljøvariabelen er `SKRIV_TIL_FIL` (se `FileUtil.kt`). Testkommentaren nevner
`SKAL_SKRIVE_TIL_FIL`, som ikke leses av koden. `cleanTest` er nødvendig: uten den
kan Gradle hoppe over testen som «up-to-date», og ingenting blir generert.

Ikke rediger `internt_vedtak.html` for hånd (for eksempel med `sed`). Filene skal
bare genereres.

Forvent en stor html-diff (ca. 1000 linjer lagt til og 3700 fjernet totalt) før
formatering i steg 6. Det er uformatert output, ikke en feil.

Sjekk PDF-ene umiddelbart, siden testen er grønn også når PDF-genereringen feiler:

```bash
git -C tilleggsstonader-sak diff --stat -- '*.pdf'
```

Er en PDF under 1 KB (feilmeldingen er ca. 145 byte), ble den ikke generert. Tilbakestill alle PDF-er med
`git -C tilleggsstonader-sak checkout -- 'src/test/resources/interntVedtak/*/internt_vedtak.pdf'`
og si fra i rapporten at PDF-ene må genereres på nytt etter at brukeren har åpnet for
hosten (se «Forutsetninger for sandbox»).

Stopp htmlify med `kill <PID>` når genereringen er ferdig.

## 6. Formater html-filene i IntelliJ

Bruk skriptet `format-html.sh` ved siden av denne filen. Det kaller IntelliJs
MCP-verktøy `reformat_file`, som bruker prosjektets kodestil og gir samme resultat som
`Reformat Code`. Etter formatering faller diffen fra ca. 600 linjer til noen få linjer
per fil.

```bash
.github/skills/oppdatere-vilkartekster/format-html.sh "$PWD/tilleggsstonader-sak"
```

Forutsetninger (utenom sandboxen, gjøres av brukeren):

- IntelliJ kjører med `tilleggsstonader-sak` åpent som prosjekt.
- `Settings | Tools | MCP Server` er slått på. Er porten en annen enn 64342, sett
  `IJ_MCP_URL` (se `Copy Config` i samme innstilling).
- Sandboxen tillater localhost mot IntelliJ (`sandbox.allow_localhost_any true`).

Skriptet venter noen sekunder først, fordi IntelliJ ikke alltid har oppdatert filer som
Gradle nettopp skrev. `reformat_file` svarer `ok` selv når den ikke har formatert en fil,
så skriptet kontrollerer diffen etterpå. Filer med mer enn 50 endrede linjer regnes som
uformaterte, og skriptet formaterer dem på nytt (opptil tre ganger). Exit-kode 0 betyr at
alle filene er formatert.

Er IntelliJ-verktøyet registrert i Copilot CLI, kan du i stedet kalle `reformat_file`
direkte, men husk å kontrollere diffen selv.

Svarer ikke MCP-serveren, eller gir skriptet exit-kode 1, be brukeren kjøre
`Reformat Code` på hver
`tilleggsstonader-sak/src/test/resources/interntVedtak/*/internt_vedtak.html`, og vent på
bekreftelse. `idea format` og `prettier` er ikke alternativer: `idea format` virker ikke i
sandboxen, og `prettier` gir et format som avviker fra IntelliJ (over 1000 linjer diff per fil).

## 7. Verifiser

Genereringen gir en annerledes PDF (ca. 100 byte forskjell, trolig intern ID eller
tidsstempel) også for stønadstyper der teksten ikke er berørt. Genereringen gir også en
ekstra tom linje i `<style>` i alle html-filene, fordi de committede filene er eldre enn
dagens htmlify. Begge deler er støy som ikke hører til endringen.

Tilbakestill html og PDF for stønadstyper der den nye teksten ikke finnes i html-diffen.
Bruk det regulære uttrykket fra steg 0 som `NY_TEKST`, for eksempel
`NY_TEKST="Er utgiften nødvendig"`:

```bash
NY_TEKST="<regulært uttrykk fra steg 0>"
cd tilleggsstonader-sak/src/test/resources/interntVedtak
for d in */; do
  git diff -U0 -- "$d/internt_vedtak.html" | grep -q "^+.*$NY_TEKST" \
    || git checkout -- "$d/internt_vedtak.html" "$d/internt_vedtak.pdf"
done
```

Kontroller så diffen:

```bash
git -C tilleggsstonader-sak diff --stat
```

Diffen skal tilsvare tekstendringen: bare berørte stønadstyper, med både html og PDF.
En stor diff i html-filene betyr normalt manglende eller feil formatering.
Kjør deretter uten `SKRIV_TIL_FIL`. Bruk `cleanTest`, ellers kan Gradle hoppe over testen:

```bash
cd tilleggsstonader-sak && ./gradlew cleanTest test --tests "no.nav.tilleggsstonader.sak.interntVedtak.*"
```

## 8. Rapporter

List endrede filer per repo og minn brukeren på at ingenting er committet:

- `tilleggsstonader-sak-frontend`: tekstfiler
- `tilleggsstonader-htmlify`: komponenter/typer
- `tilleggsstonader-sak`: `RegelId.kt` (hvis regeltekst), og `internt_vedtak.html`, `.pdf` og `.json` for berørte stønadstyper (alle skal committes)

Ta også med avvik: PDF-er som ikke ble generert, at htmlify-sjekken i steg 3 ikke
kunne gjøres, og eventuelle treff i docs eller `.feature`-filer.

Det blir én commit/PR per repo.
