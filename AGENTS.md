# AGENTS.md

# Gauge R&R Flutter Client

Flutter client for the Gauge R&R application. It communicates with the Laravel REST API. Laravel is the single source of truth for authentication, authorization, business rules, data integrity and Attribute Agreement Analysis (AAA).

## 1. Source Of Truth

- This `AGENTS.md` is the source of truth for Flutter implementation rules.
- `docs/api-contract.md` in this repository is the copy of the Laravel API contract: error codes, formats, identifiers, endpoints and open decisions. Check its revision before relying on it.
- Do not call an endpoint, read a field or branch on a value that is not described in the contract. If something is missing, stop and report it instead of guessing.
- If the contract and the observed API disagree, report the discrepancy. Do not silently change behavior.
- `GEMINI.md` (Laravel conventions) is background reading when it is available. It is not required to work in this repository.
- When two requirements conflict: preserve backend business and security rules, preserve the existing architecture unless a change is justified, follow the more specific requirement, and explain unresolved conflicts before implementing.
- Resolve repository files relative to the project root. Do not assume absolute paths.

## 2. Change Workflow

Before modifying code:

1. Inspect the existing implementation and relevant documentation.
2. Use CodeGraph for call chains and dependencies when it is available. If it is not, inspect imports, routes, providers and API dependencies manually, and do not claim CodeGraph was used.
3. State the expected impact scope.
4. Follow existing project conventions unless there is a clear reason to change them.

After modifying code:

1. Run the relevant tests, `flutter analyze` and `dart format` on modified files.
2. Update the README when documented behavior, setup, configuration, architecture or usage changes.
3. Report what changed, the validation results and known limitations.

Do not claim a command or test succeeded unless it was executed successfully. Do not use `flutter run` as a build or verification command.

## 3. Stack And Platform Scope

Required stack:

- Flutter and Dart.
- Dio for HTTP.
- Provider with `ChangeNotifier` for state management.
- Flutter localization with ARB files, `flutter_localizations` and `intl`.
- Laravel REST API with Sanctum bearer tokens.

Rules:

- Do not replace Dio or Provider, and do not add another state management package, HTTP client or unrelated dependency without asking.
- The primary target is Android. iOS, Web and Windows are not required; do not spend effort verifying them unless asked. Avoid unnecessary platform-specific code.
- Check the Android internet permission and cleartext (HTTP) restrictions for any networking change.

## 3.1 Asset Code Generation

- Use FlutterGen (`flutter_gen_runner`) to generate type-safe Dart references for registered assets.
- Use `build_runner` as the generator runner. Keep both packages in `dev_dependencies`.
- After adding, removing, renaming or changing asset declarations in `pubspec.yaml`, run:

```bash
flutter pub get
dart run build_runner build
```

- Import and use generated asset references instead of manually writing asset paths, for example `Assets.images.logo.path`.
- Never manually edit generated asset files or create a separate manually maintained asset registry.
- Follow the existing FlutterGen configuration and output directory. Do not change the project structure or generator configuration unnecessarily.
- FlutterGen asset generation is separate from Flutter localization generation (`flutter gen-l10n`).

## 4. Architecture

```text
lib/
├── api/            (auth_api, user_api, master_data_api, session_api, report_api)
├── components/     (buttons, dialogs, forms, common)
├── constants/      (app_constants, app_enums)
├── generated/localization/
├── l10n/           (app_id.arb, app_en.arb, app_ko.arb)
├── model/          (auth, user, master_data, session, report)
├── pages/          (auth, dashboard, users, master_data, sessions, reports)
├── router/app_router.dart
├── store/          (auth, users, master_data, sessions, reports, locale)
├── theme/          (app_theme.dart)
├── utils/          (request.dart, storage.dart, app_config.dart)
├── bootstrap.dart
└── main.dart
```

