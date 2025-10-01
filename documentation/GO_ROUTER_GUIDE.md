# GoRouter Guide: Complete Reference

## Table of Contents

1. [GoRouter Basics](#gorouter-basics)
2. [Route Configuration](#route-configuration)
3. [Navigation Methods](#navigation-methods)
4. [Route Parameters](#route-parameters)
5. [Nested Navigation](#nested-navigation)
6. [Redirects & Guards](#redirects--guards)
7. [Error Handling](#error-handling)
8. [Best Practices](#best-practices)

---

## GoRouter Basics

### What is GoRouter?

GoRouter is a declarative routing package for Flutter that uses URLs for navigation. It provides:

- ✅ Deep linking support
- ✅ URL-based navigation
- ✅ Route guards & redirects
- ✅ Nested navigation
- ✅ Type-safe routes

### Installation

```yaml
# pubspec.yaml
dependencies:
  go_router: ^14.8.1
```

### Basic Setup

```dart
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);

// In MaterialApp
MaterialApp.router(
  routerConfig: router,
  // ... other properties
)
```

---

## Route Configuration

### Simple Route

```dart
GoRoute(
  path: '/profile',
  name: 'profile',  // Optional: named route for type-safety
  builder: (context, state) => ProfileScreen(),
)
```

**What this does:**

- Creates route at `/profile`
- Named route can be used: `context.goNamed('profile')`
- Builder returns the screen widget

### Route with Path Parameters

```dart
GoRoute(
  path: '/user/:userId',
  name: 'user',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserScreen(userId: userId);
  },
)
```

**Navigation:**

```dart
// By path
context.go('/user/123');

// By name
context.goNamed('user', pathParameters: {'userId': '123'});
```

**What changes:**

- `:userId` is a path parameter
- Extracted via `state.pathParameters['userId']`
- Required parameter (must be provided)

### Route with Query Parameters

```dart
GoRoute(
  path: '/search',
  name: 'search',
  builder: (context, state) {
    final query = state.uri.queryParameters['q'] ?? '';
    final filter = state.uri.queryParameters['filter'] ?? 'all';
    return SearchScreen(query: query, filter: filter);
  },
)
```

**Navigation:**

```dart
// URL: /search?q=flutter&filter=recent
context.goNamed(
  'search',
  queryParameters: {
    'q': 'flutter',
    'filter': 'recent',
  },
);
```

**What changes:**

- Query params appear after `?` in URL
- Optional by nature (use defaults)
- Accessed via `state.uri.queryParameters`

### Route with Extra Data (Non-URL)

```dart
GoRoute(
  path: '/details',
  name: 'details',
  builder: (context, state) {
    final product = state.extra as Product;
    return ProductDetailsScreen(product: product);
  },
)
```

**Navigation:**

```dart
final product = Product(id: 1, name: 'Widget');
context.goNamed('details', extra: product);
```

**What changes:**

- `extra` passes complex objects (not in URL)
- Useful for non-serializable data
- Not deep-link friendly (data lost on refresh)

### Nested Routes (Children)

```dart
GoRoute(
  path: '/dashboard',
  builder: (context, state) => DashboardScreen(),
  routes: [
    // Child route: /dashboard/analytics
    GoRoute(
      path: 'analytics',  // No leading slash for child
      builder: (context, state) => AnalyticsScreen(),
    ),
    // Child route: /dashboard/reports
    GoRoute(
      path: 'reports',
      builder: (context, state) => ReportsScreen(),
    ),
  ],
)
```

**What this does:**

- Creates nested route structure
- Children inherit parent path
- No leading `/` for child paths

### Shell Routes (Persistent UI)

```dart
ShellRoute(
  builder: (context, state, child) {
    return ScaffoldWithNavBar(child: child);
  },
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfileScreen(),
    ),
  ],
)
```

**What this does:**

- Keeps UI persistent (bottom nav, drawer)
- `child` is the current route content
- Parent widget wraps all child routes

**Example: Bottom Nav Bar**

```dart
class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  ScaffoldWithNavBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,  // Current route content
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/profile')) return 1;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/profile');
        break;
    }
  }
}
```

### StatefulShellRoute (Tab-based Navigation)

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return ScaffoldWithNavBar(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchScreen(),
        ),
      ],
    ),
  ],
)
```

**What this does:**

- Maintains state for each branch/tab
- Uses IndexedStack (keeps widgets alive)
- Each branch has independent navigation stack

---

## Navigation Methods

### 1. context.go() - Replace Current Route

```dart
// Navigate to new route (replaces current)
context.go('/profile');

// With parameters
context.go('/user/123');

// With query params
context.go('/search?q=flutter');
```

**What happens:**

- Replaces current route in history
- Can go back to previous route
- Updates URL bar

**Use when:**

- Normal navigation
- Switching between main screens
- Tab navigation

### 2. context.goNamed() - Type-safe Navigation

```dart
// Navigate by route name
context.goNamed('profile');

// With path parameters
context.goNamed('user', pathParameters: {'userId': '123'});

// With query parameters
context.goNamed('search', queryParameters: {'q': 'flutter'});

// With extra data
context.goNamed('details', extra: product);
```

**What happens:**

- Same as `go()` but uses route names
- Type-safe (compile-time checking with code generation)
- More maintainable

**Use when:**

- You have named routes
- Want type safety
- Refactoring paths

### 3. context.push() - Add Route to Stack

```dart
// Push new route on top
context.push('/details');

// Returns Future (can await result)
final result = await context.push('/edit');
if (result != null) {
  print('Received: $result');
}
```

**What happens:**

- Adds route to navigation stack
- Previous route stays in memory
- Can pop back

**Use when:**

- Opening details/edit screens
- Modal-like navigation
- Need to return data

### 4. context.pushNamed() - Type-safe Push

```dart
context.pushNamed('details', extra: product);

// With result
final result = await context.pushNamed('edit', extra: item);
```

### 5. context.pop() - Go Back

```dart
// Simple pop
context.pop();

// Pop with result
context.pop('Saved successfully');

// In the previous screen
final result = await context.push('/edit');
print(result); // 'Saved successfully'
```

**What happens:**

- Removes current route from stack
- Returns to previous route
- Can pass data back

### 6. context.replace() - Replace Without History

```dart
context.replace('/login');
```

**What happens:**

- Replaces current route
- No back navigation to replaced route
- Useful for login flows

### 7. context.canPop() - Check if Can Go Back

```dart
if (context.canPop()) {
  context.pop();
} else {
  // Handle when at root
  showExitDialog();
}
```

---

## Route Parameters

### Path Parameters (Required)

```dart
// Route definition
GoRoute(
  path: '/house/:houseId/cycle/:cycleId',
  name: 'cycleDetails',
  builder: (context, state) {
    final houseId = state.pathParameters['houseId']!;
    final cycleId = state.pathParameters['cycleId']!;
    return CycleDetailsScreen(
      houseId: houseId,
      cycleId: cycleId,
    );
  },
)

// Navigation
context.goNamed(
  'cycleDetails',
  pathParameters: {
    'houseId': '1',
    'cycleId': '42',
  },
);
// URL: /house/1/cycle/42
```

**Best for:**

- Required identifiers (IDs)
- RESTful URLs
- Deep linking

### Query Parameters (Optional)

```dart
// Route definition
GoRoute(
  path: '/consumptions',
  name: 'consumptions',
  builder: (context, state) {
    final cycleId = state.uri.queryParameters['cycleId'];
    final sortBy = state.uri.queryParameters['sortBy'] ?? 'date';
    final filter = state.uri.queryParameters['filter'] ?? 'all';

    return ConsumptionsScreen(
      cycleId: cycleId,
      sortBy: sortBy,
      filter: filter,
    );
  },
)

// Navigation
context.goNamed(
  'consumptions',
  queryParameters: {
    'cycleId': '42',
    'sortBy': 'amount',
    'filter': 'high',
  },
);
// URL: /consumptions?cycleId=42&sortBy=amount&filter=high
```

**Best for:**

- Optional filters
- Sorting options
- Search queries
- Pagination

### Extra Data (Complex Objects)

```dart
// Route definition
GoRoute(
  path: '/edit-consumption',
  name: 'editConsumption',
  builder: (context, state) {
    final consumption = state.extra as ElectricityReading;
    return EditConsumptionScreen(consumption: consumption);
  },
)

// Navigation
final consumption = ElectricityReading(/* ... */);
context.pushNamed('editConsumption', extra: consumption);
```

**Best for:**

- Complex objects
- Non-serializable data
- Internal navigation only (not deep-linkable)

---

## Redirects & Guards

### Simple Redirect

```dart
final router = GoRouter(
  redirect: (context, state) {
    final isLoggedIn = /* check auth status */;
    final isGoingToLogin = state.matchedLocation == '/login';

    // Redirect to login if not authenticated
    if (!isLoggedIn && !isGoingToLogin) {
      return '/login';
    }

    // Redirect to home if already logged in
    if (isLoggedIn && isGoingToLogin) {
      return '/';
    }

    // No redirect
    return null;
  },
  routes: [/* ... */],
)
```

**What happens:**

- Called before navigating to any route
- Return new path to redirect
- Return `null` to allow navigation

### Route-Specific Redirect

```dart
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    final isAdmin = /* check admin status */;
    return isAdmin ? null : '/';
  },
  builder: (context, state) => AdminScreen(),
)
```

**What happens:**

- Only applies to this route
- Overrides global redirect

### Async Redirect (with Riverpod)

```dart
final router = GoRouter(
  redirect: (context, state) async {
    // This won't work - redirect must be sync!
    // Use refreshListenable instead
    return null;
  },

  // Use refreshListenable for reactive redirects
  refreshListenable: authNotifier,

  routes: [/* ... */],
)

// Riverpod example
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }

      if (isLoggedIn && isGoingToLogin) {
        return '/';
      }

      return null;
    },
    refreshListenable: authState, // Rebuilds router when auth changes
    routes: [/* ... */],
  );
});
```

### Redirect Examples

#### 1. Auth Guard

```dart
redirect: (context, state) {
  final authState = ref.read(authProvider);
  final isLoggedIn = authState.isAuthenticated;

  final publicRoutes = ['/login', '/register', '/forgot-password'];
  final isPublicRoute = publicRoutes.contains(state.matchedLocation);

  if (!isLoggedIn && !isPublicRoute) {
    return '/login';
  }

  if (isLoggedIn && isPublicRoute) {
    return '/';
  }

  return null;
}
```

#### 2. Onboarding Guard

```dart
redirect: (context, state) {
  final hasCompletedOnboarding = /* check */;
  final isOnboardingRoute = state.matchedLocation == '/onboarding';

  if (!hasCompletedOnboarding && !isOnboardingRoute) {
    return '/onboarding';
  }

  return null;
}
```

#### 3. Role-Based Access

```dart
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    final user = ref.read(userProvider);
    return user?.role == 'admin' ? null : '/';
  },
  builder: (context, state) => AdminScreen(),
)
```

---

## Error Handling

### Custom Error Screen

```dart
final router = GoRouter(
  errorBuilder: (context, state) => ErrorScreen(
    error: state.error,
  ),
  routes: [/* ... */],
)

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Page not found'),
            SizedBox(height: 8),
            Text(error?.toString() ?? 'Unknown error'),
            SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/'),
              child: Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 404 Handling

