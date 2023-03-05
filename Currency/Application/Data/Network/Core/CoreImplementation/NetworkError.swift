import Foundation

enum NetworkError: Error {
    case network(CustomNetworkingError)
    case json
    case offline
    case other(Error)
}

public struct CustomNetworkingError: Error {

    let httpResponse: HTTPURLResponse?
    let networkData: Data?
    let baseError: NetworkLayerError
    let statusCode: Int

    init(_ response:Response) {
        self.baseError = NetworkLayerError.statusCode(response)
        self.httpResponse = response.response
        self.statusCode = response.statusCode
        self.networkData = response.data
        Logger.debugingLog(fileName: #file.description,
                           functionName: #function.description,
                           LineNumber: #line.description,
                           data: [
                            "service.host": response.request?.url?.absoluteString,
                            "failureResult.statusCode": statusCode as Any,
                            "failureResult.response": String(data: (networkData) ?? Data(),
                                                                   encoding: .utf8) ?? "",
                            "failureResult.reason": getLocalizedDescription()
                           ])
    }

    func getLocalizedDescription() -> String {

       return self.baseError.localizedDescription
    }
}
