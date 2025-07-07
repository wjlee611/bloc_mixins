# bloc_mixins

> Language: [English](https://github.com/wjlee611/bloc_mixins/blob/main/README.md) • [Korean](https://github.com/wjlee611/bloc_mixins/blob/main/README.ko-KR.md)

Bloc의 유용한 기능을 제공하는 mixin의 모음집 패키지 입니다.

## Features

1. flutter_bloc와 동일한 API의 위젯을 이용해서 확장 기능을 사용할 수 있습니다.
2. mixin을 통한 기능확장으로 기존 코드에 빠르게 마이그레이션이 가능합니다.
3. Flutter 위젯 생명주기에 따라 mixin 생명주기도 같이 제어됩니다. (제공되는 provider 사용)
4. Bloc 공식 문서의 Best Practice를 준수합니다. (커스텀 가능)

## Mixins & Widgets

> [!TIP]
> 이 패키지를 효과적으로 활용하기 위해서는 프로젝트가 [MVVM 아키텍처](https://docs.flutter.dev/app-architecture/guide#mvvm)를 준수하는게 좋습니다.

> [!NOTE]
> ### API Table
> - [UsecaseStream](#usecasestream)
> - [UsecaseProvider](#usecaseprovider)
> - [OneTimeEmitter](#onetimeemitter)
> - [BlocOneTimeListener](#bloconetimelistener)

### UsecaseStream

<img src="https://github.com/user-attachments/assets/c5766812-60ea-4d1c-a4af-507778b15e50" width="300px" />

[Bloc-to-Bloc Communication](https://bloclibrary.dev/ko/architecture/#bloc간-통신)을 [Domain Layer](https://bloclibrary.dev/ko/architecture/#domain을-통한-bloc-연결)에서 달성하기 위한 하나의 방법을 제공합니다.

`UsecaseStream` mixin을 상속받은 usecase는 `stream`을 제공하게 되며, `yieldData` 메서드를 사용할 수 있게 됩니다.

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

동일한 Usecase 인스턴스를 여러 Bloc에서 `emit.forEach`의 stream 파라미터에 제공하여 Domain Layer에서의 상태공유를 달성할 수 있습니다.  
또는 `StreamSubscription`을 통해 관리할 수도 있습니다.

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/b55a44c46c0127316d8867d9118d1e2bdd9173b4/example/lib/presentation/home/bloc/home_bloc.dart#L36)을 참고해주세요.

### UsecaseProvider

<img src="https://github.com/user-attachments/assets/9e55cc0a-15aa-4125-a0e7-75097fee394d" width="300px" />

해당 Usecase를 Bloc에 주입하기 위해서는 인스턴스화를 BlocProvider의 상위 위젯트리에서 수행해야 합니다.  
또한, Bloc이 close 되는 시점에 Usecase.stream도 close 되어야 합니다.

이를 flutter 위젯의 생명주기에 알아서 대응시키기 위해 `UsecaseProvider`를 제공합니다.

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

RepositoryProvider와 동일한 API로 하위 위젯트리의 Bloc에게 UsecaseStream을 상속한 Usecase를 제공할 수 있게 됩니다.

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/b55a44c46c0127316d8867d9118d1e2bdd9173b4/example/lib/main.dart#L19)을 참고해주세요.

### OneTimeEmitter

Bloc의 기본 동작은 state 인스턴스의 값이 변하지 않으면 BlocListener가 동작하지 않습니다.  
뿐만 아니라, BlocState는 snackbar, dialog 띄우기와 같은 1회성 UI 이벤트를 전송하기에는 적합하지 않은 구조를 갖고 있습니다.

위의 단점을 해결하기 위해 Bloc의 1회성 UI 이벤트 emit을 위한 하나의 방법을 제공합니다.

`OneTimeEmitter` mixin을 상속받은 Bloc는 `oneTimeEmit` 메서드를 사용할 수 있게 됩니다.

```dart
const String sameUiEvent = 'sameUiEvent';

class PushedCubit extends Cubit<PushedState> with OneTimeEmitter<String> {
  PushedCubit() : super(PushedState.init());

  void emitSameUiEvent() {
    oneTimeEmit(sameUiEvent);
  }
}
```

Bloc에서 state 제어를 위한 stream이 제공되듯, one-time UI 이벤트를 위한 `oneTimeStream`이 제공됩니다.  
해당 `oneTimeStream`에 이벤트를 등록하기 위해서는 위에 소개한 `oneTimeEmit` 메서드를 사용하거나, `oneTimeStream.add`를 사용하면 됩니다.

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/b55a44c46c0127316d8867d9118d1e2bdd9173b4/example/lib/presentation/home/bloc/home_bloc.dart#L41)을 참고해주세요.

### BlocOneTimeListener

<img src="https://github.com/user-attachments/assets/0947600b-6936-43e2-9ee1-f3ef0cf69f77" width="300px" />

`OneTimeEmitter` mixin을 상속받은 Bloc은 `oneTimeStream`을 제공하게 됩니다.  
해당 stream을 Presentation Layer에서 쉽게 사용할 수 있도록 `BlocOneTimeListener`을 제공합니다.

```dart
BlocOneTimeListener<PushedCubit, String>(
  listener: (context, value) {
    log(value);
  },
  ...
```

BlocListener와 동일한 API로 one-time UI 이벤트 수신을 위한 로직을 구성할 수 있습니다.  
Bloc 내부와 달리 contexted widget에서 제공하는 context에 접근할 수 있으므로, snackbar, dialog 띄우기에 활용할 수 있습니다.

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/b55a44c46c0127316d8867d9118d1e2bdd9173b4/example/lib/presentation/home/home_page.dart#L123)을 참고해주세요.