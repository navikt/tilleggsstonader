# Database

## Koble seg på databasen
* Følg installasjonsbeskrivelse på https://doc.nais.io/cli/
* Gi seg selv tilgang, en gang per context/database
    * `nais postgres --context dev-gcp --namespace tilleggsstonader grant tilleggsstonader-sak`
* Koble seg på databasen, man trenger ikke noe passord
    * `nais postgres proxy --context dev-gcp --namespace tilleggsstonader --port 5700 tilleggsstonader-sak`
    * Det er fint hvis man bruker ulike ports for ulike contexts/databaser, eks port 5701 for prod, og setter opp en config i intellij per miljø/database.


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
