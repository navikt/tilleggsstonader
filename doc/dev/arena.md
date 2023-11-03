# Arena

## Analys av Arena

* Hvordan finner man om en søknad/sak/vedtak er ferdigstilt? 

### Sak
* Hvordan er egentlige saker oppdelt? Det virker som at en person kan ha flere saker
* Kolonnen `objekt_id` peker til person
  * Gjør den alltid det? `select distinct tabellnavnalias from sak;` (gir den noe mer enn `PERS`?)

### Vedtak

https://confluence.adeo.no/pages/viewpage.action?pageId=135791802

* Det finnes 2 ulike `rettighetkoder` for tilsyn til barn, `TSOTILBARN` og `TSRTILBARN`
  * Burde sjekke når `TSRTILBARN` sist ble brukt
* Flere typer vedtak (ulike stønader) per sak 
  * Hvor vanlig er dette?
  * Hvorfor? 
    * Er det fordi man har sendt inn en søknad der man søker om flere ytelser?
  * `select sak_id, count(*) from (select sak_id, rettighetkode, count(*) from vedtak group by sak_id, rettighetkode) group by sak_id having count(*) > 1;`

| Kode         | Beskrivelse                                                    |
|--------------|----------------------------------------------------------------|
| TSOBOUTG     | Boutgifter tilleggsstønad                                      |
| TSODAGREIS   | Daglig reise tilleggsstønad                                    |
| TSOFLYTT     | Flytting tilleggsstønad                                        |
| TSOLMIDLER   | Læremidler tilleggsstønad                                      |
| TSOREISAKT   | Reise ved start/slutt aktivitet og hjemreiser tilleggsstønad   |
| TSOREISARB   | Reisestønader til arbeidssøkere tilleggsstønader               |
| TSOREISOBL   | Reise til obligatorisk samling tilleggsstønad                  |
| TSOTILBARN   | Tilsyn av barn tilleggsstønader                                |
| TSOTILFAM    | Tilsyn av familiemedlemmer tilleggsstønader                    |
| TSRBOUTG     | Boutgifter arbeidssøker                                        |
| TSRDAGREIS   | Daglig reise arbeidssøker                                      |
| TSRFLYTT     | Flytting arbeidssøker                                          |
| TSRLMIDLER   | Læremidler arbeidssøker                                        |
| TSRREISAKT   | Reise ved start/slutt aktivitet og hjemreiser arbeidssøker     |
| TSRREISARB   | Reisestønader til arbeidssøkere                                |
| TSRREISOBL   | Reise til obligatorisk samling arbeidssøker                    |
| TSRTILBARN   | Tilsyn av barn arbeidssøker                                    |
| TSRTILFAM    | Tilsyn av familiemedlemmer arbeidssøker                        |
| ------------ | -------------------------------------------------------------- |