# Riverpod Guide: Complete Reference

## Table of Contents

1. [Riverpod Basics](#riverpod-basics)
2. [Provider Types](#provider-types)
3. [State Management](#state-management)
4. [Dependency Injection](#dependency-injection)
5. [Async Data](#async-data)
6. [Best Practices](#best-practices)
7. [Common Patterns](#common-patterns)

---

## Riverpod Basics

### What is Riverpod?

Riverpod is a reactive state management and dependency injection framework for Flutter. It's a complete rewrite of Provider with improvements:

- ✅ Compile-time safety
- ✅ No BuildContext needed
- ✅ Better testability
- ✅ Automatic disposal
- ✅ Family & autoDispose modifiers

### Installation

```yaml
# pubspec.yaml
dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1 # Optional: code generation

dev_dependencies:
  riverpod_generator: ^2.6.2 # Optional: code generation
  build_runner: ^2.4.0 # Optional: code generation
```

### Basic Setup

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(  // Wrap your app
      child: MyApp(),
    ),
  );
}

// In widgets
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(someProvider);
    return Text('$value');
  }
}
```

---

## Provider Types

### 1. Provider (Immutable, Never Changes)

**What it is:** Returns a value that never changes during app lifecycle.

```dart
// Simple value
final helloWorldProvider = Provider<String>((ref) {
  return 'Hello, World!';
});

// Computed value from other providers
final taxRateProvider = Provider<double>((ref) {
  return 0.18; // 18% tax
});

final totalPriceProvider = Provider<double>((ref) {
  final price = ref.watch(priceProvider);
  final taxRate = ref.watch(taxRateProvider);
  return price * (1 + taxRate);
});
```

**What changes:**

- ❌ The value never changes
- ✅ Can depend on other providers
- ✅ Recalculates when dependencies change

**Use when:**

- Constants
- Configuration
- Computed values from other providers
- Services/repositories (dependency injection)

**Example:**

```dart
// Repository provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// API client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://api.example.com');
});

// Use in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Text('Database ready');
  }
}
```

### 2. StateProvider (Simple Mutable State)

**What it is:** Exposes a way to modify simple state (like int, String, bool).

```dart
// Counter example
final counterProvider = StateProvider<int>((ref) {
  return 0; // Initial value
});

// In widget
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),
        FilledButton(
          // Update state
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('Increment'),
        ),
        FilledButton(
          // Set state
          onPressed: () => ref.read(counterProvider.notifier).state = 0,
          child: Text('Reset'),
        ),
      ],
    );
  }
}
```

**What changes:**

- ✅ State can be updated directly
- ✅ Widgets rebuild when state changes
- ✅ Simple to use for basic state

**Use when:**

- Simple values (counter, toggle, selected index)
- Filter/sort options
- UI state (dropdown selection, text input)

**Don't use when:**

- Complex state logic (use StateNotifier/Notifier instead)
- Need validation
- Side effects on state change

### 3. StateNotifierProvider (Complex State with Logic)

**What it is:** Manages state with a class that contains business logic.

```dart
// State class (immutable)
@immutable
class Counter {
  final int value;
  final String message;

  Counter({required this.value, required this.message});

  Counter copyWith({int? value, String? message}) {
    return Counter(
      value: value ?? this.value,
      message: message ?? this.message,
    );
  }
}

// StateNotifier (contains logic)
class CounterNotifier extends StateNotifier<Counter> {
  CounterNotifier() : super(Counter(value: 0, message: 'Ready'));

  void increment() {
    state = state.copyWith(
      value: state.value + 1,
      message: 'Incremented!',
    );
  }

  void decrement() {
    if (state.value > 0) {
      state = state.copyWith(
        value: state.value - 1,
        message: 'Decremented!',
      );
    }
  }

  void reset() {
    state = Counter(value: 0, message: 'Reset');
  }
}

// Provider
final counterProvider = StateNotifierProvider<CounterNotifier, Counter>((ref) {
  return CounterNotifier();
});

