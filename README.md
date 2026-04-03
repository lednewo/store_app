# Base App

Aplicativo Flutter com arquitetura em camadas, navegação com GoRouter e gerenciamento de estado com Cubit/BLoC.

## Tecnologias

- Flutter
- Dart
- flutter_bloc
- get_it
- go_router
- dio

## Estrutura

- `lib/presentation`: telas, widgets e cubits
- `lib/domain`: entidades e contratos
- `lib/data`: models, datasources e repositories
- `lib/config`: rotas, injeção de dependência e configurações gerais
- `lib/common`: componentes e serviços compartilhados

## Flavors

O projeto possui 3 ambientes:

- `development`
- `staging`
- `production`

## Como rodar

```sh
flutter pub get
flutter run --flavor development --target lib/main_development.dart
```

Para outros ambientes:

```sh
flutter run --flavor staging --target lib/main_staging.dart
flutter run --flavor production --target lib/main_production.dart
```

## Testes

```sh
flutter test
```
