import XCTest
@testable import TRU_Assignment

private final class MockProductsUseCase: ProductsUseCaseProtocol {
    var fetchResultQueue: [Result<[Product], Error>] = []
    var cachedProducts: [Product] = []
    private(set) var lastFetchLimit: Int?
    private(set) var clearCacheCount: Int = 0

    func fetchProducts(limit: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        lastFetchLimit = limit
        let result = fetchResultQueue.isEmpty ? .success([]) : fetchResultQueue.removeFirst()
        DispatchQueue.main.async { completion(result) }
    }

    func refreshProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        clearCache()
        fetchProducts(limit: 7, completion: completion)
    }

    func getCachedProducts(page: Int) -> [Product] {
        let start = page * 7
        let end = min(start + 7, cachedProducts.count)
        if start < end { return Array(cachedProducts[start..<end]) }
        return []
    }

    func clearCache() { clearCacheCount += 1 }
}

final class ProductsViewModelTests: XCTestCase {
    private var mockUseCase: MockProductsUseCase!
    private var viewModel: ProductsViewModel!

    override func setUp() async throws {
        try await super.setUp()
        mockUseCase = MockProductsUseCase()
        viewModel = await ProductsViewModel(useCase: mockUseCase)
    }

    override func tearDown() async throws {
        mockUseCase = nil
        viewModel = nil
        try await super.tearDown()
    }

    func test_loadProducts_success_updatesState() async {
        mockUseCase.fetchResultQueue = [.success(.samples(count: 5))]

        await viewModel.loadProducts()
        // wait for main queue dispatch
        await Task.yield()

        let products = await viewModel.products
        let isLoading = await viewModel.isLoading
        let error = await viewModel.errorMessage

        XCTAssertEqual(products.count, 5)
        XCTAssertFalse(isLoading)
        XCTAssertNil(error)
        XCTAssertEqual(mockUseCase.lastFetchLimit, 7)
    }

    func test_loadProducts_failure_setsErrorAndDoesNotRetryForNonNetwork() async {
        mockUseCase.fetchResultQueue = [.failure(APIError.notFoundError)]

        await viewModel.loadProducts()
        await Task.yield()

        let products = await viewModel.products
        let error = await viewModel.errorMessage

        XCTAssertTrue(products.isEmpty)
        XCTAssertEqual(error, APIError.notFoundError.localizedDescription)
    }

    func test_loadProducts_retryOnNetworkErrors_upToMaxRetries() async {
        mockUseCase.fetchResultQueue = [
            .failure(APIError.noInternet),
            .failure(APIError.requestTimeOut),
            .success(.samples(count: 7))
        ]

        await viewModel.loadProducts()
        // allow retries to schedule and complete
        try? await Task.sleep(nanoseconds: 1_500_000_000)

        let products = await viewModel.products
        XCTAssertEqual(products.count, 7)
    }

    func test_loadMore_increasesLimitAndCallsFetch() async {
        mockUseCase.fetchResultQueue = [.success(.samples(count: 7)), .success(.samples(count: 12))]

        await viewModel.loadProducts()
        await Task.yield()

        await viewModel.loadMoreProducts()
        await Task.yield()

        XCTAssertEqual(mockUseCase.lastFetchLimit, 14)
    }

    func test_refresh_resetsStateAndFetches() async {
        mockUseCase.fetchResultQueue = [.success(.samples(count: 7))]
        await viewModel.refreshProducts()
        await Task.yield()
        XCTAssertEqual(mockUseCase.lastFetchLimit, 7)
        let products = await viewModel.products
        XCTAssertEqual(products.count, 7)
    }

    func test_shouldLoadMore_triggersNearEnd() async {
        mockUseCase.fetchResultQueue = [.success(.samples(count: 7))]
        await viewModel.loadProducts()
        await Task.yield()

        let products = await viewModel.products
        let shouldLoadNearEnd = await viewModel.shouldLoadMore(for: products[5])
        let shouldNotLoadAtStart = await viewModel.shouldLoadMore(for: products[0])

        XCTAssertTrue(shouldLoadNearEnd)
        XCTAssertFalse(shouldNotLoadAtStart)
    }
}