
# HomeAssist

## Einleitung
HomeAssist ist eine innovative Multi-User-Anwendung, die darauf abzielt, die Organisation von Haushaltsaufgaben in Wohngemeinschaften zu vereinfachen. Mit dieser Anwendung können Benutzer Aufgaben erstellen, verwalten und den Fortschritt in ihren Gruppen verfolgen. Die Plattform fördert die Zusammenarbeit und das effiziente Management von Ressourcen.

## Funktionen
- **Benutzerauthentifizierung**: Benutzer können sich registrieren und anmelden, um auf ihre Profile und Gruppen zuzugreifen.
- **Aufgabenverwaltung**: Erstellen, Zuweisen und Verfolgen von Aufgaben.
- **Ressourcenmanagement**: Verwalten von Ressourcen, die für Aufgaben benötigt werden.
- **Gruppenverwaltung**: Benutzer können Gruppen erstellen und verwalten, in denen sie zusammenarbeiten.

## Technologie-Stack
- **Ruby on Rails**: Für das Backend.
- **SQLite**: Für die Datenbank.
- **Bootstrap**: Für das Frontend-Design.
- **Stimulus**: Für interaktive UI-Komponenten.
- **Pundit**: Für die Autorisierung und Rollenverwaltung.
- **PaperTrail**: Für Versionskontrolle und Änderungsverfolgung.

## Systemanforderungen
- **Ruby Version**: 3.0.0 oder höher
- **Rails Version**: 7.2.1 oder höher
- **Datenbank**: SQLite 3.8 oder höher
- **Node.js** und **Yarn** für JavaScript-Management

## Installation

### 1. Repository klonen
```bash
git clone https://github.com/King9977/homeAssist.git
cd homeAssist
```

### 2. Abhängigkeiten installieren
```bash
bundle install
```

### 3. Datenbank erstellen
```bash
rails db:create
```

### 4. Migrationen durchführen
```bash
rails db:migrate
```

### 5. (Optional) Seed-Daten hinzufügen
Falls erforderlich, können Sie Seed-Daten hinzufügen:
```bash
rails db:seed
```

## Anwendung starten
Um die Anwendung lokal zu starten, führen Sie folgenden Befehl aus:
```bash
rails server
```
Öffnen Sie dann Ihren Webbrowser und gehen Sie zu `http://localhost:3000`.

## Tests ausführen
Um die Testsuite zu starten, verwenden Sie:
```bash
rails test
```

## Dienste
- **Job-Warteschlangen**: Unterstützt Hintergrundaufgaben.
- **Cache-Server**: Redis (optional).
- **Suchmaschine**: Elasticsearch (optional, für erweiterte Suchfunktionen).

## Kontakt
Für weitere Informationen oder Fragen kannst du das Repository auf GitHub besuchen: [HomeAssist Repository](https://github.com/King9977/homeAssist.git).
