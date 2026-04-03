---
name: implement-view-model
description: Implements Flutter Cubit and State (View Model layer) following the project architecture. Use whenever creating or modifying a Cubit or State class. Covers sealed States, async patterns with Result<T>, CRUD Cubits, debounce, navigation states and common mistakes.
---

# Implement View Model (Cubit e State) — Flutter

## Leitura Rápida

- **Quando criar um State**: SEMPRE `sealed class` + `@immutable` + `const`; mínimo obrigatório: `Initial`, `Loading`, `Loaded`, `Error`.
- **Quando criar um Cubit**: receba dependências via construtor; NUNCA injete DataSource diretamente — use Repository.
- **Quando escrever um método async no Cubit**: SEMPRE emita `Loading` primeiro → chame o repository → use `result.when()`.
- **Quando emitir erro**: converta a exceção técnica em mensagem amigável ao usuário.
- **Quando o Cubit precisar navegar**: emita um estado de navegação (`XNavigateToY`) e deixe a View reagir via `BlocListener`.

---

## Estrutura

```
lib/presentation/<feature>/view_model/
├── <feature>_state.dart        # Estados da feature
└── <feature>_cubit.dart        # Gerenciador de estado
```

---

## Criando States

### Template Base

```dart
import 'package:flutter/foundation.dart';

@immutable
sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.name,
    required this.email,
  });

  final String name;
  final String email;
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;
}
```

### Regras Obrigatórias para States

1. **SEMPRE sealed class** — pattern matching exaustivo
2. **SEMPRE @immutable**
3. **SEMPRE const** no construtor
4. **Propriedades SEMPRE final**
5. **Estados mínimos**: Initial, Loading, Loaded, Error
6. **NUNCA adicione métodos** — apenas dados

---

## Tipos de State por Feature

### Feature CRUD

```dart
@immutable
sealed class ProductsState { const ProductsState(); }

class ProductsInitial extends ProductsState { const ProductsInitial(); }
class ProductsLoading extends ProductsState { const ProductsLoading(); }
class ProductsLoaded extends ProductsState {
  const ProductsLoaded({required this.products});
  final List<ProductEntity> products;
}
class ProductsCreating extends ProductsState { const ProductsCreating(); }
class ProductsUpdating extends ProductsState { const ProductsUpdating(); }
class ProductsDeleting extends ProductsState { const ProductsDeleting(); }
class ProductsError extends ProductsState {
  const ProductsError(this.message);
  final String message;
}
```

### Feature com Formulário

```dart
@immutable
sealed class RegisterState { const RegisterState(); }

class RegisterInitial extends RegisterState { const RegisterInitial(); }
class RegisterValidating extends RegisterState { const RegisterValidating(); }
class RegisterSubmitting extends RegisterState { const RegisterSubmitting(); }
class RegisterSuccess extends RegisterState {
  const RegisterSuccess({required this.userId});
  final String userId;
}
class RegisterError extends RegisterState {
  const RegisterError(this.message);
  final String message;
}
class RegisterFieldError extends RegisterState {
  const RegisterFieldError({this.emailError, this.passwordError});
  final String? emailError;
  final String? passwordError;
}
```

### Feature com Paginação

```dart
@immutable
sealed class PostsState { const PostsState(); }

class PostsInitial extends PostsState { const PostsInitial(); }
class PostsLoading extends PostsState { const PostsLoading(); }
class PostsLoaded extends PostsState {
  const PostsLoaded({required this.posts, required this.hasMore});
  final List<PostEntity> posts;
  final bool hasMore;
}
class PostsLoadingMore extends PostsState {
  const PostsLoadingMore({required this.currentPosts});
  final List<PostEntity> currentPosts;
}
class PostsError extends PostsState {
  const PostsError(this.message);
  final String message;
}
```

---

## Criando Cubits

### Opção A: Cubit Simples (Sem Repository)

```dart
import 'package:base_app/presentation/<feature>/view_model/<feature>_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial());

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    try {
      emit(const ProfileLoaded(name: 'Nome', email: 'email@example.com'));
    } catch (e) {
      emit(ProfileError('Erro ao carregar: $e'));
    }
  }
}
```

### Opção B: Cubit com Repository (API/DB)

```dart
import 'package:base_app/domain/interfaces/<feature>_repository.dart';
import 'package:base_app/presentation/<feature>/view_model/<feature>_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repository) : super(const ProfileInitial());

  final ProfileRepository _repository;

  Future<void> loadProfile() async {
    emit(const ProfileLoading());

    final result = await _repository.getData();

    result.when(
      ok: (data) => emit(ProfileLoaded(name: data.name, email: data.email)),
      error: (e) => emit(ProfileError('Erro ao carregar: $e')),
    );
  }
}
```

