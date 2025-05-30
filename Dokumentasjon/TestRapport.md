# Testrapport for FAQ-appen

Denne testrapporten dokumenterer testing av alle hovedfunksjoner i FAQ-appen. Hver seksjon beskriver hva som er testet, hvordan det ble testet, og resultatet.

---

<details open>
<summary>
  <h2>FAQ</h2>
</summary>
<table>
  <tr>
    <td><b>Visning av FAQ-liste</b><br>Testet at alle FAQ-temaer vises korrekt på hovedsiden. Klikk på et tema åpner detaljvisning.</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Søk i FAQ</b><br>Testet søkefeltet med ulike søkeord. Resultatene oppdateres dynamisk og relevante tema/spørsmål vises.</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Vis spørsmål & svar</b><br>Testet at alle spørsmål og svar for valgt tema vises i en oversiktlig liste.</td>
    <td>✅</td>
  </tr>
</table>
</details>

<details open>
<summary>
  <h2>Spør AI</h2>
</summary>
<table>
  <tr>
    <td><b>Stille spørsmål til AI</b><br>Testet å sende inn spørsmål til AI og mottatt svar. Svar vises i appen.</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Feilhåndtering</b><br>Testet at feilmeldinger vises hvis AI ikke kan svare eller det oppstår nettverksfeil.</td>
    <td>✅</td>
  </tr>
</table>
</details>

<details open>
<summary>
  <h2>Profil</h2>
</summary>
<table>
  <tr>
    <td><b>Visning av profil</b><br>Testet at brukernavn og e-post vises korrekt. </td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Logg ut</b><br>Testet utlogging. Brukeren sendes til innloggingsskjerm.</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Slett bruker</b><br>Testet sletting av bruker. Brukeren og tilhørende data fjernes.</td>
    <td>✅</td>
  </tr>
</table>
</details>

<details open>
<summary>
  <h2>Admin-portal</h2>
</summary>
<table>
  <tr>
    <td><b>Opprett FAQ-tema</b><br>Testet å opprette nytt FAQ-tema. Temaet vises umiddelbart i listen.</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Rediger FAQ-tema</b><br>Testet å endre tittel, beskrivelse og spørsmål/svar for et tema. Endringer lagres og vises.</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Slett FAQ-tema</b><br>Testet å slette et tema. Temaet fjernes fra listen.</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Rollebasert tilgang</b><br>Testet at kun admin-brukere får tilgang til admin-portal og kan gjøre endringer.</td>
    <td>✅</td>
  </tr>
</table>
</details>

<details open>
<summary>
  <h2>Generelt</h2>
</summary>
<table>
  <tr>
    <td><b>Responsivt design</b><br>Testet appen på ulike skjermstørrelser (mobil og nettbrett). Alt innhold tilpasser seg skjermen.</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Feilhåndtering</b><br>Testet at feilmeldinger vises ved nettverksfeil, manglende data eller ugyldig input.</td>
    <td>✅</td>
  </tr>
  <tr>
    <td><b>Ytelse</b><br>Appen laster data raskt og oppleves responsiv.</td>
    <td>✅</td>
  </tr>
</table>
</details>
