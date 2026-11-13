# Agents Instructions – Tilleggsstønader

## Oversikt

Dette er et meta-repo (via [meta fra gitkb](https://github.com/gitkb/meta)) som samler alle repoene til team tilleggsstønader. Vi bruker Rust-implementasjonen, installert med `brew install gitkb/tap/meta-cli`, ikke npm-pakken `meta`. Repoene er definert i `.meta`. Nye repoer legges til der og klones med `meta git update`; `meta project import` støttes ikke. Hvert sub-prosjekt er et selvstendig Git-repo inkludert som Gradle composite build via `settings.gradle.kts`.

### Sub-prosjekter

- **tilleggsstonader-sak** – Hovedbackend for saksbehandling (Spring Boot)
- **tilleggsstonader-sak-frontend** – Saksbehandler-frontend (React)
- **tilleggsstonader-soknad** – Søknadsdialog for innbyggere (React)
- **tilleggsstonader-soknad-api** – Backend for søknadsinnsending (Spring Boot)
- **tilleggsstonader-integrasjoner** – Sentralt integrasjonspunkt mot eksterne tjenester (Spring Boot)
- **tilleggsstonader-klage** – Klagebehandling (Spring Boot)
- **tilleggsstonader-arena** – Arena-integrasjon, kjører i FSS-kluster (Spring Boot, Oracle DB)
- **tilleggsstonader-kontrakter** – Delt bibliotek med DTOer/kontrakter (publisert til GitHub Packages)
- **tilleggsstonader-libs** – Delt bibliotek med fellesmoduler: util, log, sikkerhet, http-client, kafka, unleash, spring
- **tilleggsstonader-htmlify** – Node-tjeneste for HTML→dokument-konvertering (Express + React SSR)
- **tilleggsstonader-brev-sanity** – Sanity CMS studio for brevmaler
- **tilleggsstonader-docs** – Dokumentasjonsside (Docusaurus)
- **tilleggsstonader-slackbot** – Slack-integrasjonsbot

### Delte biblioteker

- **tilleggsstonader-libs** inneholder moduler som brukes på tvers: `util`, `log`, `sikkerhet`, `http-client`, `kafka`, `unleash`, `spring`
- HTTP-klienter har forhåndskonfigurerte auth-flows: `tokenExchange`, `azureClientCredential`, `azureOnBehalfOf`
- Feature toggles via Unleash: `Toggle.TOGGLE_NAVN`

## Team tilleggsstønader

GitHub-brukernavn til teamet. Bruk dem ved @-omtaler, reviewer-forslag og CODEOWNERS.

| Navn              | GitHub        |
| ----------------- | ------------- |
| Sigmund Berbom    | @sberbom      |
| Sara Hjelle       | @sarahjelle   |
| William Andersson | @anderssonw   |
| Nibedita Pahari   | @Nibeditanav  |
| Adnan Vrevic      | @Adnan-Vrevic |
| Andreas Strand    | @AStrand94    |

## Commits og PR-er

- Skriv på **norsk**.
- Beskriv domeneendringen, ikke det tekniske.
- Mottakeren kjenner domenet og repoene. Ikke forklar begreper, ikke gjenta kontekst som ligger i koden.
- Commit: én linje, helst under 72 tegn. Brødtekst bare når «hvorfor» ikke er opplagt.
- PR: en til tre setninger. Ingen oppsummering av diffen, ingen filliste, ingen «Testing»-seksjon med mindre noe avviker fra det vanlige.
- Ingen fyllord eller innledning («Denne PR-en introduserer ...»). Start med endringen.
- Kjør `./gradlew spotlessApply` (backend) eller `yarn lint` (frontend) før commit

## Dataflyt for søknad

`soknad` → `soknad-api` → arkivering via `integrasjoner` → journalposthendelse på Kafka → `sak` → fakta-API → `sak-frontend`. Det er ikke et direkte søknadskall fra søknad-api til sak.

### Legge til et felt

Stiene er relative til repoet i første kolonne. `<…>` og `*` markerer søknadsspesifikke filer.

| Repo                            | Filer som må vurderes for endring                                                                                                                                                                                                                                                            |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tilleggsstonader-soknad`       | Type i `src/frontend/<søknad>/typer/*.ts`, spørsmål og validering i `src/frontend/<søknad>/steg/`, tekster i `src/frontend/<søknad>/tekster/` og søknadens oppsummeringskomponent.                                                                                                           |
| `tilleggsstonader-soknad-api`   | Mottaks-DTO og mapper i `src/main/kotlin/no/nav/tilleggsstonader/soknad/soknad/<søknad>/`.                                                                                                                                                                                                   |
| `tilleggsstonader-kontrakter`   | Feltets kontraktsklasse i `kontrakter-felles/main/kotlin/no/nav/tilleggsstonader/kontrakter/søknad/<søknad>/`.                                                                                                                                                                               |
| `tilleggsstonader-sak`          | Skjemamodell og mapper i `src/main/kotlin/no/nav/tilleggsstonader/sak/opplysninger/søknad/<søknad>/`, samt `src/main/kotlin/no/nav/tilleggsstonader/sak/behandling/fakta/BehandlingFaktaDto.kt` og `src/main/kotlin/no/nav/tilleggsstonader/sak/behandling/fakta/BehandlingFaktaService.kt`. |
| `tilleggsstonader-sak-frontend` | `src/frontend/typer/behandling/behandlingFakta/fakta<Søknad>.ts` og `src/frontend/Sider/Behandling/Venstremeny/Oppsummering/Oppsummering<Søknad>.tsx`.                                                                                                                                       |

### Transport mellom repoene

Disse filene forklarer overføringen og trenger normalt ikke endres for et nytt felt i et eksisterende skjema:

| Repo                          | Relevante filer                                                                                                                                                                                                                                                                                        |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `tilleggsstonader-soknad-api` | `src/main/kotlin/no/nav/tilleggsstonader/soknad/soknad/SøknadController.kt` mottar DTO-en. `src/main/kotlin/no/nav/tilleggsstonader/soknad/soknad/SkjemaService.kt` mapper og lagrer kontrakts-JSON og starter tasks.                                                                                  |
| `tilleggsstonader-soknad-api` | `src/main/kotlin/no/nav/tilleggsstonader/soknad/prosessering/LagPdfTask.kt` → `src/main/kotlin/no/nav/tilleggsstonader/soknad/prosessering/ArkiverSøknadTask.kt` → `src/main/kotlin/no/nav/tilleggsstonader/soknad/arkivering/ArkiveringService.kt`: JSON, PDF og vedlegg arkiveres via integrasjoner. |
| `tilleggsstonader-sak`        | `src/main/kotlin/no/nav/tilleggsstonader/sak/hendelser/journalføring/JournalhendelseKafkaListener.kt` mottar journalposthendelsen og oppretter tasken i `src/main/kotlin/no/nav/tilleggsstonader/sak/hendelser/journalføring/JournalhendelseKafkaHåndtererTask.kt`.                                    |
| `tilleggsstonader-sak`        | `src/main/kotlin/no/nav/tilleggsstonader/sak/journalføring/JournalpostService.kt` henter originaldokumentet via integrasjoner. `src/main/kotlin/no/nav/tilleggsstonader/sak/journalføring/SøknadsskjemaUtil.kt` parser kontrakts-JSON før søknadsmappingen.                                            |
