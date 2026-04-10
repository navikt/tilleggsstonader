# Copilot Instructions – Tilleggsstønader

## Oversikt

Dette er et meta-repo (via [meta](https://github.com/mateodelnorte/meta)) som samler alle repoene til team tilleggsstønader. Hvert sub-prosjekt er et selvstendig Git-repo inkludert som Gradle composite build via `settings.gradle.kts`.

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

## Bygg, test og lint

### Kotlin-backends

Alle Kotlin-backends bruker Gradle wrapper. Kjør kommandoer fra det relevante sub-prosjektets rot.

```bash
./gradlew build                    # Bygg og kjør tester (inkl. lint)
./gradlew build -PskipLint         # Bygg uten lint
./gradlew test                     # Kun tester
./gradlew spotlessCheck            # Sjekk formatering (ktlint)
./gradlew spotlessApply            # Auto-formater kode
./gradlew bootJar                  # Bygg JAR (output: app.jar)
```

Kjør en enkelt test:
```bash
./gradlew test --tests "no.nav.tilleggsstonader.sak.vilkår.VilkårServiceTest"
```

### Frontend-prosjekter

Alle frontend-prosjekter bruker Yarn og Node 20 (se `.nvmrc`).

```bash
yarn install                       # Installer avhengigheter
yarn lint                          # Lint (ESLint + eventuelt stylelint)
yarn build                         # Bygg (inkl. lint)
yarn start:dev                     # Lokal utvikling
```

For `tilleggsstonader-soknad` finnes Playwright E2E-tester:
```bash
yarn playwright test                          # Alle E2E-tester
yarn playwright test tests/barnetilsyn.spec.ts  # Enkelt testfil
```

## Teknisk stack

### Backend
- **Kotlin 2.x**, **Java 21**, **Spring Boot 4.x**
- **Spring Data JDBC** (ikke JPA/Hibernate)
- **PostgreSQL** med **Flyway**-migrasjoner (`src/main/resources/db/migration/`)
- **Kafka** med Avro-serialisering
- **OAuth2/Azure AD** via `token-validation-spring`
- **Spotless** med **ktlint** for formatering

### Frontend
- **React 19**, **TypeScript 5.9+**, **Webpack 5**
- **NAV Aksel** designsystem (`@navikt/ds-react`, `@navikt/aksel-icons`)
- **Prettier** (100 bredde, 4 spaces, single quotes, trailing commas)
- **ESLint** (flat config) med typescript-eslint, react-hooks, import, jsx-a11y

## Arkitektur og konvensjoner

### Pakkestuktur (backend)

```
no.nav.tilleggsstonader.{prosjekt}/
├── App.kt                         # Applikasjonens entry point
├── behandling/                    # Kjernedomene: behandling av saker
├── behandlingsflyt/               # Stegmaskin / arbeidsflyt
├── vedtak/                        # Vedtakslogikk
├── vilkår/                        # Vilkårsvurderinger
├── utbetaling/                    # Utbetalingslogikk
├── brev/                          # Brevgenerering
├── opplysninger/                  # Datahenting (PDL, Arena, ytelser)
├── ekstern/                       # Eksterne integrasjoner
├── fagsak/                        # Fagsak-håndtering
├── felles/                        # Delte domeneklasser (value classes, IDer)
└── infrastruktur/                 # Database, sikkerhet, config, feilhåndtering
```

### Value classes for IDer

Alle domene-IDer er wrappet i `@JvmInline value class`. Bruk alltid disse – ikke rå `UUID` eller `String`.

```kotlin
@JvmInline
value class BehandlingId(val id: UUID)
```

Unngå `Pair` – lag egne value classes i stedet.

### Repository-mønster

Prosjektet bruker Spring Data JDBC med et tilpasset repository-grensesnitt som **deaktiverer `save()`** for å tvinge eksplisitt `insert()` eller `update()`:

```kotlin
@Repository
interface BehandlingRepository :
    RepositoryInterface<Behandling, BehandlingId>,
    InsertUpdateRepository<Behandling> {

    fun findByFagsakId(fagsakId: FagsakId): List<Behandling>
}
```

### Controller-mønster

```kotlin
@RestController
@RequestMapping("/api/ytelse")
@ProtectedWithClaims(issuer = "azuread")
class YtelseController(
    private val tilgangService: TilgangService,
    private val ytelseService: YtelseService,
) {
    @GetMapping("{fagsakPersonId}")
    fun hentYtelser(@PathVariable fagsakPersonId: FagsakPersonId): YtelserRegisterDto {
        tilgangService.validerTilgangTilFagsakPerson(fagsakPersonId, AuditLoggerEvent.ACCESS)
        return ytelseService.hentYtelser(fagsakPersonId)
    }
}
```

Nøkkelpunkter:
- Alltid valider tilgang via `TilgangService` før behandling
- Bruk `@ProtectedWithClaims(issuer = "azuread")` for interne endepunkter
- Bruk `@ProtectedWithClaims(issuer = ISSUER_TOKENX, claimMap = ["acr=Level4"])` for innbygger-endepunkter
- Returner DTOer, ikke domeneentiteter

### Feilhåndtering

Bruk `feilHvis()` og `brukerfeilHvis()` for validering – ikke kast exceptions direkte:

```kotlin
feilHvis(liste.isEmpty()) { "Fant ingen elementer" }
brukerfeilHvis(!erGyldig) { "Ugyldig input" }
```

- `feilHvis()` → systemfeil (HTTP 500, logges som ERROR)
- `brukerfeilHvis()` → brukerfeil (HTTP 400, logges som INFO)
- Sensitive meldinger sendes via `sensitivFeilmelding`-parameteren og logges kun i secure log

### DTO-konvensjoner

- Bruk `data class` for alle DTOer
- Delte kontrakter mellom tjenester plasseres i `tilleggsstonader-kontrakter`
- Bruk extension functions for mapping: `.tilDto()`, `.tilDomene()`
- Unngå `Pair` – lag egne data classes

### Dependency injection

Kun constructor injection. Ingen `@Autowired` på felt.

### Testing (backend)

- **Mockk** for mocking (ikke Mockito)
- **Testcontainers** med PostgreSQL for integrasjonstester
- **WireMock** for HTTP-mocking
- **MockOAuth2Server** for token-generering i tester
- Testnavn med backtick-syntaks: `` `skal filtrere bort inaktive fullmakter` ``
- Integrasjonstester arver fra `IntegrationTest` eller `CleanDatabaseIntegrationTest`
- `CleanDatabaseIntegrationTest` nullstiller alle tabeller mellom hver test
- Mock-profiler: `mock-arena`, `mock-pdl`, `mock-iverksett` osv.

### Frontend-konvensjoner

- **sak-frontend**: CSS Modules (`.module.css`) + styled-components for dynamisk styling
- **soknad**: Styled-components
- Komponentmapper i `komponenter/` eller `components/`
- Sidemapper i `Sider/`
- Hooks i `hooks/`
- Typer i `typer/`
- State: `constate` for enkel context, `@tanstack/react-query` for server-state

### Delte biblioteker

- **tilleggsstonader-libs** inneholder moduler som brukes på tvers: `util`, `log`, `sikkerhet`, `http-client`, `kafka`, `unleash`, `spring`
- HTTP-klienter har forhåndskonfigurerte auth-flows: `tokenExchange`, `azureClientCredential`, `azureOnBehalfOf`
- Feature toggles via Unleash: `Toggle.TOGGLE_NAVN`

## Kommunikasjon

- Skriv commit-meldinger og PR-beskrivelser på **norsk**
- Bruk relevant **gitmoji** i starten av commit-meldinger (✨ ny funksjonalitet, 🐛 bugfix, ♻️ refaktorering, ✅ tester, 📝 dokumentasjon)
- Fokuser på domeneendringer i commit-meldinger
- Kjør `./gradlew spotlessApply` (backend) eller `yarn lint` (frontend) før commit