// In widget
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);
    final notifier = ref.read(counterProvider.notifier);

    return Column(
      children: [
        Text('Count: ${counter.value}'),
        Text('Message: ${counter.message}'),
        FilledButton(
          onPressed: notifier.increment,
          child: Text('Increment'),
        ),
        FilledButton(
          onPressed: notifier.reset,
          child: Text('Reset'),
        ),
      ],
    );
  }
}
```

**What changes:**

- ✅ State is immutable (must create new state)
- ✅ Business logic in notifier
- ✅ Type-safe state management
- ✅ Easy to test

**Use when:**

- Complex state with multiple properties
- Need business logic
- Validation required
- Side effects on state change

### 4. NotifierProvider (Modern Replacement for StateNotifier)

**What it is:** New Riverpod 2.0+ way to manage state (replaces StateNotifier).

```dart
// Using code generation (recommended)
@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    return 0; // Initial state
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state > 0) state--;
  }
}

// Manual (without code generation)
class CounterNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }
}

final counterProvider = NotifierProvider<CounterNotifier, int>(() {
  return CounterNotifier();
});

// In widget (same as StateNotifierProvider)
final count = ref.watch(counterProvider);
ref.read(counterProvider.notifier).increment();
```

**What changes:**

- ✅ Simpler than StateNotifier
- ✅ Access to `ref` inside notifier
- ✅ Better for dependency injection
- ✅ Code generation support

**Use when:**

- Same cases as StateNotifierProvider
- Want modern Riverpod approach
- Using code generation

### 5. FutureProvider (Async Data, One-Time)

**What it is:** Provides async data (Future) that loads once.

```dart
// Fetch user
final userProvider = FutureProvider<User>((ref) async {
  final api = ref.watch(apiClientProvider);
  return await api.fetchUser();
});

// In widget
class UserWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) => Text('Hello ${user.name}'),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

**What changes:**

- ✅ Loads data asynchronously
- ✅ Caches result
- ✅ Shows loading/error/data states
- ❌ Doesn't refresh automatically (use AsyncNotifier for that)

**Use when:**

- One-time data fetch
- API calls that don't change
- Configuration from network

### 6. AsyncNotifierProvider (Async State with Logic)

**What it is:** Manages async state that can be refreshed/updated.

```dart
// Using code generation (recommended)
@riverpod
class Users extends _$Users {
  @override
  Future<List<User>> build() async {
    // Load initial data
    final api = ref.watch(apiClientProvider);
    return await api.fetchUsers();
  }

  Future<void> addUser(User user) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(apiClientProvider);
      await api.addUser(user);
      return await api.fetchUsers(); // Refresh list
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(apiClientProvider);
      return await api.fetchUsers();
    });
  }
}

// In widget
class UsersWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return usersAsync.when(
      data: (users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(users[index].name),
        ),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

**What changes:**

- ✅ Async state with loading/error/data
- ✅ Can refresh/update
- ✅ Business logic included
- ✅ Easy error handling

**Use when:**

- API calls that need refresh
- CRUD operations
- Real-time data
- Complex async logic

### 7. StreamProvider (Continuous Data Stream)

**What it is:** Provides data from a Stream (continuous updates).

```dart
// Firestore stream
final messagesProvider = StreamProvider<List<Message>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('messages').snapshots().map(
    (snapshot) => snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList(),
  );
});

// In widget
class MessagesWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider);

    return messagesAsync.when(
      data: (messages) => ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) => Text(messages[index].text),
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

**What changes:**

- ✅ Continuous updates from stream
- ✅ Auto-disposes stream
- ✅ Loading/error/data states

**Use when:**

- WebSocket connections
- Firestore/Realtime DB
- Stream-based APIs
- Real-time updates

---

## State Management

### Reading State

#### 1. ref.watch() - Rebuild on Change

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuilds when counterProvider changes
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}
```

**What happens:**

- Widget rebuilds when state changes
- Subscribes to provider
- Automatically disposes subscription

**Use when:**

- Displaying state in UI
- Reactive updates needed

#### 2. ref.read() - One-Time Read (No Rebuild)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: () {
        // Reads once, no rebuild
        final notifier = ref.read(counterProvider.notifier);
        notifier.increment();
      },
      child: Text('Increment'),
    );
  }
}
```

