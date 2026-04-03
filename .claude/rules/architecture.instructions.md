---
applyTo: '**'
---

# Instruções de Arquitetura - Base App Flutter

Este documento descreve a arquitetura e padrões de desenvolvimento do projeto Base App Flutter. Todos os assistentes de IA devem seguir rigorosamente estas diretrizes ao gerar, modificar ou revisar código.

---

## ✅ Leitura Rápida para IA (prioridade e regras-chave)

- **Prioridade**: este documento vence qualquer conflito com outros arquivos de instrução.
- **Quando criar uma feature**: use o `🧭 Fluxo de Decisão` abaixo — comece com o mínimo (View + Cubit + State + rota + DI).
- **Quando criar um método async no Cubit**: SEMPRE emita `Loading` primeiro → chame o repository → use `result.when()` para emitir o estado final.
- **Quando adicionar texto visível na UI**: SEMPRE use `context.l10n.<chave>` — nunca string hardcoded.
- **Quando navegar entre telas**: navegação SEMPRE na View (ou em `BlocListener`) — nunca receba `BuildContext` no Cubit.
- **Quando houver erro em repository**: SEMPRE envolva em `try/catch` e retorne `Result.error(...)` — nunca relance a exceção.
- **Quando criar uma Entity**: SEMPRE adicione `@immutable`, `const`, `final`, `copyWith()`, `==` e `hashCode`.
- **Quando registrar no DI**: Cubits → `registerFactory`; tudo mais → `registerLazySingleton`.
- **Dependências permitidas**: `presentation` → usa `domain`; `data` → implementa `domain`; `domain` → nada externo.
- **Performance na View**: NUNCA crie métodos privados que retornam Widget (ex: `Widget _buildXxx()`) nem classes privadas de widget (ex: `_RecursosContent`) dentro do arquivo de View — extraia para `widgets/` se for reutilizável, ou para `content/` se for um auxiliar específico da View. Funções de dialog/bottomSheet são exceção.
- **SafeArea**: SEMPRE envolva o conteúdo principal da View com `SafeArea` para respeitar os limites físicos do dispositivo (notch, barra de status, home indicator).

---

## 🏗️ Arquitetura Geral

O projeto segue uma **arquitetura em camadas limpa** (Clean Architecture adaptada para Flutter) com separação clara de responsabilidades:

```
┌─────────────────┐
│  Presentation   │ ← Views (UI) + Cubits (BLoC)
├─────────────────┤
│     Domain      │ ← Entities + Interfaces (Contratos)
├─────────────────┤
│      Data       │ ← Models + DataSources + Repositories
└─────────────────┘
```

### Princípios Fundamentais

1. **Dependency Rule**: As dependências fluem sempre de fora para dentro (Presentation → Domain ← Data)
2. **Entities imutáveis**: Objetos de domínio são imutáveis e independentes de frameworks
3. **Contratos no domínio**: Interfaces definem contratos; implementações ficam na camada de dados
4. **Separação de concerns**: Cada camada tem uma responsabilidade única e bem definida
5. **Result Pattern**: Tratamento de erros através de `Result<T>` (Ok/Error)

---

## 📂 Estrutura de Pastas (OBRIGATÓRIA)

