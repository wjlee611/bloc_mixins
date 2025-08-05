# bloc_mixins

> Language: [English](https://github.com/wjlee611/bloc_mixins/blob/main/README.md) • [Korean](https://github.com/wjlee611/bloc_mixins/blob/main/README.ko-KR.md)

Bloc의 유용한 기능을 제공하는 mixin의 모음집 패키지 입니다.

## Features

1. flutter_bloc와 동일한 API의 위젯을 이용해서 확장 기능을 사용할 수 있습니다.
2. mixin을 통한 기능확장으로 기존 코드에 빠르게 마이그레이션이 가능합니다.
3. Flutter 위젯 생명주기에 따라 mixin 생명주기도 같이 제어됩니다. (제공되는 provider 사용)
4. Bloc 공식 문서의 Best Practice를 준수합니다. (커스텀 가능)

다음과 같은 상황에서 사용할 수 있습니다.

- Bloc간 상태 공유의 책임을 Presentation Layer (UI) 에서 완벽히 분리해야할 경우
- Dialog, snackbar과 같이 1회성 UI로 전송해야 하는 이벤트가 많아 BlocState에서 관리하기 힘들 경우
- Bloc을 싱글톤 객체로 사용하는 경우
- 위젯 생명주기에 의해 초기화되지 않는 Bloc이 많은 경우

## Mixins & Widgets

> [!TIP]
> 이 패키지를 효과적으로 활용하기 위해서는 프로젝트가 [MVVM 아키텍처](https://docs.flutter.dev/app-architecture/guide#mvvm)를 준수하는게 좋습니다.

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

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/usecase_stream/bloc/us_home_bloc.dart#L28)을 참고해주세요.

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

또한 위젯트리를 깔끔하게 관리하기 위해 `MultiUsecaseProvider` 또한 제공합니다.

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/usecase_stream/usecase_stream_home_page.dart#L20)을 참고해주세요.

### OneTimeEmitter

Bloc의 기본 동작은 state 인스턴스의 값이 변하지 않으면 BlocListener가 동작하지 않습니다.  
뿐만 아니라, BlocState는 snackbar, dialog 띄우기와 같은 1회성 UI 이벤트를 전송하기에는 적합하지 않은 구조를 갖고 있습니다.

위의 단점을 해결하기 위해 Bloc의 1회성 UI 이벤트 emit을 위한 방법을 제공합니다.

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

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/one_time_emitter/bloc/ote_home_bloc.dart#L36)을 참고해주세요.

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

또한 위젯트리를 깔끔하게 관리하기 위해 `MultiBlocOneTimeListener` 또한 제공합니다.

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/one_time_emitter/one_time_emitter_home_page.dart#L102)을 참고해주세요.

### BlocResetter

<img src="https://github.com/user-attachments/assets/7e158d90-dfae-47f7-94a0-1d8809b8f905" width="300px" />

일반적인 상황에서는 Bloc의 초기상태로 리셋하는 경우에는 `emit(InitState())` 를 호출하거나, Bloc의 위젯트리에서 제거되었다가 다시 초기화되면 됩니다.  
하지만, `위젯트리에서 제거되지 않는 Bloc*`의 경우에는 `emit(InitState())` 호출을 위한 이벤트 클래스를 만들어야 할 뿐더러, 그 수가 많을 경우 관리하는 것이 힘들어집니다.

> [!NOTE]
> `*위젯트리에서 제거되지 않는 Bloc`
> - MaterialApp 상단에서 BlocProvider로 제공되는 경우
> - main 함수 근처에서 싱글톤으로 초기화되어 제공되는 경우

위에서 소개된 위젯 생명주기에 종속되지 않는 여러 Bloc의 초기화를 간편하게 하기 위한 방법을 제공합니다.

`BlocResetter` mixin을 상속받은 Bloc는 `reset` 메서드와 더불어 `register`, `unregister` 메서드를 사용할 수 있게 됩니다.

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

`BlocResetter` mixin은 Bloc의 초기 상태를 캡처하여 `reset` 호출 시 캡처된 초기 상태를 emit합니다. (필요에 따라 `onReset`으로 등록된 핸들러도 함께 호출됩니다)  
하지만, 이 mixin 단독으로는 할 수 있는 역할이 없습니다.

효과적인 사용을 위해 `register`를 생성자 함수에서 호출하여 [BlocResetRegistry](#blocresetregistry) 정적 유틸 클래스에 등록한 뒤에 함께 사용해주세요.

> [!TIP]
> `unregister`는 [BlocResetRegistry](#blocresetregistry)에서 Bloc을 제거합니다.  
> 하지만, Bloc.close가 호출되면 `unregister` 메서드가 자동으로 호출되기 때문에 사용할 일은 거의 없습니다.

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/bloc_resetter/bloc/global_bloc.dart#L10)을 참고해주세요.

### BlocResetRegistry

<img src="https://github.com/user-attachments/assets/bed0c8c8-e392-4f6f-954e-bbecf48a0a0d" width="300px" />

[BlocResetter](#blocresetter)와 반드시 함께 사용해야 하는 정적 유틸 클래스입니다.

#### `addBloc`, `removeBloc`

두 메서드로 `BlocResetRegistry`에서 관리할 Bloc을 추가하거나 삭제할 수 있습니다.  
추가하거나, 제거한다고 해서 Bloc의 생명주기에는 영향을 주지 않지만, Bloc의 생명주기에 따라 (register를 생성자에서 호출하는경우) 자동으로 추가되거나 삭제됩니다.  
(즉, 두 메서드를 사용할 일은 거의 없습니다.)

#### `resetBlocs`

`BlocResetRegistry`에 등록된 Bloc들을 초기상태로 되돌립니다.  
`withCallback`이 `true(기본값)`라면 `BlocResetter.register`로 등록된 `onReset` 콜백도 함께 실행됩니다.

#### `get<T>`

`context.get`과 같이 `BlocResetRegistry`에 등록된 Bloc을 가져올 수 있습니다.  

> [!TIP]
> 다음과 같은 방식으로 Bloc을 싱글톤 객체처럼 활용할 수 있습니다.
> ```dart
> class ConfigBloc extends Bloc<ConfigEvent, ConfigState> with BlocResetter {
>   ConfigBloc() : super(ConfigInitState() {
>     register();
>   }
>   // 여느 Bloc과 동일
> }
> 
> void main() {
>   ConfigBloc(); // BlocResetter가 자동으로 BlocResetRegister에 등록.
>   runApp(const MyApp());
> }
>
> final configBloc = BlocResetRegister.get<ConfigBloc>(); // 글로벌 접근 가능
> ```

> [!WARNING]
> Bloc의 생명주기에 따라 `BlocResetRegister`에서 자동으로 추가되거나 삭제되기 때문에, `BlocProvider`로 제공되는 Bloc을 전역에서 접근하지 마세요.  
> 접근해도 문제는 없으나, 해당 Bloc이 위젯트리에서 제거되고 난 뒤 접근할 시 `BlocResetRegistryGetNullException`이 발생합니다.
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
> 즉, 생명주기에서 불변성이 보장된 Bloc만 [BlocResetter](#blocresetter)를 상속하여 사용하세요.

자세한 코드 예시는 [example](https://github.com/wjlee611/bloc_mixins/blob/220cf9f21dc5b43e86b761632acd3704f94c377e/example/lib/presentation/bloc_resetter/bloc_resetter_home_page.dart#L40)을 참고해주세요.

## API 문서

더 디테일한 API 문서는 [API reference](https://pub.dev/documentation/bloc_mixins/latest/bloc_mixins/)를 참고해주세요.
