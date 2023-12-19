# Database

## Tilgang til databasen

### Første gang

1.  Følg installasjonsbeskrivelse på https://doc.nais.io/cli/install/
2.  Gi deg selv tilgang (sørg for å stå i rett context og namespace):

```shell
nais postgres grant tilleggsstonader-sak
```

<details>
<summary>ℹ️ Bytt context og namespace</summary>

1. Bytt til rett context:

    ```shell
    kubectl config use-context dev-gcp
    ```

2. Bytt til rett namespace:
    ```shell
    kubectl config set-context --current --namespace=tilleggsstonader
    ```
3. Gi deg selv tilgang:
   `shell
nais postgres grant tilleggsstonader-sak
`
   </details>

<details>
<summary>🧠 Forenklet script som kan legges inn i `~\.zshrc`</summary>

```shell
db-ny(){
    echo "Logger på"
    gcloud auth login --update-adc

    CONTEXT="${1:-dev-gcp}"
    echo "Kobler til context ${CONTEXT}"
    kubectl config use-context $CONTEXT

    echo "Kobler til namespace tilleggsstonader"
    kubectl config set-context --current --namespace=tilleggsstonader

    DATABASE="${2:-tilleggsstonader-sak}"
    echo "Ber om tilgang til ${DATABASE}"
    nais postgres grant $DATABASE
}
```

Brukes slik:

```shell
db-ny dev-gcp tilleggsstonader-sak
```

</details>

### Koble til en database

Bruk følgende kommando for å koble deg til en database:

```shell
nais postgres proxy --context dev-gcp --namespace tilleggsstonader --port 5700 tilleggsstonader-sak
```

<details>
<summary>🧠 Forenklet script som kan legges inn i `~\.zshrc`</summary>

```shell
db-dev() {
    echo "Logger på"
    gcloud auth login --update-adc

    DATABASE="${2:-tilleggsstonader-sak}"
    PORT="${3:-5700}"

    echo "Kobler til ${DATABASE} på port ${PORT}"
    nais postgres proxy --context dev-gcp --namespace tilleggsstonader -port $PORT $DATABASE
}

db-prod() {
    echo "Logger på"
    gcloud auth login --update-adc

    DATABASE="${1:-tilleggsstonader-sak}"
    PORT="${2:-5800}"

    echo "Kobler til ${DATABASE} på port ${PORT}"
    nais postgres proxy --context prod-gcp --namespace tilleggsstonader -port $PORT $DATABASE
}
```

Eksempel på bruk uten defaultverdier:

```shell
db-dev tilleggsstonader 5700
```

</details>

## Databaseoppsett

Vanligvis så trenger man å bruke `nais postgres prepare appname` for å faktiskt få tilgang til tabeller i databasen.
Det trengs ikke dersom man legger inn dette i en migrering eller kjører direkt i basen:

```sql
DO $$
    BEGIN
        IF EXISTS
            ( SELECT 1 from pg_roles where rolname='cloudsqliamuser')
        THEN
            GRANT SELECT ON ALL TABLES IN SCHEMA public TO cloudsqliamuser;
            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO cloudsqliamuser;
        END IF ;
    END
$$ ;
```

For `dev` kan man legge inn skriverettigheter:

```sql
DO $$
    BEGIN
        IF EXISTS
            ( SELECT 1 from pg_roles where rolname='cloudsqliamuser')
        THEN
            GRANT ALL ON ALL TABLES IN SCHEMA public TO cloudsqliamuser;
            ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO cloudsqliamuser;
        END IF ;
    END
$$ ;
```
