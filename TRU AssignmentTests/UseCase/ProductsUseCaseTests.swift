import XCTest
@testable import TRU_Assignment

final class ProductsUseCaseTests: XCTestCase {
    private var mockRepository: MockProductsRepository!
    private var useCase: ProductsUseCase!

    override func setUp() {
        super.setUp()
        mockRepository = MockProductsRepository()
        useCase = ProductsUseCase(repository: mockRepository)
    }

    override func tearDown() {
        mockRepository = nil
        useCase = nil
        super.tearDown()
    }

    func test_fetchProducts_success_returnsProducts() {
        let expected = [Product.sample(id: 1), .sample(id: 2)]
        mockRepository.fetchResultQueue = [.success(expected)]

        let exp = expectation(description: "fetch success")
        var received: [Product] = []

        useCase.fetchProducts(limit: 7) { result in
            if case let .success(products) = result { received = products }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
        XCTAssertEqual(received.count, expected.count)
        XCTAssertEqual(self.mockRepository.lastFetchLimit, 7)
    }

    func test_fetchProducts_failure_propagatesError() {
        mockRepository.fetchResultQueue = [.failure(APIError.noInternet)]

        let exp = expectation(description: "fetch failure")
        var receivedError: Error?

        useCase.fetchProducts(limit: 7) { result in
            if case let .failure(error) = result { receivedError = error }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual(receivedError as? APIError, .noInternet)
    }

    func test_refreshProducts_clearsCacheAndFetches() {
        mockRepository.fetchResultQueue = [.success([.sample(id: 1)])]

        let exp = expectation(description: "refresh success")
        useCase.refreshProducts { _ in exp.fulfill() }

        wait(for: [exp], timeout: 2)
        XCTAssertEqual(mockRepository.clearCacheCallCount, 1)
        XCTAssertEqual(mockRepository.lastFetchLimit, 7)
    }

    func test_getCachedProducts_usesPageSize7() {
        mockRepository.cachedProductsStore = .samples(count: 20)
        let page0 = useCase.getCachedProducts(page: 0)
        let page1 = useCase.getCachedProducts(page: 1)

        XCTAssertEqual(page0.count, 7)
        XCTAssertEqual(page1.count, 7)
        XCTAssertEqual(page0.first?.id, 1)
        XCTAssertEqual(page1.first?.id, 8)
    }
}