---
name: analyze-view
description: Analyzes Flutter View widgets for compliance with project architecture standards: BlocBuilder usage, SafeArea protection, l10n strings, no widget-returning private methods, correct DI via AppInjector, and proper state handling. Use when reviewing, auditing, or refactoring Flutter view files in this project.
---

# Analyze View — Flutter Architecture Compliance

Analisa arquivos de View Flutter e verifica conformidade com as instruções do projeto.

## Antes de analisar

Leia as instruções relevantes:
- `.github/instructions/architecture.instructions.md`

## Escopo de análise

### 1. Estrutura e Arquitetura
- [ ] Arquivo está em `lib/presentation/<feature>/view/<feature>_view.dart`
- [ ] `StatefulWidget` com `_FeatureViewState`
- [ ] Cubit obtido via `AppInjector.inject.get<FeatureCubit>()` — não via `BlocProvider`
- [ ] `_cubit.close()` chamado no `dispose()`
- [ ] Dados carregados no `initState()` (não em `didChangeDependencies`)
- [ ] `BlocBuilder<Cubit, State>` com `bloc: _cubit` explícito
- [ ] **Todos** os estados tratados: Initial, Loading, Loaded, Error
- [ ] Ausência de lógica de negócio, chamadas HTTP diretas
- [ ] Imports absolutos (`package:base_app/...`) — zero imports relativos

### 2. SafeArea
- [ ] **Scaffold com AppBar** → `SafeArea(top: false, child: ...)` no body
- [ ] **Scaffold sem AppBar** → `SafeArea(child: Scaffold(...))` envolvendo tudo
- [ ] **Tela fullscreen** → `SafeArea` envolvendo conteúdo principal
- [ ] **Modal/BottomSheet** → `SafeArea(bottom: true)` no conteúdo

### 3. Internacionalização (l10n)
- [ ] Todos os textos visíveis ao usuário usam `context.l10n.<chave>`
- [ ] Zero strings hardcoded (ex: `Text('Login')`, `AppBar(title: Text('Home'))`)
- [ ] Chaves existem nos arquivos `lib/l10n/arb/app_en.arb` e `app_pt.arb`

### 4. Performance — Widgets Privados e Classes Privadas
Verificar ausência de métodos `Widget _buildXxx()` e classes privadas de widget dentro do arquivo de View:

| Padrão | Status | Ação |
|---|---|---|
| `Widget _buildXxx(...)` | ❌ Proibido | Extrair para classe em `widgets/` ou `content/` |
| `Widget _createXxx(...)` | ❌ Proibido | Extrair para classe em `widgets/` ou `content/` |
| `List<Widget> _buildXxxItems(...)` | ❌ Proibido | Extrair para classe em `widgets/` ou `content/` |
| `class _XxxContent extends StatelessWidget` | ❌ Proibido | Mover para `content/<feature>_content.dart` |
| `class _XxxWidget extends StatefulWidget` | ❌ Proibido | Mover para `widgets/` ou `content/` |
| `void _showXxxDialog()` | ✅ OK | Abre dialog — não retorna widget |
| `void _showXxxBottomSheet()` | ✅ OK | Abre bottomSheet |
| `void _onTapXxx()` | ✅ OK | Event handler |

**Dist: `widgets/` vs `content/`**: se a classe é reaproveitável (mesmo dentro da feature), vai para `widgets/`; se é um auxiliar específico de UMA única View, vai para `content/`.

### 5. Navegação
- [ ] Navegação usando `context.go()`, `context.push()`, `context.pop()` (GoRouter)
- [ ] `.go()` / `.push()` na View ou em `BlocListener` — NUNCA no Cubit

## Formato de saída

Para cada arquivo analisado:

```
### <nome_do_arquivo>.dart

**Status:** ✅ Conforme | ⚠️ Não conforme

#### Não conformidades encontradas:
1. [categoria] Descrição do problema
   - Linha: X
   - Atual: `código atual`
   - Correção: `código corrigido`

#### Resumo:
- ✅ N itens conformes
- ❌ N itens não conformes
```

## Após análise

Se houver não conformidades:
1. Implemente as correções diretamente (não apenas liste)
2. Se extraiu widgets reutilizáveis, crie os arquivos em `presentation/<feature>/widgets/`
3. Se extraiu classes auxiliares específicas da View, crie os arquivos em `presentation/<feature>/content/`
4. Rode `flutter analyze` para confirmar ausência de erros
5. Rode `flutter gen-l10n` se strings l10n foram adicionadas