```dart
// Last route catches all unmatched paths
GoRoute(
  path: '/:anything(.*)',  // Regex: match anything
  builder: (context, state) => NotFoundScreen(),
)
```

---

## Best Practices

### ✅ DO: Use Named Routes

```dart
// Good - Type-safe, maintainable
context.goNamed('cycleDetails', pathParameters: {'id': '123'});

// Bad - String-based, error-prone
context.go('/cycle/123/details');
```

### ✅ DO: Centralize Route Configuration

```dart
// lib/core/router/app_router.dart
class AppRouter {
  static const String home = 'home';
  static const String cycleDetails = 'cycleDetails';
  static const String editConsumption = 'editConsumption';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: home,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/cycle/:id',
        name: cycleDetails,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CycleDetailsScreen(id: id);
        },
      ),
    ],
  );
}

// Usage
context.goNamed(AppRouter.cycleDetails, pathParameters: {'id': '123'});
```

### ✅ DO: Handle Pop Results

```dart
// Good - Handle result
final result = await context.pushNamed('edit', extra: item);
if (result == true) {
  // Refresh data
  ref.invalidate(itemsProvider);
}

// In edit screen
FilledButton(
  onPressed: () async {
    await saveChanges();
    context.pop(true); // Return success
  },
  child: Text('Save'),
)
```

