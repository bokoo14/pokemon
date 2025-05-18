# poka-market-ios-task
포켓몬

## 개발 환경
- **개발 도구**: Xcode 16.2
- **개발 언어**: Swift 5+
- **Deployment Target(최소 지원 버전)**: iOS 16
- **UI 프레임워크**: SwiftUI
- **라이브러리/패키지 관리**: SPM
- **서드파티 라이브러리**: Alamofire, Kingfisher, Swinject


## 기술 스택
- Combine: 반응형 프로그래밍
- CoreData: 로컬 데이터 저장 및 관리
- Alamofire: API 통신
- Swinject: 의존성 주입
- Kingfisher: 이미지 캐싱
- 포켓몬 TCG API: 포켓몬 데이터


## 서드파티 라이브러리 및 CoreData 선정 이유
### Alamofire (https://github.com/Alamofire/Alamofire)
- URLSession보다 더 높은 수준의 추상화를 제공하여 네트워크 코드 작성이 간결
- 대체 방법
    - Moya: Alamofire를 한번 더 추상화하여 추가 종속성 발생 (과도한 추상화가 될 수 있음)
    - URLSession: 외부 종속성 없음(네이티브 API), 많은 코드 필요

### Kingfisher (https://github.com/onevcat/Kingfisher)
- 이미지 로딩, 캐싱, 메모리 관리를 자동으로 처리
- 대체 방법
    - SDWebImage: 오랜 역사와 안정성, Objective-C 기반으로 Swift와의 통합성이 덜 자연스러우며 SwiftUI 통합은 별도 패키지 필요
    - Nuke: 매우 가볍고 성능에 최적화, 커뮤니티 규모가 상대적으로 작음 (8.3k)

### Swinject (https://github.com/Swinject/Swinject)
- Clean Architecture 구현에 필수적인 의존성 주입 패턴을 간편하게 적용
- 계층 간 결합도를 낮추어 코드 유지보수성 및 확장성 향상
- 대체 방법
    - Needle: 초기 설정이 복잡
    - Resolver: Swinject보다 커뮤니티 규모가 작음 (2.2k)

### CoreData
- Swift와 완벽하게 통합되어 있으며 Apple이 직접 지원하는 안정적인 프레임워크 (퍼스트 파티)
- 대체 방법
    - Realm: 더 빠른 성능을 제공하지만, 외부 종속성 추가 및 데이터 마이그레이션이 복잡할 수 있음
    - SQLite: 낮은 수준의 제어가 가능하지만 관계형 데이터 모델링을 위한 추가 코드 작성 필요
    - UserDefaults: 간단한 사용자 설정(간단한 key-value 저장에 적합)에 적합하지만 복잡한 데이터 모델이나 큰 데이터셋에는 적합하지 않음
    - SwiftData: iOS 17부터 지원 (최소 지원 버전인 16과 맞지 않음) (https://developer.apple.com/documentation/swiftdata)


## 아키텍쳐 설계
Clean Architecture + MVVM
```
.
└── Pokemon
    ├── Pokemon
    │   ├── Application
    │   ├── Core
    │   │   ├── Component
    │   │   ├── DI
    │   │   ├── Foundation+Extensions
    │   │   ├── QueryBuilder
    │   │   └── Transformer
    │   ├── Data
    │   │   ├── Local
    │   │   │   └── Pokemon.xcdatamodeld
    │   │   │       └── Pokemon.xcdatamodel
    │   │   ├── Remote
    │   │   │   ├── DTO
    │   │   │   └── Requests
    │   │   ├── Repositories
    │   │   └── UseCases
    │   ├── Domain
    │   │   ├── Entities
    │   │   ├── Interfaces
    │   │   │   └── Repositories
    │   │   └── UseCases
    │   ├── Infrastructure
    │   │   └── Network
    │   │       └── Interfaces
    │   ├── Presentation
    │   │   ├── PokemonDetail
    │   │   └── PokemonList
    │   ├── Preview Content
    │   │   └── Preview Assets.xcassets
    │   └── Resources
    │       └── Assets.xcassets
    │           ├── AccentColor.colorset
    │           └── AppIcon.appiconset
    └── Pokemon.xcodeproj
        ├── project.xcworkspace
        │   ├── xcshareddata
        │   │   └── swiftpm
        │   │       └── configuration
        │   └── xcuserdata
        │       └── bokyung.park.xcuserdatad
        └── xcuserdata
            └── bokyung.park.xcuserdatad
                ├── xcdebugger
                └── xcschemes
```

### Application
앱의 시작점

### Core
앱의 기본 구성 요소들
- Component: 재사용 가능한 공통 UI 컴포넌트
- DI: Swinject를 이용한 의존성 주입
- Foundation+Extensions: Swift의 기본 타입을 확장한 유틸
- QueryBuilder: API 요청 시 필요한 쿼리 파라미터 생성 빌더
- Transformer: 데이터 변환 (Coredata값 변환)

### Data
API 통신, 로컬 저장소, DTO/Request 구조 정의
- Remote/DTO: 서버 응답 객체
- Remote/Requests: API endpoint 및 메서드 정의
- Repositories: 외부 데이터 소스를 접근하는 실제 구현
- Local: CoreData를 이용한 데이터 저장 (로컬 DB)
- UseCases: Domain의 UseCase 구현

### Domain
앱의 비즈니스 로직과 추상화를 정의
- Entities: 앱에서 사용되는 핵심 모델 정의
- Interfaces: Repository, UseCase의 Protocol 정의
- UseCases: 비즈니스 로직을 담당하는 추상화 계층

### Infrastructure
네트워크 계층
- Network/Interfaces: 네트워크 요청을 추상화한 인터페이스

### Presentation
ViewModel, View 구현
- PokemonList: 포켓몬 리스트 화면
- PokemonDetail: 포켓몬 상세 화면
