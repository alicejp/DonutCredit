import Foundation
protocol CreditScoreSreviceProtocol
{
    func fetchCredit(completionHandler: @escaping (CreditReportInfo?, Error?) -> Void)
}

class CreditScoreSrevice: CreditScoreSreviceProtocol
{
    private var client: CreditScoreClient

    init(client: CreditScoreClient)
    {
        self.client = client
    }

    func fetchCredit(completionHandler: @escaping (CreditReportInfo?, Error?) -> Void)
    {
        client.fetchCredit {
            (credit, error) in
            if let credit = credit {
                completionHandler(credit, nil)
            }
            else if let error = error {
                completionHandler(nil, error)
            }
        }
    }
}