**What happens:**

- Reads current value once
- Does NOT rebuild on changes
- No subscription created

**Use when:**

- Event handlers (onPressed, onChange)
- Reading notifiers to call methods
- One-time value access

**❌ DON'T use in build method:**

```dart
// BAD - Won't rebuild!
Widget build(BuildContext context, WidgetRef ref) {
  final count = ref.read(counterProvider); // Wrong!
  return Text('$count');
}
```

#### 3. ref.listen() - Side Effects on Change

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for changes, perform side effects
    ref.listen<int>(counterProvider, (previous, next) {
      if (next > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Counter exceeded 10!')),
        );
      }
    });

    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}
```

**What happens:**

- Fires callback when state changes
- Doesn't trigger rebuild
- Access to previous and next values

**Use when:**

- Show snackbars/dialogs on state change
- Navigation based on state
- Logging/analytics
- Side effects

### Updating State

#### StateProvider

```dart
// Set directly
ref.read(counterProvider.notifier).state = 5;

// Update
ref.read(counterProvider.notifier).state++;

// Based on current
ref.read(counterProvider.notifier).update((state) => state + 1);
```

#### StateNotifier/Notifier

```dart
// Call methods on notifier
ref.read(counterProvider.notifier).increment();
ref.read(counterProvider.notifier).reset();
```

#### AsyncNotifier

```dart
// Call async methods
await ref.read(usersProvider.notifier).addUser(user);
await ref.read(usersProvider.notifier).refresh();
```

---

## Dependency Injection

### Injecting Services

```dart
// Database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Repository depends on database
final housesRepositoryProvider = Provider<HousesRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return HousesRepository(database);
});

// Use case depends on repository
final getHousesUseCaseProvider = Provider<GetHousesUseCase>((ref) {
  final repository = ref.watch(housesRepositoryProvider);
  return GetHousesUseCase(repository);
});

// Controller depends on use case
final housesControllerProvider = StateNotifierProvider<HousesController, AsyncValue<List<House>>>((ref) {
  final getHousesUseCase = ref.watch(getHousesUseCaseProvider);
  return HousesController(getHousesUseCase);
});
```

**What this does:**

- Creates dependency chain
- Each provider accesses dependencies via `ref.watch()`
- Automatic disposal in correct order

### Provider Invalidation (Refresh)

```dart
// Invalidate single provider
ref.invalidate(housesProvider);

// Provider will rebuild and refetch data
final houses = ref.watch(housesProvider);
```

**Use when:**

- After CRUD operations
- Forcing data refresh
- Clearing cache

### Provider Refresh

```dart
// Refresh async provider
await ref.refresh(usersProvider.future);

// Refresh and wait for result
final newUsers = await ref.refresh(usersProvider.future);
```

---

## Async Data

### AsyncValue States

```dart
final usersAsync = ref.watch(usersProvider);

// Pattern 1: when()
usersAsync.when(
  data: (users) => ListView.builder(/* ... */),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);

// Pattern 2: Pattern matching
switch (usersAsync) {
  case AsyncData(:final value):
    return Text('Loaded ${value.length} users');
  case AsyncLoading():
    return CircularProgressIndicator();
  case AsyncError(:final error):
    return Text('Error: $error');
}

// Pattern 3: value/hasValue
if (usersAsync.hasValue) {
  final users = usersAsync.value!;
  return Text('${users.length} users');
}

// Pattern 4: valueOrNull
final users = usersAsync.valueOrNull ?? [];
return Text('${users.length} users');
```

### Loading States with Data

```dart
// Show old data while loading new
usersAsync.when(
  data: (users) => UserList(users: users),
  loading: () => UserList(users: []), // or previous data
  error: (error, stack) => ErrorWidget(error),
);

// Better: Show loading indicator over old data
usersAsync.whenData((users) {
  return Stack(
    children: [
      UserList(users: users),
      if (usersAsync.isLoading)
        LinearProgressIndicator(),
    ],
  );
});
```

### Error Handling

```dart
// In AsyncNotifier
Future<void> addUser(User user) async {
  state = const AsyncValue.loading();

  state = await AsyncValue.guard(() async {
    // This try-catch is automatic
    final api = ref.read(apiClientProvider);
    await api.addUser(user);
    return await api.fetchUsers();
  });

  // Check if error occurred
  if (state.hasError) {
    // Log error, show message, etc.
    print('Error adding user: ${state.error}');
  }
}