```
lib/
├── presentation/              # Camada de UI
│   └── <feature_name>/
│       ├── view/
│       │   └── <feature>_view.dart      # Widget principal da tela
│       ├── view_model/
│       │   ├── <feature>_cubit.dart     # Gerenciador de estado (BLoC)
│       │   └── <feature>_state.dart     # Estados da feature
│       ├── widgets/                      # Widgets reutilizáveis da feature
│       │   └── <feature>_widget.dart
│       ├── content/                      # Auxiliares de UI específicos de uma View (não reutilizáveis)
│       │   └── <feature>_content.dart
│       └── utils/                        # Utilidades específicas da feature
│           └── <feature>_formatters.dart
│
├── domain/                    # Camada de negócio
│   ├── entities/              # Entidades imutáveis (regras de negócio)
│   │   └── <entity>_entity.dart
│   └── interfaces/            # Contratos/Abstrações
│       └── <feature>_repository.dart
│
├── data/                      # Camada de infraestrutura
│   ├── models/                # DTOs para serialização
│   │   └── <entity>_model.dart
│   ├── datasources/           # Fontes de dados (API, DB local, etc)
│   │   └── <feature>_remote_datasource.dart
│   └── repositories/          # Implementações das interfaces do domínio
│       └── <feature>_repository_impl.dart
│
├── common/                    # Código compartilhado entre features
│   ├── widgets/               # Componentes UI reutilizáveis
│   ├── styles/                # Temas, cores, tipografia
│   ├── utils/                 # Extensions, validators, formatters
│   ├── services/              # Serviços compartilhados (storage local, in-app purchase, biometria, etc)
│   │   ├── storage_service.dart
│   │   └── shared_preferences_service.dart
│   └── errors/                # Exceções customizadas
│
├── config/                    # Configurações globais
│   ├── error/
│   │   └── result_pattern.dart
│   ├── routes/
│   │   ├── app_router.dart
│   │   └── app_routes.dart
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── auth_interceptor.dart
│   ├── inject/
│   │   └── app_injector.dart
│   └── app_initializer.dart
│
├── l10n/                      # Internacionalização
│   ├── l10n.dart
│   ├── arb/
│   │   ├── app_en.arb
│   │   └── app_pt.arb
│   └── gen/
│       └── app_localizations.dart
│
├── bootstrap.dart             # Bootstrap da aplicação
├── app.dart                   # Widget raiz
├── main_development.dart      # Entry point - Development
├── main_staging.dart          # Entry point - Staging
└── main_production.dart       # Entry point - Production
```

### ⚠️ Regras de Estrutura

- **NUNCA** crie widgets de UI fora de `presentation/`
- **NUNCA** misture lógica de negócio com UI
- **NUNCA** acesse DataSources diretamente do Cubit (use Repository)
- **NUNCA** importe classes de `data/` dentro de `domain/`
- **NUNCA** crie arquivos barrel/export (como `feature.dart`)
- **SEMPRE** use imports absolutos com `package:base_app/...`

---

## 🎯 Fluxo de Dados

```
┌──────────┐  interage  ┌────────┐  chama   ┌──────────┐
│   View   │ ────────→ │  Cubit  │ ───────→ │Repository│
│  (UI)    │            │ (State) │          │(Interface)│
└──────────┘            └────────┘          └──────────┘
                             ↓                     ↓
                        emite estados       implementado por
                             ↓                     ↓
                        ┌────────┐          ┌──────────────┐
                        │ State  │          │RepositoryImpl│
                        └────────┘          └──────────────┘
                                                   ↓
                                            usa DataSource
                                                   ↓
                                            ┌──────────────┐
                                            │  DataSource  │
                                            └──────────────┘
```

### Exemplo Prático

```dart
// 1. View chama o Cubit
_cubit.loadHome();

// 2. Cubit chama o Repository (interface)
final result = await _homeRepository.loadHomeData();

// 3. Repository (impl) usa DataSource
final responseData = await _remoteDataSource.getMockHomeData();

// 4. DataSource retorna dados brutos (Map/JSON)
// 5. Repository converte em Model e retorna como Result
return Result.ok(HomeModel.fromJson(responseData));

// 6. Cubit processa Result e emite Estado
emit(HomeLoaded(message: homeData.value.message));

// 7. View reconstrói UI com novo estado
```

---

## 🧩 Camadas Detalhadas

### 1️⃣ Presentation Layer

**Responsabilidade**: Apresentar informações ao usuário e capturar interações.

#### View (StatefulWidget)

