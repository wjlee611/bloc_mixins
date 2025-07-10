# bloc_mixins

> Language: [English](https://github.com/wjlee611/bloc_mixins/blob/main/README.md) • [Korean](https://github.com/wjlee611/bloc_mixins/blob/main/README.ko-KR.md)

A collection of mixins that provide useful features for Bloc.

## Features

1. You can use useful features by using widgets with the same API as [flutter_bloc](https://pub.dev/packages/flutter_bloc).
2. Quick migration to existing code is possible by extending functionality through mixins.
3. Mixin lifecycle is also controlled along with flutter widget lifecycle (using provided provider).
4. Follows the best practices of the official Bloc documentation. (Customization is possible)

You can use this package in the following situations:

- When you need to completely separate the responsibility of sharing state between Blocs from the Presentation Layer (UI).
- When you have many one-time UI events like dialogs and snackbars that are difficult to manage in BlocState.
- When you use Bloc as a singleton object.
- When you have many Blocs that are not initialized by the widget lifecycle.

## Mixins & Widgets

> [!TIP]
> To effectively utilize this package, it is recommended that your project adhere to the [MVVM architecture](https://docs.flutter.dev/app-architecture/guide#mvvm).

> [!NOTE]
> ### API Table
> - [UsecaseStream](#usecasestream)
> - [UsecaseProvider](#usecaseprovider)
> - [OneTimeEmitter](#onetimeemitter)
> - [BlocOneTimeListener](#bloconetimelistener)
> - [BlocResetter](#blocresetter)
> - [BlocResetRegistry](#blocresetregistry)

### UsecaseStream

<img src="https://github.com/user-attachments/assets/c5766812-60ea-4d1c-a4af-507778b15e50" width="300px" />

Provides one way to achieve [Bloc-to-Bloc Communication](https://bloclibrary.dev/architecture/#bloc-to-bloc-communication) at the [Domain Layer](https://bloclibrary.dev/architecture/#connecting-blocs-through-domain).

A usecase that inherits from the `UsecaseStream` mixin will provide a `stream` and will have access to the `yieldData` method.

```dart
class AddOneUsecase with UsecaseStream<int> {
  final CounterRepository _counterRepository;

  AddOneUsecase({required CounterRepository counterRepository})
    : _counterRepository = counterRepository;

  Future<int> call(int value, {int delay = 2}) async {
    final result = await _counterRepository.increment(value, delay);
    yieldData(result);
    return result;
  }
}

// Usage
final addOneUsecase = AddOneUsecase( ... );
addOneUsecase.stream
```

State sharing in the Domain Layer can be achieved by providing the same Usecase instance to the stream parameter of `emit.forEach` in multiple Blocs.  
Alternatively, you can manage it via `StreamSubscription`.

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/usecase_stream/bloc/us_home_bloc.dart#L28)

### UsecaseProvider

<img src="https://github.com/user-attachments/assets/9e55cc0a-15aa-4125-a0e7-75097fee394d" width="300px" />

To inject this Usecase into a Bloc, instantiation must be performed in the parent widget tree of the BlocProvider.  
Additionally, Usecase.stream must be closed when the Bloc is closed.

To make this work automatically in the life cycle of flutter widgets, this package provides `UsecaseProvider`.

```dart
void _pushPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UsecaseProvider(
        create: (context) => DisposeTestUsecase(),
        child: BlocProvider(
          create: (context) =>
              PushedCubit(disposeTestUsecase: context.read<DisposeTestUsecase>()),
          child: const PushedPage(),
        ),
      ),
    ),
  );
}
```

With the same API as RepositoryProvider, you can provide Usecases that inherit UsecaseStream to Blocs in the child widget tree.

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/usecase_stream/usecase_stream_home_page.dart#L20).

### OneTimeEmitter

The default behavior of Bloc is that BlocListener does not fire if the value of the state instance does not change.  
Additionally, BlocState has a structure that is not suitable for sending one-time UI events such as snackbars and dialog launches.

To address the above shortcomings, this package provides a way to emit one-time UI events from Bloc.

A Bloc that inherits the `OneTimeEmitter` mixin can use the `oneTimeEmit` method.

```dart
const String sameUiEvent = 'sameUiEvent';

class PushedCubit extends Cubit<PushedState> with OneTimeEmitter<String> {
  PushedCubit() : super(PushedState.init());

  void emitSameUiEvent() {
    oneTimeEmit(sameUiEvent);
  }
}
```

Just as Bloc provides a stream for state control, `oneTimeStream` is provided for one-time UI events.  
To register an event to the `oneTimeStream`, you can use the `oneTimeEmit` method introduced above, or use `oneTimeStream.add`.

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/one_time_emitter/bloc/ote_home_bloc.dart#L36).

### BlocOneTimeListener

<img src="https://github.com/user-attachments/assets/0947600b-6936-43e2-9ee1-f3ef0cf69f77" width="300px" />

A Bloc that inherits the `OneTimeEmitter` mixin will provide a `oneTimeStream`.  
This package also provides `BlocOneTimeListener` to make it easy to use the stream in the Presentation Layer.

```dart
BlocOneTimeListener<PushedCubit, String>(
  listener: (context, value) {
    log(value);
  },
  ...
```

You can configure logic for receiving one-time UI events with the same API as BlocListener.  
Unlike inside a Bloc, you can access the context provided by the contexted widget, so you can use it to display snackbars and dialogs.

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/one_time_emitter/one_time_emitter_home_page.dart#L102).

### BlocResetter

<img src="https://github.com/user-attachments/assets/7e158d90-dfae-47f7-94a0-1d8809b8f905" width="300px" />

In general, if you want to reset the Bloc to its initial state, you can do so by calling `emit(InitState())` or by removing the Bloc from the widget tree and then reinitializing it.  
However, for `Bloc that are not removed from the widget tree*`, you need to create an event class for calling `emit(InitState())`, and if there are a lot of them, it becomes difficult to manage.

> [!NOTE]
> `*Bloc that are not removed from the widget tree`
> - Provided by BlocProvider at the top of MaterialApp
> - Initialized as a singleton near the main function

This package provides a way to easily initialize multiple Blocs that are not dependent on the widget lifecycle introduced above.

Blocs that inherit the `BlocResetter` mixin can use the `reset` method as well as the `register` and `unregister` methods.

```dart
class GlobalBloc extends Bloc<GlobalEvent, GlobalState> with BlocResetter {
  GlobalBloc() : super(GlobalInitialState()) {
    register(
      onReset: () {
        add(GlobalLoadEvent());
      },
    );

    on<GlobalLoadEvent>(_loadEventHandler);

    add(GlobalLoadEvent());
  }
  ...
```

The `BlocResetter` mixin captures the initial state of the Bloc and emits the captured initial state when `reset` is called (with any handlers registered with `onReset` called as well, if necessary).  
However, this mixin alone cannot do anything.

For effective use, call `register` in the constructor and register it with the [BlocResetRegistry](#blocresetregistry) static utility class before using it.

> [!TIP]
> `unregister` removes a Bloc from the [BlocResetRegistry](#blocresetregistry).  
> However, you will rarely need to use it since the `unregister` method is automatically called when Bloc.close is called.

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/bloc_resetter/bloc/global_bloc.dart#L10).

### BlocResetRegistry

<img src="https://github.com/user-attachments/assets/bed0c8c8-e392-4f6f-954e-bbecf48a0a0d" width="300px" />

A static utility class that must be used together with [BlocResetter](#blocresetter).

#### `addBloc`, `removeBloc`

You can add or remove Blocs to be managed by the `BlocResetRegistry` using these two methods.  
Adding or removing a Bloc does not affect its lifecycle, but it will be automatically added or removed according to the Bloc's lifecycle (if `register` is called in the constructor).  
(That is, you will rarely need to use both methods.)

#### `resetBlocs`

Resets the Blocs registered in `BlocResetRegistry` to their initial state.  
If `withCallback` is `true` (the default), the `onReset` callbacks registered with `BlocResetter.register` will also be executed.

#### `get<T>`

You can retrieve a Bloc registered in `BlocResetRegistry` just like `context.get`.  

> [!TIP]
> You can use Bloc as a singleton object in the following way:
> ```dart
> class ConfigBloc extends Bloc<ConfigEvent, ConfigState> with BlocResetter {
>   ConfigBloc() : super(ConfigInitState() {
>     register();
>   }
>   // Same as any other Bloc
> }
> 
> void main() {
>   ConfigBloc(); // BlocResetter automatically registers with BlocResetRegister.
>   runApp(const MyApp());
> }
>
> final configBloc = BlocResetRegister.get<ConfigBloc>(); // Global access
> ```

> [!WARNING]
> Do not access the Bloc provided by `BlocProvider` globally, as it will be automatically added or removed in `BlocResetRegister` according to the Bloc's lifecycle.  
> While it is not a problem to access it, doing so after the Bloc has been removed from the widget tree will result in a `BlocResetRegistryGetNullException`.
>
> ```dart
> class Bloc1 extends Bloc<Bloc1Event, Bloc1State> with BlocResetter {
>   Bloc1() : super(Bloc1InitState() {...}
>
>   Future<void> _eventHandler(...) async {
>     final bloc2 = BlocResetRegister.get<Bloc2>(); // MIGHT THROW EXCEPTION!
>   }
> }
> ```
>
> That is, only use [BlocResetter](#blocresetter) for Blocs that guarantee immutability throughout their lifecycle.

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/bloc_resetter/bloc_resetter_home_page.dart#L40).

## API Documentation

For more detailed API documentation, please refer to the [API reference](https://pub.dev/documentation/bloc_mixins/latest/bloc_mixins/).