// In UI
ref.listen<AsyncValue<List<User>>>(usersProvider, (previous, next) {
  if (next.hasError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${next.error}')),
    );
  }
});
```

---

## Best Practices

### ✅ DO: Use Provider for DI

```dart
// Good - Services as providers
final apiProvider = Provider<ApiClient>((ref) => ApiClient());
final dbProvider = Provider<AppDatabase>((ref) => AppDatabase());
final repoProvider = Provider<Repository>((ref) {
  final api = ref.watch(apiProvider);
  final db = ref.watch(dbProvider);
  return Repository(api: api, db: db);
});
```

### ✅ DO: Keep State Immutable

```dart
// Good - Immutable state
@immutable
class TodosState {
  final List<Todo> items;
  final bool isLoading;

  TodosState({required this.items, required this.isLoading});

  TodosState copyWith({List<Todo>? items, bool? isLoading}) {
    return TodosState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Update state
state = state.copyWith(items: newItems);
```

### ✅ DO: Use .family for Parameters

```dart
// Provider with parameter
final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  final api = ref.watch(apiProvider);
  return await api.fetchUser(userId);
});

// Use in widget
final user = ref.watch(userProvider('user123'));
```

### ✅ DO: Use .autoDispose for Short-Lived State

```dart
// Auto-dispose when no longer used
final searchProvider = FutureProvider.autoDispose.family<List<Product>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];
    final api = ref.watch(apiProvider);
    return await api.search(query);
  },
);

// Disposed when widget unmounted
final results = ref.watch(searchProvider(searchQuery));
```

### ✅ DO: Combine Providers

```dart
final selectedUserIdProvider = StateProvider<String?>((ref) => null);

final selectedUserProvider = Provider<User?>((ref) {
  final userId = ref.watch(selectedUserIdProvider);
  if (userId == null) return null;

  // Watch another provider
  final usersAsync = ref.watch(usersProvider);
  return usersAsync.valueOrNull?.firstWhere((u) => u.id == userId);
});
```

### ✅ DO: Use ConsumerWidget/ConsumerStatefulWidget

```dart
// For StatelessWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(someProvider);
    return Text('$value');
  }
}

// For StatefulWidget
class MyWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<MyWidget> {
  @override
  Widget build(BuildContext context) {
    final value = ref.watch(someProvider);
    return Text('$value');
  }
}

// Or use Consumer widget
Consumer(
  builder: (context, ref, child) {
    final value = ref.watch(someProvider);
    return Text('$value');
  },
)
```

### ✅ DO: Invalidate After Mutations

```dart
class TodosController extends Notifier<AsyncValue<List<Todo>>> {
  // ...

  Future<void> addTodo(Todo todo) async {
    final api = ref.read(apiProvider);
    await api.addTodo(todo);

    // Refresh the list
    ref.invalidateSelf(); // or ref.invalidate(todosProvider)
  }
}
```

### ❌ DON'T: Use ref.read() in build()

```dart
// BAD - Won't rebuild
Widget build(BuildContext context, WidgetRef ref) {
  final count = ref.read(counterProvider); // Wrong!
  return Text('$count');
}

// GOOD - Rebuilds on change
Widget build(BuildContext context, WidgetRef ref) {
  final count = ref.watch(counterProvider);
  return Text('$count');
}
```

### ❌ DON'T: Watch Providers in Event Handlers

```dart
// BAD - Creates subscription in callback
onPressed: () {
  final count = ref.watch(counterProvider); // Wrong!
  print(count);
}

// GOOD - Use read for one-time access
onPressed: () {
  final count = ref.read(counterProvider);
  print(count);
}
```

### ❌ DON'T: Mutate State Directly

```dart
// BAD - Direct mutation
class TodosNotifier extends Notifier<List<Todo>> {
  void addTodo(Todo todo) {
    state.add(todo); // Wrong! State is mutable
    state = state; // This won't trigger rebuild
  }
}

