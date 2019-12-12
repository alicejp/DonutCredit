import UIKit

class ProcessViewModel
{
    var creditScore: Int? {
        return credit?.score
    }

    var maxScoreValue: Int? {
        return credit?.maxScoreValue
    }

    var progressRatio: CGFloat {
        guard let creditScore = creditScore, let maxScoreValue = maxScoreValue else {
            return CGFloat(0)
        }
        return CGFloat(creditScore) / CGFloat(maxScoreValue)
    }

    private var credit: CreditReportInfo?
    private let creditScoreService: CreditScoreSreviceProtocol

    init(creditScoreService: CreditScoreSreviceProtocol)
    {
        self.creditScoreService = creditScoreService
    }

    func fetchCredit(completionHandler: @escaping (Result<Void, Error>) -> Void)
    {
        creditScoreService.fetchCredit {
            [weak self] (credit, error) in
            guard let self = self else { return }

            if let error = error {
                completionHandler(.failure(error))
                return
            }

            self.credit = credit
            completionHandler(.success(()))
        }
    }
}
