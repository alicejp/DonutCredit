import XCTest
@testable import DonutCredit

class ProcessViewModelTests: XCTestCase
{
    var service: CreditScoreServiceMock!
    var viewModel: ProcessViewModel!
    override func setUp()
    {
        super.setUp()
        service = CreditScoreServiceMock()
        viewModel = ProcessViewModel(creditScoreService: service)
    }

    override func tearDown()
    {
        service = nil
        viewModel = nil
        super.tearDown()
    }

    func test_creditScore()
    {
        XCTAssertNil(viewModel.creditScore)
        viewModel.fetchCredit {
            result in
            switch result
            {
            case .success:
                XCTAssertEqual(self.viewModel.creditScore, 300)
            case .failure:
                XCTFail()
            }
        }
    }

    func test_maxScoreValue()
    {
        XCTAssertNil(viewModel.maxScoreValue)
        viewModel.fetchCredit {
            result in
            switch result
            {
            case .success:
                XCTAssertEqual(self.viewModel.maxScoreValue, 400)
            case .failure:
                XCTFail()
            }
        }
    }

    func test_progressRatio()
    {
        XCTAssertEqual(viewModel.progressRatio, CGFloat(0))
        viewModel.fetchCredit {
            result in
            switch result
            {
            case .success:
                XCTAssertEqual(self.viewModel.progressRatio, CGFloat(300) / CGFloat(400))
            case .failure:
                XCTFail()
            }
        }
    }

    func test_fetchCredit_succeed()
    {
        let exp = self.expectation(description: "Fetch credit succeed")
        service.fetchFailed = false
        viewModel.fetchCredit {
            result in
            switch result
            {
            case .success:
                exp.fulfill()
            case .failure:
                XCTFail()
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func test_fetchCredit_failed()
    {
        let exp = self.expectation(description: "Fetch credit failed")

        service.fetchFailed = true
        viewModel.fetchCredit {
            result in
            switch result
            {
            case .success:
                XCTFail()
            case .failure:
                exp.fulfill()
            }
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}

class CreditScoreServiceMock: CreditScoreSreviceProtocol
{
    var fetchFailed = false
    func fetchCredit(completionHandler: @escaping (CreditReportInfo?, Error?) -> Void) {
        if fetchFailed
        {
            let notConnectedError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            completionHandler(nil, notConnectedError)
        }
        else
        {
            completionHandler(CreditReportInfo(score: 300, maxScoreValue: 400), nil)
        }
    }
}