```dart
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _cubit = AppInjector.inject.get<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.counterAppBarTitle)),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          if (state is HomeLoaded) {
            return Text(context.l10n.loadedLabel);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

**Regras da View:**
- ✅ Obtém Cubit do `AppInjector` (DI)
- ✅ Usa `BlocBuilder` para reagir a mudanças de estado
- ✅ Acessa l10n via `context.l10n`
- ❌ NÃO contém lógica de negócio
- ❌ NÃO faz chamadas HTTP diretamente
- ❌ NÃO manipula dados complexos
- ✅ Chama `_cubit.close()` no `dispose()`
- ✅ Usa `initState()` para carregar dados (não `didChangeDependencies`)

#### Cubit (State Management)

```dart
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._homeRepository) : super(const HomeInitial());

  final HomeRepository _homeRepository;

  Future<void> loadHome() async {
    emit(const HomeLoading());

    final result = await _homeRepository.loadHomeData();

    result.when(
      ok: (homeData) => emit(HomeLoaded(
        message: homeData.message,
        items: homeData.items,
      )),
      error: (e) => emit(HomeError('Erro ao carregar home: $e')),
    );
  }
}
```

**Regras do Cubit:**
- ✅ Recebe dependências via construtor (DI)
- ✅ Sempre emite estado de loading antes de operações assíncronas
- ✅ Usa `result.when()` para tratar `Result<T>`
- ✅ Converte erros técnicos em mensagens amigáveis
- ❌ NÃO contém lógica de UI (cores, tamanhos, etc)
- ❌ NÃO acessa DataSources diretamente
- ❌ NÃO faz tratamento de erros genérico (use Result)

#### State (Sealed Classes)

```dart
@immutable
sealed class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  const HomeLoaded({required this.message, required this.items});
  final String message;
  final List<String> items;
}

class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;
}
```

**Regras do State:**
- ✅ Sempre `sealed class` para pattern matching exaustivo
- ✅ Sempre `@immutable` e `const`
- ✅ Propriedades finais
- ❌ NÃO adicione métodos (apenas dados)
- ❌ NÃO use herança (use sealed)

---

### 2️⃣ Domain Layer

**Responsabilidade**: Definir regras de negócio e contratos (sem dependências externas).

#### Entity (Objetos de Negócio)

```dart
@immutable
class HomeEntity {
  const HomeEntity({required this.message, required this.items});

  final String message;
  final List<String> items;

  HomeEntity copyWith({String? message, List<String>? items}) {
    return HomeEntity(
      message: message ?? this.message,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeEntity &&
          message == other.message &&
          listEquals(items, other.items);

  @override
  int get hashCode => Object.hash(message, items);
}
```

**Regras da Entity:**
- ✅ SEMPRE `@immutable`
- ✅ SEMPRE implementar `copyWith()`
- ✅ SEMPRE implementar `==` e `hashCode`
- ✅ Propriedades finais
- ❌ NÃO importar pacotes de infra (Dio, SharedPreferences, etc)
- ❌ NÃO ter métodos de serialização (use Models)

#### Repository Interface

```dart
abstract class HomeRepository {
  /// Carrega os dados iniciais da tela Home
  Future<Result<HomeEntity>> loadHomeData();

  /// Atualiza/recarrega os dados da home
  Future<Result<HomeEntity>> refreshHomeData();
}
```

**Regras da Interface:**
- ✅ Define APENAS contratos (métodos abstratos)
- ✅ Sempre retorna `Result<T>` para operações assíncronas
- ✅ Usa Entities do domínio
- ✅ Adiciona documentação descritiva
- ❌ NÃO contém implementações
- ❌ NÃO depende de classes de `data/`

---

### 3️⃣ Data Layer

**Responsabilidade**: Implementar acesso a dados (API, DB, Cache) e serialização.

#### Model (DTO)

```dart
class HomeModel extends HomeEntity {
  const HomeModel({required super.message, required super.items});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      message: json['message'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'items': items};
  }

  factory HomeModel.fromEntity(HomeEntity entity) {
    return HomeModel(message: entity.message, items: entity.items);
  }
}
```

**Regras do Model:**
- ✅ Sempre extende a Entity correspondente
- ✅ Implementa `fromJson()` e `toJson()`
- ✅ Adiciona validações e defaults nos construtores
- ✅ Pode ter `fromEntity()` se necessário
- ❌ NÃO adiciona lógica de negócio

#### DataSource

```dart
class HomeRemoteDataSource {
  const HomeRemoteDataSource(this._httpService);
  final HttpService _httpService;

