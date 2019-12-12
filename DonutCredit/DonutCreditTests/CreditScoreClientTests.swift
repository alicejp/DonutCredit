import XCTest
import OHHTTPStubs
@testable import DonutCredit

class CreditScoreClientTests: XCTestCase
{
    var client: CreditScoreClient!
    override func setUp()
    {
       super.setUp()
       client = CreditScoreClient()
    }

    override func tearDown()
    {
        OHHTTPStubs.removeAllStubs()
        client = nil
        super.tearDown()
    }

    func test_fetch_succeed()
    {
        let exp = self.expectation(description: "Fetch credit score succeed")
        stubFetchRequest()
        client.fetchCredit {
            (credit, error) in
            XCTAssertNotNil(credit)
            XCTAssertEqual(credit?.score, 514)
            XCTAssertEqual(credit?.maxScoreValue, 700)
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func test_fetch_request_network_not_connected()
    {
        let exp = self.expectation(description: "Fetch credit score failed")
        simulateNetworkNotConnected()

        client.fetchCredit {
            (credit, error) in
            XCTAssertNil(credit)
            XCTAssertNotNil(error)
            exp.fulfill()
        }

        waitForExpectations(timeout: 0.5, handler: nil)

    }

    private func stubFetchRequest(statusCode: Int32 = 200)
    {
        OHHTTPStubs.stubRequests(passingTest: {
            request -> Bool in
            return request.httpMethod! == "GET"
        }, withStubResponse: {
            _ -> OHHTTPStubsResponse in

            let path = Bundle(for: type(of: self)).path(forResource: "amazonaws", ofType: "json")
            return OHHTTPStubsResponse(fileAtPath: path!,
                                       statusCode: statusCode,
                                       headers: [ "Content-Type": "application/json; charset=utf-8"]
            )
        })
    }
}

extension XCTestCase
{
    func simulateNetworkNotConnected()
    {
        OHHTTPStubs.stubRequests(passingTest: {
            _ -> Bool in
            return true
        }, withStubResponse: {
            _ -> OHHTTPStubsResponse in
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            return OHHTTPStubsResponse(error: notConnectedError)
        })
    }
}
