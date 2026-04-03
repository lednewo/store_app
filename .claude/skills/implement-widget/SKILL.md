---
name: implement-widget
description: Implements Flutter reusable widgets following the project architecture. Use whenever creating or modifying widgets in presentation/<feature>/widgets/ or common/widgets/. Covers StatelessWidget vs StatefulWidget decision, Entity as parameter, i18n, dispose, and componentization rules.
---

# Implement Widget — Flutter

## Leitura Rápida

- **Quando extrair um widget**: bloco de UI maior que 20 linhas ou repetido em mais de um lugar.
- **Quando usar StatelessWidget**: widget apenas renderiza dados recebidos, sem estado interno.
- **Quando usar StatefulWidget**: widget tem controllers, timers ou animações internas.
- **Quando definir parâmetros**: prefira passar a Entity completa em vez de campos individuais.
- **Quando adicionar texto visível**: SEMPRE use `context.l10n` — nunca string hardcoded.
- **Quando tiver controllers/timers**: SEMPRE faça `dispose()` deles.
- **REGRA DE PERFORMANCE**: métodos privados `Widget _buildXxx()` NUNCA devem existir dentro da View — extraia-os como classes Widget em `widgets/`.

---

## Estrutura de Widgets

```
lib/
├── presentation/<feature>/
│   └── widgets/                    # Widgets PRIVADOS da feature
│       ├── <feature>_card.dart
│       ├── <feature>_list_item.dart
│       └── <feature>_form.dart
│
└── common/
    └── widgets/                    # Widgets COMPARTILHADOS
        ├── app_button.dart
        ├── app_input.dart
        └── app_card.dart
```

**Regras:**
- **Widgets privados** (`presentation/<feature>/widgets/`): usados apenas naquela feature
- **Widgets compartilhados** (`common/widgets/`): usados em múltiplas features
- **Comece sempre com widgets privados**; mova para `common/` apenas quando reutilizar

---

## StatelessWidget (Imutável)

Use quando o widget **apenas renderiza** dados recebidos.

### ✅ CORRETO — Entity como parâmetro + i18n

```dart
import 'package:base_app/domain/entities/user_entity.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    required this.user,  // ✅ Entity completa
    super.key,
  });

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;  // ✅ Obtém traduções

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(user.email),
            const SizedBox(height: 4),
            Text(l10n.ageLabel(user.age)),  // ✅ i18n com parâmetro
          ],
        ),
      ),
    );
  }
}
```

**Regras:**
- ✅ Sempre `const` no construtor
- ✅ Todos os campos `final`
- ✅ Recebe entity completa (não campos individuais)
- ✅ Usa `Theme.of(context)` para estilos
- ❌ Não mantém estado interno
- ❌ Não tem controllers ou listeners

---

## StatefulWidget (Mutável)

Use quando o widget tem **estado interno** (controllers, animações, timers).

```dart
import 'package:base_app/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    required this.user,
    required this.onSave,
    super.key,
  });

  final UserEntity user;
  final void Function(String name, String email) onSave;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(_nameController.text, _emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: l10n.nameLabel),
            validator: (v) => v?.isEmpty ?? true ? l10n.nameRequired : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: l10n.emailLabel),
            validator: (v) => v?.isEmpty ?? true ? l10n.emailRequired : null,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _handleSave,
            child: Text(l10n.saveButton),
          ),
        ],
      ),
    );
  }
}
```

**Regras:**
- ✅ Use quando houver controllers, timers, animações
- ✅ Inicialize controllers no `initState()`
- ✅ SEMPRE faça `dispose()` de controllers
- ✅ Use `late final` para controllers
- ✅ Acesse parâmetros via `widget.parametro`
- ✅ Callbacks: `void Function(...)` ou `Future<void> Function(...)`
- ❌ Não crie `StatefulWidget` apenas para receber dados

---

## Widget de Lista (List Item)

```dart
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    required this.product,
    required this.onTap,
    super.key,
  });

  final ProductEntity product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      title: Text(product.name),
      subtitle: Text(l10n.currencyLabel(product.price)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
```

**Uso na View:**
```dart
ListView.builder(
  itemCount: state.products.length,
  itemBuilder: (context, index) {
    final product = state.products[index];
    return ProductListItem(
      product: product,
      onTap: () => _cubit.selectProduct(product),
    );
  },
)
```

---

## Widget com Callback

```dart
class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final ItemEntity item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
```

---

## Quando Criar Widgets

### ✅ CRIE quando:
1. Bloco de UI tem mais de 20 linhas
2. Código se repete em dois ou mais lugares
3. Há separação lógica clara (cabeçalho, card, lista, formulário)

### ❌ NÃO crie quando:
1. É muito simples (< 10 linhas)
2. É usado apenas uma vez e é trivial

---

## Decisão Rápida

```
Precisa de controller/timer/animação?
  ├─ SIM → StatefulWidget
  └─ NÃO → StatelessWidget

Será usado em várias features?
  ├─ SIM → common/widgets/
  └─ NÃO → presentation/<feature>/widgets/

Tem entity relacionada?
  ├─ SIM → prefira passar a entity completa
  └─ NÃO → passe parâmetros primitivos
```

---

## Checklist

- [ ] Tipo correto: Stateless (dados) ou Stateful (estado interno)
- [ ] Entity completa como parâmetro (não campos individuais)
- [ ] Textos via `context.l10n.<chave>`
- [ ] `dispose()` implementado para controllers/timers
- [ ] Localização: `presentation/<feature>/widgets/` ou `common/widgets/`

---

## Erros Comuns

| Erro | Correto |
|---|---|
| `UserCard(name: user.name, email: user.email)` | `UserCard(user: user)` |
| `StatefulWidget` sem estado interno | `StatelessWidget` |
| `TextEditingController` sem `dispose()` | Implementar `dispose()` com `_controller.dispose()` |
| Widget com 3 linhas extraído desnecessariamente | Use `Text(...)` inline |
| Strings hardcoded `Text('Nome:')` | `Text(l10n.nameLabel)` |

---

**Última atualização**: 15 de janeiro de 2026