  /// Busca dados reais da API
  Future<HttpResponse> getHomeData() async {
    return await _httpService.get('/home');
  }

  /// Simula chamada API para desenvolvimento
  Future<Map<String, dynamic>> getMockHomeData() async {
    return {
      'message': 'Welcome to Home!',
      'items': ['Item 1', 'Item 2', 'Item 3'],
    };
  }
}
```

**Regras do DataSource:**
- ✅ Classe concreta (não precisa de abstração se não houver múltiplas fontes)
- ✅ Recebe dependências via construtor (`HttpService` — não Dio diretamente)
- ✅ Retorna dados brutos (`HttpResponse`, Map, List, primitivos)
- ✅ Lança exceções em caso de erro
- ❌ NÃO faz tratamento de erros (deixe para o Repository)
- ❌ NÃO retorna Models/Entities

#### Repository Implementation

```dart
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);
  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<HomeEntity>> loadHomeData() async {
    try {
      final responseData = await _remoteDataSource.getMockHomeData();
      return Result.ok(HomeModel.fromJson(responseData));
    } catch (e) {
      return Result.error(Exception('Failed to load home data: $e'));
    }
  }

  @override
  Future<Result<HomeEntity>> refreshHomeData() async {
    try {
      final responseData = await _remoteDataSource.getMockHomeData();
      return Result.ok(HomeModel.fromJson(responseData));
    } catch (e) {
      return Result.error(Exception('Failed to refresh home data: $e'));
    }
  }
}
```

**Regras do Repository:**
- ✅ Implementa interface do domínio
- ✅ Recebe DataSources via construtor
- ✅ SEMPRE envolve chamadas em try/catch
- ✅ Retorna `Result<T>` (nunca lança exceções)
- ✅ Converte dados brutos em Models/Entities
- ❌ NÃO expõe detalhes de implementação

---

## 🛠️ Configurações e Serviços

### Error Handling (Result Pattern)

```dart
sealed class Result<T> {
  const Result();

  factory Result.ok(T value) => Ok(value);
  factory Result.error(Exception error) => Error(error);
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.error);
  final Exception error;
}
```

**Helpers disponíveis:**
- `result.when(ok: ..., error: ...)` — pattern matching limpo
- `result.whenAsync(ok: ..., error: ...)` — versão assíncrona
- `result.valueOrNull` — retorna valor ou null
- `result.isOk` / `result.isError` — checks booleanos

**Uso:**
```dart
import 'dart:developer';

// Retornar
return Result.ok(data);
return Result.error(Exception('Something went wrong'));

// Consumir (preferido — mais conciso)
result.when(
  ok: (user) => log(user.toString()),
  error: (e) => log(e.toString()),
);

// Alternativa: switch (para lógica mais complexa)
switch (result) {
  case Ok<User>(:final value):
    log(value.toString());
  case Error<User>(:final error):
    log(error.toString());
}
```

### Injeção de Dependências (GetIt)

```dart
enum AppFlavor { development, staging, production }

class AppInjector {
  static GetIt inject = GetIt.instance;

