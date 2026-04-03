---
name: implement-view
description: Implements Flutter View screens following the project architecture. Use whenever creating or modifying a View (StatefulWidget + Cubit + BlocBuilder). Covers the full step-by-step: State, Cubit, View file, route, DI registration, SafeArea, navigation patterns, performance rules and common mistakes.
---

# Implement View — Flutter

## Leitura Rápida

- **Quando criar uma View**: use `StatefulWidget`, obtenha o Cubit via `AppInjector.inject.get<XCubit>()`, use `BlocBuilder` para reagir a estados.
- **Quando carregar dados iniciais**: chame `_cubit.load*()` no `initState()` — use `didChangeDependencies()` apenas se precisar do `context`.
- **Quando navegar entre telas**: SEMPRE use `context.push/go/pop` na View ou em `BlocListener` — nunca passe `BuildContext` ao Cubit.
- **Quando exibir texto ao usuário**: SEMPRE use `context.l10n.<chave>` — nunca string hardcoded.
- **Quando a View for descartada**: feche o Cubit no `dispose()` com `_cubit.close()`.
- **NUNCA crie métodos privados que retornam Widget** (ex: `Widget _buildHeader()`) nem **classes privadas de widget** dentro do arquivo de View. Extraia para `widgets/` (reutilizável) ou `content/` (auxiliar específico da View).
- **Exceção**: funções privadas que abrem `showDialog()`, `showModalBottomSheet()` ou similares **podem** permanecer na View.
- **SafeArea**: SEMPRE envolva o conteúdo principal com `SafeArea`.

---

## Princípio Fundamental

**CRIAÇÃO MÍNIMA**: Crie apenas o essencial. Não adicione estruturas (entities, repositories, datasources) até que sejam realmente necessárias.

### Arquivos Essenciais para uma Nova View

Ao criar uma feature chamada `profile`, crie **APENAS**:

```
lib/presentation/profile/
├── view/
│   └── profile_view.dart           # ✅ OBRIGATÓRIO
├── view_model/
│   ├── profile_cubit.dart          # ✅ OBRIGATÓRIO
│   └── profile_state.dart          # ✅ OBRIGATÓRIO
├── (widgets/)                      # ❌ Criar apenas se houver widgets reutilizáveis
│   └── profile_form.dart
└── (content/)                      # ❌ Criar apenas se houver auxiliares específicos da View
    └── profile_content.dart
```

**NÃO CRIAR automaticamente:**
- ❌ widgets/ (criar só quando houver widgets reutilizáveis dentro da feature)
- ❌ content/ (criar só quando houver classes auxiliares de UI específicas de uma View)
- ❌ utils/ (criar só quando houver formatters/validators específicos)
- ❌ domain/entities/
- ❌ data/models/
- ❌ data/datasources/
- ❌ data/repositories/

---

## Passo a Passo: Criando uma Nova View

### 1 e 2 — Criar State e Cubit

Crie `<feature>_state.dart` (sealed class com Initial, Loading, Loaded, Error) e `<feature>_cubit.dart`.

Ver skill `implement-view-model` para detalhes.

---

### 3 — Criar a View (UI)

**Arquivo**: `lib/presentation/<feature>/view/<feature>_view.dart`

```dart
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/profile/view_model/profile_cubit.dart';
import 'package:base_app/presentation/profile/view_model/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _cubit = AppInjector.inject.get<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.counterAppBarTitle),
        ),
        body: SafeArea(
          top: false, // AppBar já protege o topo
          child: BlocBuilder<ProfileCubit, ProfileState>(
            bloc: _cubit,
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProfileError) {
                return Center(
                  child: Text(state.message, style: const TextStyle(color: Colors.red)),
                );
              }

              if (state is ProfileLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${l10n.profileNameLabel} ${state.name}'),
                      const SizedBox(height: 8),
                      Text('${l10n.profileEmailLabel} ${state.email}'),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}
```

**Regras da View:**
- ✅ Sempre `StatefulWidget`
- ✅ Obtém Cubit do `AppInjector` (DI)
- ✅ Usa `BlocProvider.value` para fornecer o Cubit
- ✅ Usa `BlocBuilder` para reagir a mudanças de estado
- ✅ Chama `loadData()` no `initState()`
- ✅ Acessa l10n via `context.l10n` e SEMPRE usa para textos visíveis
- ✅ Fecha o Cubit no `dispose()`
- ✅ Trata todos os estados possíveis (Initial, Loading, Loaded, Error)
- ✅ SEMPRE usa `SafeArea`
- ❌ NÃO contém lógica de negócio
- ❌ NÃO faz chamadas HTTP diretamente
- ❌ NÃO cria `Widget _buildXxx()` dentro da View
- ❌ NÃO cria classes privadas de widget dentro da View

---

## Regra de Layout: SafeArea Obrigatório

| Cenário | SafeArea? |
|---|---|
| Scaffold **com** AppBar | ✅ Envolver o `body` com `top: false` (AppBar protege o topo) |
| Scaffold **sem** AppBar | ✅ Envolver o `body` (protege topo e bottom) |
| Tela fullscreen (splash, onboarding) | ✅ Envolver todo o conteúdo principal |
| Modal/BottomSheet | ✅ Envolver conteúdo com `SafeArea(bottom: true)` |

### ✅ CORRETO — SafeArea com AppBar

```dart
body: SafeArea(
  top: false, // AppBar já protege o topo
  child: BlocBuilder<HomeCubit, HomeState>(
    bloc: _cubit,
    builder: (context, state) { /* ... */ },
  ),
),
```

### ✅ CORRETO — SafeArea sem AppBar

