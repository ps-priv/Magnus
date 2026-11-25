# Tuist – krótki przewodnik

Projekt Xcode (`Magnus.xcodeproj`, `Magnus.xcworkspace`) jest **generowany** przez [Tuist](https://docs.tuist.dev) z plików Swift i nie trafia do gita (patrz `.gitignore`). Zmiany w konfiguracji projektu robimy w `Project.swift`, nie w Xcode.

## Instalacja

Projekt jest budowany Tuist **4.54.3**, instalowanym przez [mise](https://mise.jdx.dev).

```bash
brew install mise
```

```bash
mise use -g tuist@4.54.3
```

```bash
tuist version
```

## Codzienna praca

Po sklonowaniu repo, po `git pull` albo po każdej zmianie w `Project.swift`:

```bash
tuist generate
```

Generuje projekt i otwiera go w Xcode (`--no-open`, żeby nie otwierać).

Dodanie lub usunięcie pliku `.swift` w katalogach `Sources/**` też wymaga ponownego `tuist generate`. Tuist zbiera pliki według wzorców ścieżek, a nie według zawartości projektu Xcode.

## Struktura

| Plik | Do czego służy |
|---|---|
| `Tuist.swift` | Globalna konfiguracja Tuist |
| `Project.swift` | Targety, ustawienia, Info.plist, wersje buildów, **zależności SPM** (`packages:`) |
| `.package.resolved` | Zablokowane wersje pakietów z `Project.swift` – commitujemy |
| `Tuist/Package.swift` | Zależności zarządzane przez `tuist install` – **obecnie nieużywane przez targety** |

Targety w `Project.swift`:

- `MagnusDomain`, `MagnusApplication`, `MagnusFeatures` – wspólne frameworki,
- `NovoNordiskApp` + `OneSignalNotificationServiceExtension`,
- `ChM Academy` + `ChMOneSignalNotificationServiceExtension`,
- `MagnusTests`.

## Typowe zmiany w `Project.swift`

**Numer builda** – `CFBundleVersion` w `infoPlist` danej aplikacji **i** jej rozszerzenia OneSignal (muszą się zgadzać przy wysyłce do App Store). Wersja marketingowa to `CFBundleShortVersionString`.

**Nowy pakiet SPM:**

1. Dopisz go do tablicy `packages` na górze pliku:
   ```swift
   .package(url: "https://github.com/owner/Lib.git", from: "1.2.0"),
   ```
2. Dodaj produkt do `dependencies` targetu:
   ```swift
   .package(product: "Lib"),
   ```
3. `tuist generate`, zbuduj, zacommituj `Project.swift` i `.package.resolved`.

**Aktualizacja pakietów** – podnieś wersję `from:` w `packages`, potem w Xcode *File → Packages → Update to Latest Package Versions* (albo usuń wpis z `.package.resolved`) i zbuduj. Zmiana wersji głównej (np. 8.x → 9.x) wymaga ręcznej zmiany `from:`.

## Budowanie z terminala

```bash
xcodebuild -workspace Magnus.xcworkspace -scheme NovoNordiskApp -destination 'generic/platform=iOS Simulator' build
```

```bash
xcodebuild -workspace Magnus.xcworkspace -scheme "ChM Academy" -configuration Release -destination 'generic/platform=iOS' build
```

## Gdy coś nie działa

```bash
tuist clean
```

```bash
tuist generate
```

Jeśli Xcode dalej pokazuje stare błędy – zamknij go, usuń `DerivedData` projektu i wygeneruj ponownie.

## Przydatne polecenia

| Polecenie | Opis |
|---|---|
| `tuist generate` | Generuje projekt i workspace |
| `tuist edit` | Otwiera `Project.swift` w Xcode z podpowiedziami (autouzupełnianie API Tuist) |
| `tuist graph` | Rysuje graf zależności między targetami |
| `tuist clean` | Czyści cache Tuist |
| `tuist install` | Pobiera zależności z `Tuist/Package.swift` |
