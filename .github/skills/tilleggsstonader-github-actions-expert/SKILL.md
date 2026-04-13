---
name: tilleggsstonader-github-actions-expert
description: >-
  Ekspert på GitHub Actions for tilleggsstønader: shared workflows/actions i
  navikt/tilleggsstonader (som brukes av de andre repoene i teamet), minst
  mulige permissions, pinning av eksterne actions med GitHub CLI,
  batch-oppdateringer på tvers av teamets repos.
user-invocable: true
---

# Tilleggsstønader GitHub Actions Expert

Bruk denne skillen når du skal oppdatere, standardisere eller feilsøke GitHub Actions for teamet `navikt/tilleggsstonader`.

## Viktigste regler

1. **Alltid sett `permissions` eksplisitt** i workflows (toppnivå eller per jobb). Ingen implicit defaults.
2. **Minimer rettigheter**: start med `contents: read` og legg kun til det som trengs.
3. **Gjenbruk sentrale workflows/actions fra hovedrepo** `navikt/tilleggsstonader`.
4. **Ikke pin reusable workflows fra `navikt/tilleggsstonader`**: behold `@main` for `uses: navikt/tilleggsstonader/.github/workflows/*.yml@main`.
5. **Ikke pin lokale workflow-kall**: `uses: ./.github/workflows/...` skal ikke pinnes


## Sentral kilde for delte workflows/actions

Hovedrepoet for delbare workflows og actions er:

- `navikt/tilleggsstonader`

Dette repoet er den sentrale kilden for delte GitHub Actions/workflows som de
andre tilleggsstønader-repoene gjenbruker.

Typiske referanser:

- `uses: navikt/tilleggsstonader/.github/workflows/java-build-and-test.yml@main`
- `uses: navikt/tilleggsstonader/.github/workflows/java-build-and-deploy.yml@main`
- `uses: navikt/tilleggsstonader/.github/workflows/ts-build.yml@main`
- `uses: navikt/tilleggsstonader/.github/actions/attest-sign@main`

## Repos i tilleggsstønader som bruker GitHub Actions

Følgende repos er identifisert med `.github/workflows`:

- `navikt/tilleggsstonader`
- `navikt/tilleggsstonader-arena`
- `navikt/tilleggsstonader-brev-sanity`
- `navikt/tilleggsstonader-htmlify`
- `navikt/tilleggsstonader-integrasjoner`
- `navikt/tilleggsstonader-klage`
- `navikt/tilleggsstonader-kontrakter`
- `navikt/tilleggsstonader-libs`
- `navikt/tilleggsstonader-sak`
- `navikt/tilleggsstonader-sak-frontend`
- `navikt/tilleggsstonader-slackbot`
- `navikt/tilleggsstonader-soknad`
- `navikt/tilleggsstonader-soknad-api`

Ved nye batchjobber: verifiser listen først med GitHub CLI før du starter endringer

## Minste nødvendige permissions (policy)

Bruk disse som standard:

- Kun bygg/test: `permissions: { contents: read }`
- OIDC/NAIS login: legg til `id-token: write`
- Opprette PR/commit (f.eks. digestabot): legg til `contents: write`, `pull-requests: write`
- Code scanning uploads: legg til `security-events: write`
- Publisering av pakker: legg til `packages: write`

Eksempel:

```yaml
permissions:
  contents: read
```


## Pinning av actions med GitHub CLI

Når du skal pinne actions til commit SHA, bruk `gh-act`.

Viktig policy:

- **Pin eksterne actions** (f.eks. `actions/checkout`, `nais/deploy/actions/deploy`, `navikt/digestabot`).
- **Ikke pin reusable workflows fra `navikt/tilleggsstonader/.github/workflows/`**. Disse skal normalt stå på `@main`.
- **Ikke pin lokale workflow-kall** (`uses: ./.github/workflows/...`).

```bash
gh extension install navikt/gh-act
gh act pin
git add .
git commit -m "pin workflow action references to commit SHAs"
```

## Oppdatering av pinnede versjoner

Hvordan pinnede versjoner oppdateres når man gjør vedlikehold i et repo:

1. Oppgrader GitHub CLI-extensions.
2. Kjør `gh act update --pin` for å oppdatere SHA-er og trailing kommentar (`# vX`).
3. Commit kun hvis kommandoen ga faktiske filendringer.

Anbefalt kommandosekvens:

```bash
gh extension upgrade --all
gh act update --pin
git add .github/workflows
git diff --cached --quiet || git commit -m "⬆️ oppdater pinnede GitHub Actions-referanser"
```

Prinsipp:
- Ikke manuelt rediger SHA + `# vX`-linjer når dette kan håndteres av `gh act update --pin`.
- Fortsett å pinne eksterne actions, men behold reusable workflows fra `navikt/tilleggsstonader/.github/workflows/*@main`.

## Arbeidsstil for denne skillen

- Oppdater alle relevante repos, ikke bare ett.
- Sørg for at `permissions` alltid finnes i workflows som berøres.
- Hold endringene små, trygge og like på tvers av repos.
- Favoriser sentrale, delte workflows fra `navikt/tilleggsstonader`.
