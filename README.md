# Plan for fagprøve 2025

## Målet med oppgaven

Målet med oppgaven er å utvikle en mobilapplikasjon hvor brukeren kan få opp forskjellige FAQ-spørsmål innenfor ulike temaer. Det skal også være mulig å legge til nye FAQ-spørsmål som må bli godkjent av en admin gjennom en admin-portal.

## Fremgangsmåte

- Lage skisser for hvordan designet på appen skal se ut.
- Sette opp en Flutter-app og koble den mot Firebase.
- Utvikle frontend-delen av appen.
- Utvikle en login-skjerm med Firebase Authentication.
- Sette opp Firebase og bruke Firestore i appen.
- Lage Cloud Functions og bruke dem i appen.
- Gjennomføre brukertesting.
- Ekstra funksjonalitet.
- Presentere prosjektet.

---

## Tidsplan:

#### Dag 1: Planlegging

- Møte med prøvenemnda for å få informasjon om oppgaven og avklare spørsmål.
- Lage en plan for hele fagprøven.
- Planlegging av designet i Figma.
- Velge relevante teknologier.
- Planlegge strukturen for Firestore.

#### Dag 2: Start på utvikling

- Lage GitHub-repo for å holde kontroll på koden.
- Sette opp Flutter-appen.
- Lage et Firebase-prosjekt.
- Koble Firebase sammen med Flutter-appen.
- Lage innloggingsskjerm.
- Lage skjerm for å redigere/slette bruker (lovverk).
- Begynne på FAQ-delen.

#### Dag 3: Videreutvikling

- Hente ut FAQ-data fra backend og vise det i appen.
- Utvikle admin-portal.
- Utvikle muligheten for å lage/fjerne/redigere FAQ-spørsmål og temaer fra admin-portal.
- Utvikle muligheten for brukeren til å lage nye FAQ/tema som må godkjennes i admin-portal.

#### Dag 4: Videreutvikling

- Ferdigstille admin-portalen.
- Fortsette med FAQ-visningen.
- Gjøre litt brukertesting med kollegaer.
- Lage Spør AI side som bruker infoen fra FAQ

#### Dag 5: Ferdigstilling

- Gjøre appen helt klar for brukere.
- Gå over koden og se etter problemer eller ting som bør endres.
- Rydde opp i koden.

#### Dag 6: Dokumentering og øving

- Ferdigstille dokumentasjon om appen (gjøres underveis alle dagene).
- Lage brukerveiledning.
- Lage presentasjonen.
- Øve på presentasjon.

#### Dag 7: Presentasjon

- Gjennomføre presentasjon.

#### Tidsestimat

- Planlegging: ~5,5 timer
- Sette opp app/Firebase: ~2-3 timer
- Innlogging/brukerredigering: 12 timer
- Admin-portal: ~14 timer
- FAQ: ~16 timer
- Dokumentasjon: ~4 timer
- Gjennomgang: ~3 timer

---

## Teknologier

### Flutter (Dart)

Jeg har valgt Flutter fordi det gjør det enkelt å lage apper som fungerer både på iOS og Android uten å måtte skrive to forskjellige kodebaser. Jeg har også god erfaring med Flutter fra før, og synes det er raskt å jobbe med når man skal lage moderne og brukervennlige grensesnitt. I tillegg finnes det mange ferdige pakker og god dokumentasjon, noe som gjør utviklingen mer effektiv.

### Firebase

Jeg har valgt Firebase fordi det er enkelt å sette opp og gir mye funksjonalitet ut av boksen, som autentisering og database. Det passer bra sammen med Flutter, og jeg har brukt det før så jeg vet hvordan det fungerer. I tillegg håndterer Firebase mye av sikkerheten og skalerer automatisk, så jeg slipper å tenke på servere og vedlikehold.

### Firestore

Firestore er valgt fordi det er en fleksibel og skalerbar database som passer bra til apper hvor innholdet endrer seg ofte. Det er enkelt å lagre og hente ut data i sanntid, og sikkerheten er lett å styre. Jeg har brukt Firestore før og vet at det fungerer godt sammen med Flutter.

### Firebase Authentication

Jeg bruker Firebase Authentication for å gjøre innlogging og registrering enkelt og sikkert. Det er lett å sette opp, og jeg slipper å lage hele innloggingssystemet selv. Det fungerer stabilt og er lett å koble sammen med Firestore.

### Cloud Functions

Cloud Functions lar meg kjøre kode på serveren når det skjer spesielle ting i appen, for eksempel når noen sender inn et nytt spørsmål. Jeg slipper å drifte egne servere, og det er lett å utvide funksjonaliteten etter hvert.

### Genkit AI

Genkit AI vurderer jeg å bruke for å gjøre appen litt smartere, for eksempel ved å foreslå svar. Jeg har ikke brukt det mye før, men det kan gjøre appen mer brukervennlig hvis jeg får tid til å teste det.

### Figma

Jeg har valgt å bruke Figma fordi det er bransjestandard og blir brukt hos Haugaland Kraft.

### Firestore Datastruktur

### Collection: theme

- **Document-ID**: (auto-generated)
  - **title**: string – Name of the theme
  - **description**: string – Short description of the theme
  - **createdAt**: timestamp – When the theme was created
  - **Subcollection: sporsmal**
    - **Document-ID**: (auto-generated)
      - **question**: string – The question
      - **answer**: string – The answer
      - **createdAt**: timestamp – When the question was added
      - **likes**: number – Number of likes
      - **dislikes**: number – Number of dislikes

---

### Collection: FAQ_til_godkjenning

- **Document-ID**: (auto-generated)
  - **theme**: string – Name of the theme
  - **question**: string – Name of the question
  - **uid** string - User ID så jeg kan se hvem som har lagd det

---

### Collection: Admin_mail_list

- **Document-ID**: (auto-generated)
  - **email** string - Mailen til admin bruker

### Kilder:

- Kollegaer
- ChatGPT/Copilot

### Figma Skisser:

![FAQ](https://github.com/user-attachments/assets/5b85f05f-bd4e-45b3-9cfe-2816f44d9992)
![AskAI](https://github.com/user-attachments/assets/c4938d50-038e-4948-a7d6-066da83efae5)
![Admin](https://github.com/user-attachments/assets/8e2e730b-4793-4e41-90ce-716aca5c7355)