### Opção C: Cubit CRUD Completo

```dart
class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsInitial());

  final ProductsRepository _repository;

  Future<void> loadAll() async {
    emit(const ProductsLoading());
    final result = await _repository.getAll();
    result.when(
      ok: (data) => emit(ProductsLoaded(products: data)),
      error: (e) => emit(ProductsError('Erro ao carregar: $e')),
    );
  }

  Future<void> create(ProductEntity entity) async {
    emit(const ProductsCreating());
    final result = await _repository.create(entity);
    result.when(ok: (_) => loadAll(), error: (e) => emit(ProductsError('Erro ao criar: $e')));
  }

  Future<void> update(ProductEntity entity) async {
    emit(const ProductsUpdating());
    final result = await _repository.update(entity);
    result.when(ok: (_) => loadAll(), error: (e) => emit(ProductsError('Erro ao atualizar: $e')));
  }

  Future<void> delete(String id) async {
    emit(const ProductsDeleting());
    final result = await _repository.delete(id);
    result.when(ok: (_) => loadAll(), error: (e) => emit(ProductsError('Erro ao deletar: $e')));
  }
}
```

---

## Regras Obrigatórias para Cubits

1. **Sempre herda de Cubit** — `class XCubit extends Cubit<XState>`
2. **Estado inicial no construtor** — `: super(const XInitial())`
3. **Sempre emite Loading antes de operações assíncronas**
4. **Usa `result.when()`** para tratar `Result<T>`
5. **Converte erros técnicos em mensagens amigáveis**
6. **NUNCA acessa DataSources diretamente** — use Repository
7. **NUNCA contém lógica de UI** (cores, tamanhos, etc.)

### ✅ result.when() vs switch — qual usar?

```dart
// ✅ result.when() — preferido, mais conciso
result.when(
  ok: (data) => emit(LoginSuccess(user: data)),
  error: (e) => emit(LoginError('$e')),
);

// ✅ switch com destructuring — para lógica complexa
switch (result) {
  case Ok<User>(:final value):
    emit(LoginSuccess(user: value));
  case Error<User>(:final error):
    emit(LoginError('$error'));
}

// ❌ if/else — nunca use
if (result is Ok) { emit(LoginSuccess()); }
```

---

## Padrões Comuns

### Atualizar Campo Individual

```dart
void updateEmail(String email) {
  final currentState = state;
  if (currentState is LoginLoaded) {
    emit(LoginLoaded(email: email, password: currentState.password));
  }
}
```

### Debounce (Busca com Delay)

```dart
import 'dart:async';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(const SearchInitial());

  final SearchRepository _repository;
  Timer? _debounce;

  void search(String query) {
    _debounce?.cancel();
    if (query.isEmpty) { emit(const SearchInitial()); return; }
    emit(const SearchLoading());
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final result = await _repository.search(query);
      result.when(
        ok: (data) => emit(SearchLoaded(results: data)),
        error: (e) => emit(SearchError('Erro na busca')),
      );
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
```

### Estado de Navegação

```dart
class LoginNavigateToHome extends LoginState {
  const LoginNavigateToHome();
}

// No Cubit
result.when(
  ok: (_) => emit(const LoginNavigateToHome()),
  error: (e) => emit(LoginError('Credenciais inválidas')),
);

// Na View
BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginNavigateToHome) context.go(AppRoutes.home);
  },
  child: /* ... */,
)
```

---

## Checklist

### State:
- [ ] Arquivo em `lib/presentation/<feature>/view_model/<feature>_state.dart`
- [ ] `@immutable` + `sealed class`
- [ ] Estados mínimos: Initial, Loading, Loaded, Error
- [ ] Propriedades `final`, construtores `const`

### Cubit:
- [ ] Arquivo em `lib/presentation/<feature>/view_model/<feature>_cubit.dart`
- [ ] Extende `Cubit<XState>`, estado inicial no construtor
- [ ] Repository via construtor (não DataSource)
- [ ] Emite Loading antes de async
- [ ] Usa `result.when()` para tratar `Result<T>`

### Registro no DI:
```dart
inject.registerFactory<LoginCubit>(() => LoginCubit(inject()));
```

---

## Erros Comuns

| Erro | Correto |
|---|---|
| `abstract class LoginState` | `sealed class LoginState` |
| Sem `@immutable` | `@immutable sealed class LoginState` |
| Sem `emit(Loading)` antes de async | `emit(const XLoading()); final result = await...` |
| `if (result is Ok)` | `result.when(ok: ..., error: ...)` |
| Cubit recebe DataSource | Cubit recebe Repository |
| Propriedade `String name` sem `final` | `final String name` |

---

**Última atualização**: 15 de janeiro de 2026
