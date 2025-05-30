# Systemdokumentasjon for FAQ-appen

Denne systemdokumentasjonen gir en oversikt over krav, teknologier, arkitektur, sikkerhet, grensesnitt og eventuelle utfordringer i utviklingen av FAQ-appen.

---

<details open>
<summary>
  <h2>Krav</h2>
</summary>

- Klient-side for brukergrensesnitt med støtte for å søke og lese ofte stilte spørsmål (FAQ)
- Brukere kan søke etter tema, spørsmål og svar
- Admin-brukere kan opprette, redigere og slette FAQ-temaer og spørsmål
- FAQ-data og admin-IDer lagres i Firestore
- Tilgjengelig og brukervennlig design for alle brukergrupper

</details>

<details open>
<summary>
  <h2>Teknologier</h2>
</summary>

- Flutter (Dart)
- Firebase Firestore (database)
- Firebase Auth (autentisering, kun e-post lagres)
- Firebase Cloud Functions (backend og sikkerhet)
- Riverpod (state management)
- Github
- Figma (design)

</details>

<details open>
<summary>
  <h2>Arkitektur</h2>
</summary>
<ul>
  <li>
    <details>
      <summary>
        <h4>Datamodell</h4>
      </summary>
      <ul>
        <li><b>faq</b> (collection):<br>
          <ul>
            <li><code>title</code>: String</li>
            <li><code>description</code>: String</li>
            <li><code>createdAt</code>: Timestamp</li>
            <li><b>questions</b> (subcollection):<br>
              <ul>
                <li><code>question</code>: String</li>
                <li><code>answer</code>: String</li>
                <li><code>createdAt</code>: Timestamp</li>
              </ul>
            </li>
          </ul>
        </li>
        <li><b>admin</b> (collection):<br>
          <ul>
            <li><code>documentId</code>: String (brukerens UID)</li>
          </ul>
        </li>
        <li>Brukerdata lagres ikke, kun e-post via Firebase Auth</li>
      </ul>
    </details>
  </li>
  <li>
    <details>
      <summary>
        <h4>Flyt</h4>
      </summary>
      <ul>
        <li>Bruker logger inn med e-post og passord</li>
        <li>FAQ-temaer og tilhørende spørsmål hentes fra Firestore (spørsmål som subcollection under hvert tema)</li>
        <li>Søk filtrerer FAQ-data lokalt</li>
        <li>Admin kan opprette/redigere/slette FAQ og spørsmål via Cloud Functions</li>
        <li>Admin-flyt: Når admin gjør endringer i admin-panelet, sendes forespørselen til en Cloud Function som validerer admin-rettigheter og oppdaterer Firestore. Vanlige brukere har ikke tilgang til å gjøre endringer.</li>
      </ul>
    </details>
  </li>
</ul>
</details>

<details open>
<summary>
  <h2>Sikkerhet</h2>
</summary>

- Autentisering håndteres via Firebase Auth (kun e-post lagres)
- Firestore-regler og Cloud Functions sikrer at kun admin-brukere (definert i admin-ID-liste) kan endre FAQ-data
- Firestore write er stengt og kun tilgjengelig gjennom en cloud function kun admin brukere har lov å kjøre
- Vanlige brukere har kun lesetilgang til FAQ
- Ingen persondata lagres i Firestore utover admin-IDer og FAQ-innhold

</details>

<details open>
<summary>
  <h2>Grensesnittbeskrivelse</h2>
</summary>

- Se [Brukerveiledning](BrukerVeiledning.md) for full beskrivelse av brukergrensesnittet
- Hovedsider:
  - FAQ: Søk og les ofte stilte spørsmål
  - Spør AI: Still spørsmål til AI og få svar ut i fra FAQ
  - Profil: Se og administrer brukerprofil
  - Admin-portal: Administrer FAQ og spørsmål (kun for admin)

</details>

<details open>
<summary>
  <h2>Avvik fra plan</h2>
</summary>

- La brukeren komme med egne spørsmål

</details>

<details open>
<summary>
  <h2>Kilder</h2>
</summary>

- [Flutter Docs](https://docs.flutter.dev/)
- [Firebase Docs](https://firebase.google.com/docs)
- [Firebase Cloud Functions](https://firebase.google.com/docs/functions)
- [Riverpod Docs](https://riverpod.dev/)
- [Figma](https://www.figma.com/)
- [Stack Overflow](https://stackoverflow.com/)
- [ChatGPT](https://chat.openai.com/)

</details>