// GOOD - Create new state
class TodosNotifier extends Notifier<List<Todo>> {
  void addTodo(Todo todo) {
    state = [...state, todo]; // New list
  }
}
```

### ❌ DON'T: Create Providers Inside Widgets

```dart
// BAD - Don't create providers in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = StateProvider<int>((ref) => 0); // Wrong!
    return Text('...');
  }
}

// GOOD - Create providers at top level
final counterProvider = StateProvider<int>((ref) => 0);

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
```

---

## Common Patterns

### Pattern 1: CRUD Operations

```dart
@riverpod
class TodosController extends _$TodosController {
  @override
  Future<List<Todo>> build() async {
    final repo = ref.watch(todosRepositoryProvider);
    return await repo.getTodos();
  }

  Future<void> addTodo(Todo todo) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(todosRepositoryProvider);
      await repo.addTodo(todo);
      return await repo.getTodos();
    });
  }

  Future<void> updateTodo(Todo todo) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(todosRepositoryProvider);
      await repo.updateTodo(todo);
      return await repo.getTodos();
    });
  }

  Future<void> deleteTodo(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(todosRepositoryProvider);
      await repo.deleteTodo(id);
      return await repo.getTodos();
    });
  }
}

// In UI
class TodosScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todosControllerProvider);

    return todosAsync.when(
      data: (todos) => ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ref.read(todosControllerProvider.notifier).deleteTodo(todo.id);
              },
            ),
          );
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### Pattern 2: Search/Filter

```dart
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final productsAsync = ref.watch(productsProvider);

  final products = productsAsync.valueOrNull ?? [];

  if (query.isEmpty) return products;

  return products.where((p) =>
    p.name.toLowerCase().contains(query.toLowerCase())
  ).toList();
});

// In UI
class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = ref.watch(filteredProductsProvider);

    return Column(
      children: [
        TextField(
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
          decoration: InputDecoration(hintText: 'Search'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(filtered[index].name),
            ),
          ),
        ),
      ],
    );
  }
}
```

### Pattern 3: Pagination

```dart
@riverpod
class PaginatedProducts extends _$PaginatedProducts {
  int _page = 1;
  List<Product> _allProducts = [];

  @override
  Future<List<Product>> build() async {
    return _fetchPage(_page);
  }

  Future<List<Product>> _fetchPage(int page) async {
    final api = ref.read(apiProvider);
    return await api.fetchProducts(page: page, limit: 20);
  }

  Future<void> loadMore() async {
    if (state.isLoading) return;

    _page++;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final newProducts = await _fetchPage(_page);
      _allProducts = [..._allProducts, ...newProducts];
      return _allProducts;
    });
  }

  Future<void> refresh() async {
    _page = 1;
    _allProducts = [];
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPage(_page));
  }
}

// In UI
class ProductsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(paginatedProductsProvider);

    return productsAsync.when(
      data: (products) => ListView.builder(
        itemCount: products.length + 1,
        itemBuilder: (context, index) {
          if (index == products.length) {
            // Load more button
            return FilledButton(
              onPressed: () {
                ref.read(paginatedProductsProvider.notifier).loadMore();
              },
              child: Text('Load More'),
            );
          }
          return ListTile(title: Text(products[index].name));
        },
      ),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### Pattern 4: Form State Management

```dart
@riverpod
class LoginForm extends _$LoginForm {
  @override
  LoginFormState build() {
    return LoginFormState(
      email: '',
      password: '',
      isSubmitting: false,
      errorMessage: null,
    );
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email, errorMessage: null);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password, errorMessage: null);
  }

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final auth = ref.read(authProvider);
      await auth.login(state.email, state.password);
      // Navigate on success
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.toString(),
      );
    }
  }
}

@immutable
class LoginFormState {
  final String email;
  final String password;
  final bool isSubmitting;
  final String? errorMessage;