- `api/`: API request declarations. `model/`: typed data models. `store/`: Provider classes. `pages/`: route-level screens. `components/`: reusable, business-agnostic UI. `utils/`: shared infrastructure.
- Preserve a valid existing structure. Do not restructure the project without a clear reason.

Import boundaries:

- `model/**` must not import `api/**`, `pages/**` or `store/**`.
- `api/**` must not import `pages/**`.
- `components/**` must not import business pages.
- Avoid page-to-page dependencies and circular imports.

## 5. Network And API Layer

- All HTTP goes through the single Dio client configured in `lib/utils/request.dart`. Never instantiate `Dio()` in pages, widgets or API files.
- Configure base URL, timeouts, headers and response handling centrally.
- The backend is versioned under `/api/v1`. Do not duplicate the prefix between the base URL and endpoint paths.
- Attach the Sanctum bearer token and handle common HTTP errors in shared interceptors.
- Log requests only in development. Never log passwords, tokens or other secrets.
- Take environment values from `--dart-define` through `AppConfig`. Never hard-code production URLs or credentials. A development build must never point to the production backend.

API files declare business requests only:

- Every API method has an explicit return type and returns typed models or typed collections. Never pass raw `response.data` to pages or widgets.
- No UI logic or business calculations in API classes.
- To add an API call: read it in the contract, define request and response models, implement the method, connect it through a Provider, consume it in the page, and add tests for serialization and parsing.

```dart
class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post('/auth/login', data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }
}
```

The example shows the responsibility boundary only. Follow the endpoint paths in the contract.

## 6. Models

- Strongly typed model classes with semantic names. `UpperCamelCase` classes, `lowerCamelCase` members.
- Implement `fromJson` and `toJson` where serialization is needed. Use explicit nullable types.
- Avoid long-lived `dynamic` and raw `Map<String, dynamic>` in business logic.
- Keep API values separate from localized display labels. Never change enum or status values to match UI wording.
- Use the public identifier the contract defines for each resource. Never depend on internal database IDs.
- An unknown enum value from the backend must not crash the app. Map it to an explicit "unknown" state.
- Decimal metrics arrive as strings (see the contract). Parse them into numbers in the model, and keep `null` as "not available".

## 7. State, Pages And Side Effects

- Provider classes live in `lib/store/**`, are registered through `MultiProvider` at startup, and keep loading, success, empty and error states explicit.
- Use `context.watch`, `context.read`, `Consumer` or `Selector` appropriately. Call `notifyListeners()` after valid changes. Dispose controllers and subscriptions.
- Provider coordinates state and API calls. It does not replace the backend business layer.
- Pages consume typed Provider state and receive typed values through constructors. No raw JSON in `build()`.
- Keep `build()` pure: no network requests, storage access or state-changing side effects.
- Allowed side-effect locations: `initState`, `didChangeDependencies`, interaction callbacks and dedicated Provider or service classes.
- Prevent duplicate submissions while a request is running. Validate input before sending.
- Do not assume an HTTP success means the business operation completed unless the response confirms it.
- Create the router and global Providers at startup. Use constructor injection. Keep storage access behind shared utilities.

## 8. UI

The UI is hybrid: Material 3 provides the app structure, and Cupertino widgets are used for the interactions listed below. The result must look like one consistent app.

- `MaterialApp` is the root, with a single `ThemeData` (`useMaterial3: true`) defined in `lib/theme/app_theme.dart`. Colors, typography, shapes and spacing come from the theme, never from hard-coded values in widgets.
- Choose the widget family per interaction type and apply it everywhere. Do not use a Material and a Cupertino version of the same control in different places.

| Interaction | Family |
|---|---|
| App structure and navigation (`Scaffold`, `AppBar`, `NavigationBar`) | Material |
| Lists, cards, buttons, text fields, snack bars, bottom sheets | Material |
| Confirmation and alert dialogs, action sheets | Cupertino |
| Pickers (date, time, single selection) | Cupertino |
| Inspection answer (`good` or `defect`) | Cupertino sliding segmented control, or a radio group. Exactly one answer is selected; never checkboxes. |

