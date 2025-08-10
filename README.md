## My Shop
A client iOS app that presents a list of products using MVVM with Clean Architecture, offline caching via Core Data, skeleton loading animations, and a reusable Moya-based network layer.

### Tech stack
- **Architecture**: MVVM + Clean Architecture (UseCase, Repository, Data layer)
- **Networking**: Moya (with custom transport + URLSession config)
- **Animations**: SkeletonView (CocoaPods)
- **Persistence**: Core Data (with in-memory fallback until model is set up)
- **UI**: UIKit + Storyboards

## Architecture
- **Presentation (Views + ViewModel)**: UIKit view controllers observe `ProductsViewModel` that exposes `products`, `isLoading`, and `errorMessage`.
- **Domain (UseCase)**: `ProductsUseCase` orchestrates fetching, refresh, pagination, and cache queries.
- **Data (Repository + Requests + Persistence)**:
  - `ProductsRepository` decides between network and cached data, persists results, and falls back to cache on network issues.
  - `ProductsRequest` builds and executes API calls using the network layer.
  - `CoreDataManager` handles saving/fetching entities when Core Data is available; otherwise uses an in-memory cache.
- **Network Layer**: Built on Moya with a custom `APIEndpoint` abstraction and a `NetworkClient` that provides typed decode, error mapping, and retry behavior for selected errors.

### Data flow
View (UIKit) → ViewModel → UseCase → Repository → (Network via Moya) and/or (Core Data cache) → ViewModel → View

## Networking
- **Pods**: `Moya`
- **Abstractions**:
  - `APIEndpoint` defines `baseURL`, `path`, `method`, `task`, `headers`.
  - `MoyaProvider+Transport` bridges `APIEndpoint` to Moya `TargetType` and configures a custom `URLSession` (timeouts, logger plugin).
  - `NetworkClient` executes requests, decodes `Decodable` types, maps HTTP status codes, and retries under certain conditions.
- **Errors**: `APIError` handles `backendError`, `forbiddenError`, `notFoundError`, `notAuthorized`, `noInternet`, `requestTimeOut`, and `otherError`.
- **Products API**: `ProductsAPI.getProducts(limit:)` requests `https://fakestoreapi.com/products?limit=...`.

## Persistence (Core Data)
- **Manager**: `CoreDataManager` wraps `NSPersistentContainer(name: "TRU_Assignment")` and provides save/fetch/clear helpers.
- **Entity**: `ProductEntity` (manual codegen expected). Until you add it in the model editor, the app uses an in-memory cache transparently.
- **Guide**: See `TRU Assignment/CoreData_Setup_Guide.md` for step-by-step instructions to create `ProductEntity` and attributes.

## Animations (Skeleton Loading)
- **Pod**: `SkeletonView`
- **Usage**: Product list screens import SkeletonView and show skeletons while loading data, then hide on success or error.

## Folder tree
```text
TRU Assignment/
├─ APP/
│  ├─ AppDelegate.swift
│  └─ SceneDelegate.swift
├─ Assets.xcassets/
├─ Base.lproj/
│  ├─ LaunchScreen.storyboard
│  └─ Main.storyboard
├─ Core/
│  └─ Products/
│     ├─ API/
│     │  ├─ ProductsAPI.swift
│     │  └─ list Products Request.swift
│     └─ CoreData/
│        ├─ CoreDataManager.swift
│        ├─ ProductEntity+CoreDataClass.swift
│        └─ ProductEntity+CoreDataProperties.swift
├─ Extensions/
│  └─ UINavigationBar+Extensions.swift
├─ Features/
│  ├─ Product/
│  │  ├─ Model/
│  │  │  └─ Product Model.swift
│  │  ├─ Repository/
│  │  │  └─ Products Repository.swift
│  │  ├─ UseCase/
│  │  │  └─ Products Usecase.swift
│  │  ├─ ViewModel/
│  │  │  └─ Products ViewModel.swift
│  │  └─ Views/
│  │     ├─ Cell/
│  │     ├─ ProductListViewController.swift
│  │     ├─ ProductList_CollectionView.swift
│  │     └─ ProductList_Navigation.swift
│  └─ Product Details/
│     ├─ Cell/
│     ├─ ProductDetailsViewController.swift
│     └─ ProductDetails_Stretchy.swift
├─ Network/
│  ├─ NetworkReachabilityManager.swift
│  ├─ Headers/
│  │  └─ Headers .swift
│  ├─ Network layer/
│  │  ├─ APIEndpoint.swift
│  │  ├─ Client.swift
│  │  ├─ GenricAPIResponse.swift
│  │  ├─ MoyaProvider+Transport.swift
│  │  ├─ NetworkClient.swift
│  │  └─ Transport.swift
│  ├─ NetworkError/
│  │  ├─ APIError.swift
│  │  └─ BackendError.swift
│  └─ Resources/
├─ TRU_Assignment.xcdatamodeld/
│  ├─ .xccurrentversion
│  └─ TRU_Assignment.xcdatamodel/
├─ Info.plist
└─ CoreData_Setup_Guide.md

TRU AssignmentTests/
└─ TRU_AssignmentTests.swift

TRU AssignmentUITests/
├─ TRU_AssignmentUITests.swift
└─ TRU_AssignmentUITestsLaunchTests.swift
```

## MVVM details
- **ViewModel**: `ProductsViewModel` exposes state, handles initial load, retry logic for transient network errors, refresh, and incremental paging (increases limit by 7).
- **UseCase**: `ProductsUseCase` coordinates repository calls and logs/filters network errors.
- **Repository**: `ProductsRepository` performs network-first fetch, persists to Core Data when available, and falls back to cache on `noInternet`, `requestTimeOut`, or similar errors.

## CocoaPods
Podfile contains:
```ruby
pod 'Moya'
pod 'SkeletonView'
```
Run:
```bash
pod install
open "TRU Assignment.xcworkspace"
```

## Run
- Open `TRU Assignment.xcworkspace`
- Select a simulator and Run

