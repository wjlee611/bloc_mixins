# bloc_mixins

> Language: [English](https://github.com/wjlee611/bloc_mixins/blob/main/README.md) • [Korean](https://github.com/wjlee611/bloc_mixins/blob/main/README.ko-KR.md)

A collection of mixins that provide useful features for Bloc.

## Features

1. You can use useful features by using widgets with the same API as [flutter_bloc](https://pub.dev/packages/flutter_bloc).
2. Quick migration to existing code is possible by extending functionality through mixins.
3. Mixin lifecycle is also controlled along with flutter widget lifecycle (using provided provider).
4. Follows the best practices of the official Bloc documentation. (Customization is possible)

## Mixins & Widgets

> [!TIP]
> To effectively utilize this package, it is recommended that your project adhere to the [MVVM architecture](https://docs.flutter.dev/app-architecture/guide#mvvm).

> [!NOTE]
> ### API Table
> - [UsecaseStream](#usecasestream)
> - [UsecaseProvider](#usecaseprovider)
> - [OneTimeEmitter](#onetimeemitter)
> - [BlocOneTimeListener](#bloconetimelistener)

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

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/b55a44c46c0127316d8867d9118d1e2bdd9173b4/example/lib/presentation/home/bloc/home_bloc.dart#L36)

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

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/b55a44c46c0127316d8867d9118d1e2bdd9173b4/example/lib/main.dart#L19).

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

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/b55a44c46c0127316d8867d9118d1e2bdd9173b4/example/lib/presentation/home/bloc/home_bloc.dart#L41).

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

For detailed code examples, please refer to [example](https://github.com/wjlee611/bloc_mixins/blob/b55a44c46c0127316d8867d9118d1e2bdd9173b4/example/lib/presentation/home/home_page.dart#L123).