- Do not rely on platform-adaptive behavior (`.adaptive` constructors, `Platform` checks) to choose the family. Choose it explicitly. A new interaction type that is not in the table is added to the table in the same change.
- Keep the visual style restrained and consistent. Do not add decorative blur, translucency or glass effects unless asked.
- Reusable components under `lib/components/**` stay business-agnostic: typed parameters and callbacks, no API requests, no authorization checks, no feature-specific navigation, no dependence on response shapes or Provider fields. If a component needs `user`, `session` or `inspection` parameters, it belongs in a feature folder.
- Mouse and keyboard support is not required beyond Flutter defaults.

## 9. Backend Contract Handling

Flutter only displays backend results. It never reproduces backend rules.

- All data goes through the Laravel API. Never connect to Supabase, and never use Supabase Auth, its client libraries or RLS.
- Preserve backend field names, enum values and identifiers. Never translate values before sending them.
- Branch on the `code` field of error responses, never on the `message` text. Map each known `code` to a localized message.
- Handle the documented codes: `unauthenticated` (clear the session and return to login), `invalid_credentials`, `account_pending`, `account_inactive`, `password_change_required` (route to the change-password flow), `forbidden`, `not_found`, `validation_failed` (show field errors from `errors`), `too_many_requests` (ask the user to wait) and `http_error` (unexpected error).
- Keep shared network error handling in `lib/utils/request.dart` and API-specific response mapping in the API or model layer. Provider exposes meaningful error states.
- Never swallow unexpected exceptions or show stack traces, server details or raw messages to users.

## 10. Authentication And Authorization

- Login uses `employee_code` and password. Attach the Sanctum token through the shared interceptor.
- Store the token in secure storage (ask before adding a package for it). Never store passwords. Clear the token and state on logout and on `unauthenticated`. Never log or display the token.
- Self-registration always creates an `inspector` account with status `pending`. Never send or trust a client-selected role.
- Do not check whether an `employee_code` exists through a separate request. Show the registration response generically: do not claim an account definitely exists or was created.
- `account_pending` and `account_inactive` mean credentials were correct but no token was issued. Do not infer account status from `invalid_credentials`.
- While a password change is required, allow only the change-password flow, profile loading and logout (see the contract). Do not allow normal navigation.
- Roles (`admin`, `manager`, `inspector`):

| Role | Responsibility |
|---|---|
| `admin` | Manages users, master data and inspection sessions; views all results |
| `manager` | Read-only access to reports and exports |
| `inspector` | Runs inspection sessions and views their own results |

- Laravel Policies are the only authority. Hiding or disabling a button is usability, not authorization. Handle `401` and `403` correctly.
- The manager UI offers no data-modifying actions. The inspector UI never shows other users' results.

## 11. Gauge R&R Rules

- Never calculate `miss_rate`, `false_alarm_rate` or `effectiveness` in Flutter. Laravel owns the formulas, thresholds, evaluation and judgement. Do not infer a judgement from displayed percentages, and do not invent thresholds.
- The thesis labels `miss_rate` as "P false" and `false_alarm_rate` as "P mis". These are display labels only and never replace backend identifiers.
- The backend verdict values are exactly `good` and `defect`. Send and store them unchanged. Never replace them with `G`, `N` or translated labels in API communication. Localized display labels are allowed.
- The judgement criteria are provisional. Do not assume them until the contract defines them.
- Laravel controls session creation, validation, evaluation and completion. A session has at most three trials; client-side limits are for usability only. Use backend-provided statuses, and do not assume a session is editable from how it looks.
- Never show answer keys to inspector users. Use the session-specific samples supplied by the backend and never rebuild historical answer keys from current master data.
- Completed results are append-only. Follow the backend's workflow for corrections.
- Fetch master data (users, plants, part types, samples, teams) from the API. Never hard-code the plant list. Do not assume deleted records are gone or that a used code is unavailable forever.