  static Future<void> setupDependencies({required AppFlavor flavor}) async {
    // Registra flavor
    inject.registerLazySingleton<AppFlavor>(() => flavor);

    // Storage Service
    inject.registerLazySingleton<StorageService>(
      () => SharedPreferencesService(),
    );

    // Network
    inject.registerLazySingleton<Dio>(
      () => makeDio(
        baseUrl: _getBaseUrlForFlavor(flavor),
        enableLogs: _shouldEnableLogsForFlavor(flavor),
      ),
    );

    // DataSources
    inject.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSource(inject()),
    );

    // Repositories
    inject.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(inject()),
    );

    // Cubits (Factory para nova instância a cada chamada)
    inject.registerFactory<HomeCubit>(() => HomeCubit(inject()));
  }
}
```

**Regras de DI:**
- ✅ `registerLazySingleton` para Services, Repositories, DataSources
- ✅ `registerFactory` para Cubits
- ✅ Use `inject()` para resolver dependências
- ❌ NÃO registre Widgets
- ❌ NÃO registre classes de UI

### Navegação (GoRouter)

```dart
// app_routes.dart
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
}

// app_router.dart
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeView(),
    ),
  ],
);
```

### Storage Service

```dart
// Interface
abstract class StorageService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  // ... outros métodos
}

// Uso no Cubit
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._storage) : super(const SettingsInitial());
  final StorageService _storage;

  Future<void> saveTheme(String theme) async {
    await _storage.setString('theme', theme);
    emit(const SettingsSaved());
  }
}
```

---

## 🚀 Inicialização Multi-Flavor

### Entry Points

```dart
// main_development.dart
Future<void> main() async {
  await AppInitializer.initialize(AppFlavor.development);
  await bootstrap(() => const App());
}

// main_staging.dart
Future<void> main() async {
  await AppInitializer.initialize(AppFlavor.staging);
  await bootstrap(() => const App());
}

// main_production.dart
Future<void> main() async {
  await AppInitializer.initialize(AppFlavor.production);
  await bootstrap(() => const App());
}
```

### AppInitializer

```dart
class AppInitializer {
  static Future<void> initialize(AppFlavor flavor) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Outras inicializações:
    // await Firebase.initializeApp();
    // await SystemChrome.setPreferredOrientations([...]);

    await AppInjector.setupDependencies(flavor: flavor);
  }
}
```

### Bootstrap

```dart
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();
  runApp(await builder());
}
```

---

## ✅ Checklist para Criar Nova Feature

Quando adicionar uma nova feature chamada `profile`, crie **APENAS**:

```
✅ presentation/profile/view/profile_view.dart
✅ presentation/profile/view_model/profile_cubit.dart
✅ presentation/profile/view_model/profile_state.dart
✅ Adicionar rota em config/routes/app_routes.dart
✅ Adicionar GoRoute em config/routes/app_router.dart
✅ Registrar Cubit em config/inject/app_injector.dart
```

**❌ NÃO CRIE automaticamente:**
- widgets/ (apenas se houver widgets reutilizáveis dentro da feature)
- content/ (apenas se houver classes auxiliares de UI específicas da View)
- utils/ (apenas se houver formatters/validators específicos)
- domain/entities/ (apenas se necessário)
- data/models/ (apenas se houver API/serialização)
- data/datasources/ (apenas se houver fonte de dados)
- data/repositories/ (apenas se houver lógica de dados)

---

## 🧭 Fluxo de Decisão: o que criar em uma nova feature?

**Use este fluxo SEMPRE que receber um pedido de nova feature ou nova tela:**

```
A feature precisa buscar dados de API ou banco de dados externo?
  ├─ SIM → criar Data Layer completo:
  │         ✅ domain/entities/<entity>_entity.dart
  │         ✅ domain/interfaces/<feature>_repository.dart
  │         ✅ data/models/<entity>_model.dart
  │         ✅ data/datasources/<feature>_remote_datasource.dart
  │         ✅ data/repositories/<feature>_repository_impl.dart
  │         ✅ Registrar DataSource e Repository no app_injector.dart
  │
  └─ NÃO ─ A feature precisa persistir dados localmente?
              ├─ SIM → injete StorageService diretamente no Cubit
              │         (sem criar Data Layer)
              │
              └─ NÃO → crie APENAS:
                        ✅ View + Cubit + State + rota + DI
