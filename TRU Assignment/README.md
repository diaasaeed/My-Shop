# TRU Assignment - Products App

A SwiftUI-based iOS application that demonstrates MVVM Clean Architecture with Core Data for offline storage and pagination support.

## Features

- ✅ **MVVM Clean Architecture**: Proper separation of concerns with Repository, Use Case, and ViewModel layers
- ✅ **Core Data Integration**: Offline storage for products with automatic caching
- ✅ **Pagination**: Load products in batches of 15 with infinite scrolling
- ✅ **Network Reachability**: Automatic fallback to cached data when offline
- ✅ **Pull-to-Refresh**: Refresh products with swipe gesture
- ✅ **Error Handling**: Comprehensive error handling with retry functionality
- ✅ **Modern UI**: Beautiful SwiftUI interface with loading states

## Architecture Overview

### Layers

1. **Presentation Layer (SwiftUI)**
   - `ProductsView.swift` - Main view with pagination and pull-to-refresh
   - `ProductCell.swift` - Reusable product cell component

2. **ViewModel Layer**
   - `ProductsViewModel.swift` - Manages UI state and business logic

3. **Domain Layer**
   - `ProductsUseCase.swift` - Business logic and pagination logic

4. **Data Layer**
   - `ProductsRepository.swift` - Data access abstraction
   - `CoreDataManager.swift` - Core Data operations
   - `NetworkReachabilityManager.swift` - Network connectivity monitoring

5. **Network Layer**
   - `ProductsAPI.swift` - API endpoint definitions
   - Existing network infrastructure from the project

6. **Models**
   - `Product.swift` - Data model
   - `ProductEntity+CoreDataClass.swift` - Core Data entity
   - `ProductEntity+CoreDataProperties.swift` - Core Data properties

## Setup Instructions

### Prerequisites
- Xcode 15.0+
- iOS 15.0+
- Swift 5.9+

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd "TRU Assignment"
   ```

2. **Open the project**
   ```bash
   open TRU_Assignment.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Core Data Setup

The app uses Core Data for offline storage. The Core Data model (`TRU_Assignment.xcdatamodeld`) should include:

- **ProductEntity** with the following attributes:
  - `id` (Int64)
  - `title` (String)
  - `price` (Double)
  - `productDescription` (String)
  - `category` (String)
  - `image` (String)
  - `ratingRate` (Double)
  - `ratingCount` (Int64)
  - `createdAt` (Date)

## API Endpoint

The app fetches products from:
```
https://fakestoreapi.com/products?limit=15&skip={offset}
```

## Usage

### Online Mode
- App fetches products from the API
- Automatically caches products to Core Data
- Supports pagination with 15 products per page

### Offline Mode
- App automatically detects network connectivity
- Falls back to cached data from Core Data
- Shows cached products when no internet connection is available

### Pagination
- Initial load: 15 products
- Scroll to bottom to load more products
- Automatic loading when 3 items away from the end

### Refresh
- Pull down to refresh the product list
- Clears cache and fetches fresh data

## Key Components

### ProductsViewModel
- Manages loading states (`isLoading`, `isLoadingMore`)
- Handles pagination logic
- Provides error handling and retry functionality

### ProductsRepository
- Abstracts data access
- Handles network vs cache logic
- Manages Core Data operations

### CoreDataManager
- Singleton for Core Data operations
- Provides CRUD operations for products
- Handles batch operations and context management

### NetworkReachabilityManager
- Monitors network connectivity
- Provides real-time connection status
- Enables offline/online mode switching

## Error Handling

The app handles various error scenarios:
- Network connectivity issues
- API errors
- Core Data errors
- Timeout errors

Users can retry failed operations through the UI.

## Testing

To test offline functionality:
1. Run the app and load some products
2. Turn off internet connection (Airplane Mode)
3. Refresh the app - it should show cached products
4. Turn internet back on and refresh to get fresh data

## Dependencies

- **Moya**: Network abstraction layer
- **Core Data**: Local data persistence
- **SwiftUI**: Modern UI framework
- **Combine**: Reactive programming

## License

This project is created for TRU Assignment purposes. 