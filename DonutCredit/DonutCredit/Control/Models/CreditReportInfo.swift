import Foundation

struct CreditReportInfo: Decodable
{
    let score: Int
    let maxScoreValue: Int
}

struct CreditReport: Decodable
{
    let creditReportInfo: CreditReportInfo
}