## 12. Localization

Locales: `id_ID` (Indonesian, default), `en_US` (English), `ko_KR` (Korean).

- Use Flutter's official localization. ARB sources are `lib/l10n/app_id.arb`, `app_en.arb` and `app_ko.arb`. Generated code goes under `lib/generated/localization/` and is never edited by hand. Keep keys consistent across all locales.
- Register `GlobalMaterialLocalizations`, `GlobalWidgetsLocalizations` and `GlobalCupertinoLocalizations` delegates so both Material and Cupertino widgets are localized in Indonesian and Korean.
- Persist the selected locale and restore it at startup. Use Indonesian when no preference is saved, and do not silently override an explicit preference with the device locale. Keep locale state in one Provider, with a language setting in the application settings.
- Localize all user-facing text: navigation, titles, buttons, forms, dialogs, feedback, loading, empty, success and error states, dashboards, inspection screens, reports, account status messages and validation messages. Do not hard-code new strings in widgets.
- Never translate or modify API field names, enum values, status identifiers, verdict values, UUIDs or error `code` values. A localized label never replaces the backend value in a request.

| Backend value | Indonesian | English | Korean |
|---|---|---|---|
| `good` | Baik | Good | 양호 |
| `defect` | Cacat | Defect | 불량 |
| `pending` | Menunggu | Pending | 대기 중 |
| `active` | Aktif | Active | 활성 |
| `inactive` | Tidak aktif | Inactive | 비활성 |

- Use locale-aware formatting for dates, numbers and percentages without changing the underlying values. Convert UTC timestamps to local time for display only.
- Test longer translated strings, especially English and Korean, for layout overflow.

## 13. Naming And Configuration

- Dart conventions: `UpperCamelCase` classes, `lowerCamelCase` variables and methods, `snake_case.dart` files. Use semantic business names.
- Use `AppConfig` with `--dart-define` for environment values. Never hard-code secrets or environment-specific credentials.

## 14. Testing

Use Flutter's testing framework with mocked network requests. Never connect tests to production APIs or databases. Do not duplicate backend AAA tests. Add regression tests when fixing bugs, and never remove existing tests to make the suite pass.

Prioritize:

- Model serialization and API response parsing, including decimal strings and unknown enum values.
- Dio configuration and interceptors, including token attachment and `unauthenticated` handling.
- Provider state transitions and explicit loading, success, empty and error states.
- Authentication: generic login and registration handling, account status codes, the password-change flow and logout.
- Error `code` to localized message mapping.
- Role-based UI visibility and requests that use the public identifiers.
- Inspection interactions and trial input limits.
- Localization: locale restoration, language switching and long strings.

## 15. Documentation And Commands

- Update the README for meaningful changes to architecture, setup, environment configuration, API integration, authentication, localization, features or commands. Do not add meaningless changes to satisfy this rule.
- When the Laravel contract changes, replace the copy in `docs/api-contract.md`, then update models, APIs and tests.

```bash
flutter pub get
flutter analyze
flutter test
dart format .
flutter build apk
flutter build appbundle
```

Do not run `flutter run`. Do not edit generated files or package files unnecessarily. Run only the checks that are relevant to the change.

## 16. Definition Of Done

- The change follows this document and the existing architecture.
- Dio uses the shared client, Provider handles state, and API responses become typed models.
- Requests and fields match `docs/api-contract.md`. No backend business logic is duplicated in Flutter.
- No secrets or tokens are exposed, and backend enum values and identifiers are unchanged.
- The UI follows the hybrid Material and Cupertino rules, uses the shared theme, and all user-facing text is localized.
- Relevant README documentation is updated and modified Dart files are formatted.
- `flutter analyze` introduces no new issues and the relevant tests pass.