### ✅ DO: Use Proper Navigation for Context

```dart
// Good - Use go() for tabs/main screens
onTap: (index) {
  switch (index) {
    case 0: context.go('/home'); break;
    case 1: context.go('/search'); break;
  }
}

// Good - Use push() for details/modals
onCardTap: () {
  context.pushNamed('details', extra: item);
}
```

### ✅ DO: Validate Parameters

```dart
GoRoute(
  path: '/cycle/:id',
  builder: (context, state) {
    final idStr = state.pathParameters['id'];
    final id = int.tryParse(idStr ?? '');

    if (id == null) {
      return ErrorScreen(message: 'Invalid cycle ID');
    }

    return CycleDetailsScreen(id: id);
  },
)
```

### ✅ DO: Use ShellRoute for Persistent UI

```dart
// Good - Bottom nav persists across routes
ShellRoute(
  builder: (context, state, child) => ScaffoldWithNavBar(child: child),
  routes: [
    GoRoute(path: '/home', builder: (_, __) => HomeScreen()),
    GoRoute(path: '/profile', builder: (_, __) => ProfileScreen()),
  ],
)
```

### ❌ DON'T: Use context.go() in Loops

```dart
// Bad - Can cause issues
for (var i = 0; i < 3; i++) {
  context.go('/step$i');
}

// Good - Navigate once
context.go('/step${currentStep}');
```