```

**Tabela de decisão rápida:**

| Situação | O que criar |
|---|---|
| Tela simples / UI local | View + Cubit + State + rota + DI |
| Dados locais (preferências, cache) | + injetar `StorageService` no Cubit |
| API ou fonte de dados externa | + Entity + Repository Interface + Model + DataSource + RepositoryImpl |
| Widget reutilizável dentro da feature | `presentation/<feature>/widgets/` |
| Widget reutilizável entre features | `common/widgets/` |
| Auxiliar de UI específico de uma View (não reutilizável) | `presentation/<feature>/content/` |
| Regras de negócio sem API | + `domain/entities/` sem Data Layer |
| Compras in-app | Seguir `in_app_purchase.instructions.md` — sem Repository |

---

## 📋 Convenções de Código

### Nomenclatura

- **Arquivos**: `snake_case` → `home_view.dart`
- **Classes**: `PascalCase` → `HomeView`, `HomeCubit`
- **Variáveis/Métodos**: `camelCase` → `loadHome()`, `userName`
- **Constantes**: `camelCase` → `maxRetries`, `defaultTimeout`
- **Privados**: `_` prefix → `_cubit`, `_dio`

### Formatação

- ✅ Máximo 80 caracteres por linha
- ✅ Use `dart format` antes de commit
- ✅ Siga `flutter_lints` (análise estática)
- ✅ Prefira `const` sempre que possível
- ✅ Use trailing commas para melhor formatação

### Imports

```dart
// ✅ SEMPRE use imports absolutos
import 'package:base_app/presentation/home/view/home_view.dart';
import 'package:base_app/domain/entities/user_entity.dart';

// ❌ NUNCA use imports relativos
import '../view/home_view.dart';
import '../../domain/entities/user_entity.dart';
```

### Comentários

```dart
/// Doc comment para APIs públicas
/// Descreve o propósito do método/classe
Future<Result<User>> getUser(String id);

// Comentário de linha para explicações internas
// Use apenas quando o código não for auto-explicativo
```

---

## 🎯 Boas Práticas

### Performance

- ✅ Use `const` construtores sempre que possível
- ✅ Use `ListView.builder` para listas longas
- ✅ Evite `setState` desnecessários
- ✅ Extraia widgets para reduzir rebuilds
- ❌ NÃO faça I/O no método `build()`
- ❌ NÃO use `print()` (use `log()` do dart:developer)

### Testes

```dart
// Estrutura esperada
test/
├── presentation/
│   └── home/
│       └── view_model/
│           └── home_cubit_test.dart
├── domain/
│   └── entities/
│       └── home_entity_test.dart
└── data/
    └── repositories/
        └── home_repository_impl_test.dart
```

### Acessibilidade

- ✅ Adicione `Semantics` widgets
- ✅ Use labels descritivos
- ✅ Teste com TalkBack/VoiceOver
- ✅ Contraste adequado de cores

### Internacionalização (i18n)

- ✅ **SEMPRE** use `context.l10n` para textos exibidos ao usuário
- ✅ Adicione todas as strings em `lib/l10n/arb/app_en.arb` e `app_pt.arb`
- ✅ Acesse traduções via `l10n.nomeDoTexto` ou `context.l10n.nomeDoTexto`
- ❌ **NUNCA** use strings hardcoded direto no código (ex: `Text('Olá')`)
- ❌ **NUNCA** deixe textos visíveis ao usuário sem tradução

```dart
// ❌ ERRADO: string hardcoded
Text('Bem-vindo ao app')
AppBar(title: Text('Configurações'))

