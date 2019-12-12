import Foundation

protocol CreditScoreClientProtocol
{
    func fetchCredit(completionHandler: @escaping (CreditReportInfo?, Error?) -> Void)
}

class CreditScoreClient: CreditScoreClientProtocol
{
    func fetchCredit(completionHandler: @escaping (CreditReportInfo?, Error?) -> Void)
    {
        let session = URLSession.shared
        let url = URL(string: "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values")!

        let task = session.dataTask(with: url) {
            data, response, error in

            if error != nil {
                completionHandler(nil, error)
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let creditReport = try decoder.decode(CreditReport.self, from: data)

                completionHandler(creditReport.creditReportInfo, nil)
            } catch let parseError {
                completionHandler(nil, parseError)
            }
        }

        task.resume()
    }
}