### ❌ DON'T: Nest push() Calls

```dart
// Bad - Hard to manage state
context.push('/a');
context.push('/b');
context.push('/c');

// Good - Use proper route structure
context.go('/a/b/c');
```

### ❌ DON'T: Use Extra for Deep Links

```dart
// Bad - Extra data lost on refresh
context.goNamed('details', extra: product);

// Good - Use path/query params
context.goNamed(
  'details',
  pathParameters: {'id': product.id},
  queryParameters: {'name': product.name},
);
```

### ❌ DON'T: Ignore canPop()

```dart
// Bad - May cause errors at root
IconButton(
  icon: Icon(Icons.arrow_back),
  onPressed: () => context.pop(),
)

// Good - Check first
IconButton(
  icon: Icon(Icons.arrow_back),
  onPressed: () {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  },
)
```

---

## Real-World Examples

### Example 1: Complete App Router

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isGoingToAuth = state.matchedLocation.startsWith('/auth');

      if (!isLoggedIn && !isGoingToAuth) {
        return '/auth/login';
      }

      if (isLoggedIn && isGoingToAuth) {
        return '/';
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => LoginScreen(),
      ),

      // Main app with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => HomeScreen(),
            routes: [
              // Nested: /cycle/:id
              GoRoute(
                path: 'cycle/:id',
                name: 'cycleDetails',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return CycleDetailsScreen(id: id);
                },
                routes: [
                  // Nested: /cycle/:id/edit
                  GoRoute(
                    path: 'edit',
                    name: 'editCycle',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return EditCycleScreen(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});
```

### Example 2: Bottom Navigation with GoRouter

```dart
class MainScaffold extends StatelessWidget {
  final Widget child;

  MainScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/settings')) return 1;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/settings');
        break;
    }
  }
}
```

### Example 3: Form with Unsaved Changes

```dart
class EditScreen extends StatefulWidget {
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Discard changes?'),
            content: Text('You have unsaved changes.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Discard'),
              ),
            ],
          ),
        );

        if (shouldPop == true && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Edit')),
        body: Form(
          onChanged: () => setState(() => hasUnsavedChanges = true),
          child: /* form fields */,
        ),
      ),
    );
  }
}
```

---

## Quick Reference

### Navigation Methods

| Method                    | Effect             | Use Case                  |
| ------------------------- | ------------------ | ------------------------- |
| `context.go(path)`        | Replace route      | Main navigation, tabs     |
| `context.goNamed(name)`   | Replace by name    | Type-safe navigation      |
| `context.push(path)`      | Add to stack       | Details, modals           |
| `context.pushNamed(name)` | Push by name       | Type-safe push            |
| `context.pop([result])`   | Go back            | Close screen, return data |
| `context.replace(path)`   | Replace no history | Login flows               |

### Parameter Types

| Type  | Syntax        | Example          | Best For         |
| ----- | ------------- | ---------------- | ---------------- |
| Path  | `:paramName`  | `/user/:id`      | Required IDs     |
| Query | `?key=value`  | `/search?q=text` | Optional filters |
| Extra | `state.extra` | Complex object   | Non-URL data     |

### Route Types

| Type                 | Purpose       | Example                   |
| -------------------- | ------------- | ------------------------- |
| `GoRoute`            | Basic route   | Single screen             |
| `ShellRoute`         | Persistent UI | Bottom nav wrapper        |
| `StatefulShellRoute` | Stateful tabs | Tab navigation with state |

---

## Summary

### Key Concepts

1. **Declarative routing** - Define routes upfront
2. **URL-based** - Every screen has a URL
3. **Type-safe with names** - Use named routes
4. **Nested structure** - Routes can have children
5. **Redirects** - Guard routes with logic
6. **Shell routes** - Persistent UI wrappers

### Common Patterns

```dart
// 1. Simple navigation
context.goNamed('home');

// 2. With parameters
context.goNamed('details', pathParameters: {'id': '123'});

// 3. With result
final result = await context.pushNamed('edit');

// 4. Check before pop
if (context.canPop()) context.pop();

// 5. Redirect guard
redirect: (context, state) => isAuth ? null : '/login';
```

---

**Last Updated:** October 2025  
**GoRouter Version:** 14.8.1  
**Flutter Version:** 3.9+
