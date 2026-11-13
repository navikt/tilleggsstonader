# Tilleggsstønader

Dette er rotrepoet som samler teamets repoer. Følg også `.github/copilot-instructions.md` og instruksene i repoet du endrer.

## Dataflyt for søknad

`soknad` → `soknad-api` → arkivering via `integrasjoner` → journalposthendelse på Kafka → `sak` → fakta-API → `sak-frontend`. Det er ikke et direkte søknadskall fra søknad-api til sak.

### Legge til et felt

Stiene er relative til repoet i første kolonne. `<…>` og `*` markerer søknadsspesifikke filer.

| Repo | Filer som må vurderes for endring |
|---|---|
| `tilleggsstonader-soknad` | Type i `src/frontend/<søknad>/typer/*.ts`, spørsmål og validering i `src/frontend/<søknad>/steg/`, tekster i `src/frontend/<søknad>/tekster/` og søknadens oppsummeringskomponent. |
| `tilleggsstonader-soknad-api` | Mottaks-DTO og mapper i `src/main/kotlin/no/nav/tilleggsstonader/soknad/soknad/<søknad>/`. |
| `tilleggsstonader-kontrakter` | Feltets kontraktsklasse i `kontrakter-felles/main/kotlin/no/nav/tilleggsstonader/kontrakter/søknad/<søknad>/`. |
| `tilleggsstonader-sak` | Skjemamodell og mapper i `src/main/kotlin/no/nav/tilleggsstonader/sak/opplysninger/søknad/<søknad>/`, samt `src/main/kotlin/no/nav/tilleggsstonader/sak/behandling/fakta/BehandlingFaktaDto.kt` og `src/main/kotlin/no/nav/tilleggsstonader/sak/behandling/fakta/BehandlingFaktaService.kt`. |
| `tilleggsstonader-sak-frontend` | `src/frontend/typer/behandling/behandlingFakta/fakta<Søknad>.ts` og `src/frontend/Sider/Behandling/Venstremeny/Oppsummering/Oppsummering<Søknad>.tsx`. |

### Transport mellom repoene

Disse filene forklarer overføringen og trenger normalt ikke endres for et nytt felt i et eksisterende skjema:

| Repo | Relevante filer |
|---|---|
| `tilleggsstonader-soknad-api` | `src/main/kotlin/no/nav/tilleggsstonader/soknad/soknad/SøknadController.kt` mottar DTO-en. `src/main/kotlin/no/nav/tilleggsstonader/soknad/soknad/SkjemaService.kt` mapper og lagrer kontrakts-JSON og starter tasks. |
| `tilleggsstonader-soknad-api` | `src/main/kotlin/no/nav/tilleggsstonader/soknad/prosessering/LagPdfTask.kt` → `src/main/kotlin/no/nav/tilleggsstonader/soknad/prosessering/ArkiverSøknadTask.kt` → `src/main/kotlin/no/nav/tilleggsstonader/soknad/arkivering/ArkiveringService.kt`: JSON, PDF og vedlegg arkiveres via integrasjoner. |
| `tilleggsstonader-sak` | `src/main/kotlin/no/nav/tilleggsstonader/sak/hendelser/journalføring/JournalhendelseKafkaListener.kt` mottar journalposthendelsen og oppretter tasken i `src/main/kotlin/no/nav/tilleggsstonader/sak/hendelser/journalføring/JournalhendelseKafkaHåndtererTask.kt`. |
| `tilleggsstonader-sak` | `src/main/kotlin/no/nav/tilleggsstonader/sak/journalføring/JournalpostService.kt` henter originaldokumentet via integrasjoner. `src/main/kotlin/no/nav/tilleggsstonader/sak/journalføring/SøknadsskjemaUtil.kt` parser kontrakts-JSON før søknadsmappingen. |