// ✅ CORRETO: usando i18n
final l10n = context.l10n;
Text(l10n.welcomeMessage)
AppBar(title: Text(l10n.settingsTitle))
```

**Exceções permitidas:**
- Strings de desenvolvimento/debug (logs, prints)
- Nomes técnicos de APIs ou constantes de sistema
- Dados dinâmicos vindos de API/banco de dados

---

## 🚫 Anti-Patterns (O que NÃO fazer)

```dart
// ❌ NÃO acople UI a lógica de negócio
class HomeView extends StatelessWidget {
  Future<void> _loadData() async {
    final response = await http.get('https://api.com/data'); // ERRADO!
  }
}

// ❌ NÃO use singletons globais
class AppState {
  static final AppState instance = AppState._();
  // ...
}

// ❌ NÃO ignore erros
try {
  await repository.loadData();
} catch (e) {
  // Ignorado - ERRADO!
}

// ❌ NÃO crie God Classes
class UserManager {
  void login() {}
  void logout() {}
  void updateProfile() {}
  void deleteAccount() {}
  void sendEmail() {}
  void validatePassword() {}
  // ... 50+ métodos
}

// ❌ NÃO misture responsabilidades
class UserRepository {
  Future<User> getUser() {
    // Chama API
    // Salva no banco local
    // Atualiza cache
    // Envia analytics
    // Mostra notificação
    // ERRADO! Muitas responsabilidades
  }
}

// ❌ NÃO crie métodos privados que retornam Widget dentro da View
// ❌ NÃO crie classes privadas de widget dentro do arquivo da View
class _HomeViewState extends State<HomeView> {
  Widget _buildHeader() {  // ERRADO! Extraia para widgets/ ou content/
    return Container(...);
  }
  Widget _buildList() {  // ERRADO! Extraia para widgets/ ou content/
    return ListView(...);
  }
  // ✅ OK: funções de dialog/bottomSheet podem ficar na View
  void _showConfirmDialog() {
    showDialog(context: context, builder: ...);
  }
}
```

---

## 📦 Pacotes Principais

```yaml
dependencies:
  flutter: sdk
  
  # State Management
  bloc: ^9.0.1
  flutter_bloc: ^9.1.1
  
  # Dependency Injection
  get_it: ^8.0.2
  
  # Navegação
  go_router: ^16.2.4
  
  # Network
  dio: ^5.7.0
  
  # Storage
  shared_preferences: ^2.5.3
  
  # Internacionalização
  intl: ^0.20.2
  flutter_localizations: sdk
  
  # Lint
  flutter_lints: ^2.0.0

dev_dependencies:
  bloc_test: ^10.0.0
  flutter_test: sdk
```

---

## 🎓 Referências

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Best Practices](https://docs.flutter.dev/development/ui/layout)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

## 📝 Resumo Rápido

**Para a IA seguir:**

1. **Estrutura obrigatória**: presentation → domain → data
2. **Imports absolutos**: sempre `package:base_app/...`
3. **State management**: Cubit (BLoC)
4. **Error handling**: `Result<T>` (Ok/Error)
5. **DI**: GetIt (`AppInjector`)
6. **Navegação**: GoRouter
7. **Entities**: imutáveis com `copyWith()`
8. **Models**: extendem Entity, implementam JSON
9. **Repositories**: interface no domain, impl no data
10. **Views**: StatefulWidget + BlocBuilder
11. **Convenções**: snake_case arquivos, PascalCase classes
12. **Nunca**: imports relativos, God classes, código acoplado
13. **Sempre**: const, Result, try/catch em repositories
14. **Feature mínima**: view + cubit + state + rota + DI
15. **Storage**: usar `StorageService` (nunca direto)
16. **Importante**: não crie arquivos .md explicando o que foi feito a cada modificação de código.

---

**Última atualização**: 15 de janeiro de 2026