```dart
body: SafeArea(
  child: BlocBuilder<SplashCubit, SplashState>(
    bloc: _cubit,
    builder: (context, state) { /* ... */ },
  ),
),
```

---

## Regra de Performance: Sem Widgets Privados na View

No Flutter, métodos `Widget _buildHeader()` **prejudicam o desempenho** porque não têm Element próprio — qualquer mudança de estado reconstrói TODO o método.

### ❌ ERRADO — Métodos privados retornando Widget

```dart
class _HomeViewState extends State<HomeView> {
  Widget _buildHeader(String title) { // ❌ NUNCA faça isso
    return Container(child: Text(title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [_buildHeader('Home')]), // ❌
    );
  }
}
```

### ✅ CORRETO — Classes Widget em `widgets/`

```dart
// lib/presentation/home/widgets/home_header.dart
class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(title));
  }
}
```

### ✅ EXCEÇÃO — Funções para Dialog e BottomSheet

```dart
void _showLanguageDialog(String current) {
  showDialog<void>(context: context, builder: (_) => AlertDialog(/*...*/));
}

void _showOptionsBottomSheet() {
  showModalBottomSheet<void>(context: context, builder: (_) => SafeArea(/*...*/));
}
```

### Tabela de referência

| Tipo | Permitido na View? |
|---|---|
| `void _showXxxDialog()` | ✅ Sim |
| `void _showXxxBottomSheet()` | ✅ Sim |
| `void _onTapXxx()` (handler) | ✅ Sim |
| `Widget _buildXxx()` | ❌ Não — extrair para `widgets/` ou `content/` |
| `class _XxxContent extends StatelessWidget` | ❌ Não — extrair para `content/` |

---

### 4 — Configurar Rota

```dart
// lib/config/routes/app_routes.dart
class AppRoutes {
  static const String profile = '/profile'; // ✅ Adicionar
}

// lib/config/routes/app_router.dart
GoRoute(
  path: AppRoutes.profile,
  builder: (context, state) => const ProfileView(),
),
```

---

### 5 — Registrar Cubit no DI

```dart
// lib/config/inject/app_injector.dart
inject.registerFactory<ProfileCubit>(() => ProfileCubit());
// Com repository:
inject.registerFactory<ProfileCubit>(() => ProfileCubit(inject()));
```

---

## Padrões de UI Comuns

### View com Lista

```dart
if (state is ProfileLoaded) {
  return ListView.builder(
    itemCount: state.items.length,
    itemBuilder: (context, index) {
      final item = state.items[index];
      return ListTile(
        title: Text(item.name),
        onTap: () => _cubit.selectItem(item),
      );
    },
  );
}
```

### View com BlocListener (ações únicas)

```dart
BlocListener<ProfileCubit, ProfileState>(
  listener: (context, state) {
    if (state is ProfileSaved) {
      AppSnackbar.showSucess(context, message: context.l10n.profileSavedMessage);
      context.pop();
    }
  },
  child: BlocBuilder<ProfileCubit, ProfileState>(
    builder: (context, state) { /* ... */ },
  ),
)
```

### View com BlocConsumer

```dart
BlocConsumer<ProfileCubit, ProfileState>(
  listener: (context, state) {
    if (state is ProfileError) {
      AppSnackbar.showError(context, message: state.message);
    }
  },
  builder: (context, state) { /* ... */ },
)
```

### Navegação após ação assíncrona

```dart
// Opção A: navegação direta
ElevatedButton(
  onPressed: () => context.push('/details/${item.id}'),
  child: Text(l10n.detailsButton),
)

// Opção B: estado de navegação
class ProfileNavigateToDetails extends ProfileState {
  const ProfileNavigateToDetails(this.id);
  final String id;
}

BlocListener<ProfileCubit, ProfileState>(
  listener: (context, state) {
    if (state is ProfileNavigateToDetails) context.push('/details/${state.id}');
  },
  child: /* ... */,
)
```

---

## `widgets/` vs `content/` — qual usar?

| Critério | `widgets/` | `content/` |
|---|---|---|
| Pode ser reaproveitado em outro lugar? | ✅ Sim | ❌ Não (específico desta View) |
| É um bloco estrutural/auxiliar da View? | Talvez | ✅ Sim |
| Exemplo | `ProfileCard`, `HomeItemList` | `RecursosContent`, `HomeEmptySection` |

---

## Checklist de Criação

- [ ] 1. Criar `<feature>_state.dart` e `<feature>_cubit.dart`
- [ ] 2. Criar `<feature>_view.dart` (StatefulWidget, SafeArea, BlocBuilder, todos os estados)
- [ ] 3. Adicionar rota em `app_routes.dart`
- [ ] 4. Adicionar `GoRoute` em `app_router.dart`
- [ ] 5. Registrar Cubit em `app_injector.dart`

**Criar depois, SE necessário:**
- [ ] Widgets em `widgets/`
- [ ] Auxiliares em `content/`
- [ ] Entity em `domain/entities/`
- [ ] Repository interface, Model, DataSource, RepositoryImpl

---

## Erros Comuns

| Erro | Correto |
|---|---|
| `import '../widgets/profile_card.dart'` | `import 'package:base_app/...'` |
| `inject.registerSingleton<ProfileCubit>()` | `inject.registerFactory<ProfileCubit>()` |
| Não implementar `dispose()` | `_cubit.close(); super.dispose()` |
| Tratar apenas Loading e Loaded | Tratar Initial, Loading, Loaded, Error |
| Strings hardcoded `Text('Salvar')` | `Text(l10n.saveButton)` |

---

**Última atualização**: 15 de janeiro de 2026