  LoginFormState({
    required this.email,
    required this.password,
    required this.isSubmitting,
    this.errorMessage,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// In UI
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginFormProvider);
    final notifier = ref.read(loginFormProvider.notifier);

    return Column(
      children: [
        TextField(
          onChanged: notifier.updateEmail,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        TextField(
          onChanged: notifier.updatePassword,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
        ),
        if (formState.errorMessage != null)
          Text(formState.errorMessage!, style: TextStyle(color: Colors.red)),
        FilledButton(
          onPressed: formState.isSubmitting ? null : notifier.submit,
          child: formState.isSubmitting
              ? CircularProgressIndicator()
              : Text('Login'),
        ),
      ],
    );
  }
}
```

### Pattern 5: Dependent Providers

```dart
// Selected house
final selectedHouseIdProvider = StateProvider<String?>((ref) => null);

// Cycles for selected house
final cyclesForHouseProvider = FutureProvider<List<Cycle>>((ref) async {
  final houseId = ref.watch(selectedHouseIdProvider);
  if (houseId == null) return [];

  final repo = ref.watch(cyclesRepositoryProvider);
  return await repo.getCyclesForHouse(houseId);
});

// Selected cycle
final selectedCycleIdProvider = StateProvider<String?>((ref) => null);

// Readings for selected cycle
final readingsForCycleProvider = FutureProvider<List<Reading>>((ref) async {
  final cycleId = ref.watch(selectedCycleIdProvider);
  if (cycleId == null) return [];

  final repo = ref.watch(readingsRepositoryProvider);
  return await repo.getReadingsForCycle(cycleId);
});
```

---

## Quick Reference

### Provider Types Comparison

| Provider                | State              | Mutable | Use Case                      |
| ----------------------- | ------------------ | ------- | ----------------------------- |
| `Provider`              | Never changes      | ❌      | Services, constants, computed |
| `StateProvider`         | Simple value       | ✅      | Counters, toggles, selections |
| `StateNotifierProvider` | Complex with logic | ✅      | Business logic, validation    |
| `NotifierProvider`      | Modern complex     | ✅      | Same as StateNotifier (newer) |
| `FutureProvider`        | Async, one-time    | ❌      | Initial data load             |
| `AsyncNotifierProvider` | Async with logic   | ✅      | CRUD, refreshable data        |
| `StreamProvider`        | Continuous stream  | ❌      | Real-time updates             |

### Reading Methods

| Method         | Rebuilds | Use Case                    |
| -------------- | -------- | --------------------------- |
| `ref.watch()`  | ✅ Yes   | In build(), display state   |
| `ref.read()`   | ❌ No    | In callbacks, one-time read |
| `ref.listen()` | ❌ No    | Side effects on change      |

### Modifiers

| Modifier       | Effect                         |
| -------------- | ------------------------------ |
| `.family`      | Provider with parameters       |
| `.autoDispose` | Auto-dispose when unused       |
| `.future`      | Get Future from async provider |
| `.notifier`    | Get notifier to call methods   |

---

## Summary

### Key Concepts

1. **Providers are global** - Define at top level
2. **ref.watch in build** - Auto-rebuilds
3. **ref.read in callbacks** - No rebuild
4. **Immutable state** - Always create new state
5. **Async handling** - Use AsyncValue.when()
6. **Dependency injection** - Providers depend on providers
7. **Auto-disposal** - Use .autoDispose for short-lived state

### Common Patterns

```dart
// 1. Simple state
final counterProvider = StateProvider<int>((ref) => 0);

// 2. Complex state
final todosProvider = NotifierProvider<TodosNotifier, List<Todo>>(
  () => TodosNotifier(),
);

// 3. Async data
final usersProvider = FutureProvider<List<User>>((ref) async {
  return await fetchUsers();
});

// 4. Dependency
final repoProvider = Provider<Repo>((ref) {
  final db = ref.watch(dbProvider);
  return Repo(db);
});

// 5. Computed
final totalProvider = Provider<double>((ref) {
  final items = ref.watch(itemsProvider);
  return items.fold(0, (sum, item) => sum + item.price);
});
```

---

**Last Updated:** October 2025  
**Riverpod Version:** 2.6.1  
**Flutter Version:** 3.9+
