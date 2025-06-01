//
//  ErrorViewModel.swift
//  MensaBar
//
//  Created by Max Niclas Wächtler on 01.06.25.
//

import Foundation

struct ErrorViewModel {
    var errorDate: Date?
    var errorTitle: String
    var errorMessage: String
    var errorDisplayTitle: String
    var errorDisplayMessage: String
    
    init(errorTitle: String, errorMessage: String, errorDisplayTitle: String, errorDisplayMessage: String, errorDate: Date?) {
        self.errorTitle = errorTitle
        self.errorDisplayTitle = errorDisplayTitle
        self.errorMessage = errorMessage
        self.errorDisplayMessage = errorDisplayMessage
        self.errorDate = errorDate
    }
    
    private func getIssueTitle() -> String {
        return "[BUG] error: " + self.errorTitle
    }
    
    private func getIssueBody() -> String {
        return """
**Error content**
<!--Debug information needed to identify the error.-->
```
\(self.errorMessage)
```

**Menu date**
\(getTimestamp())

**Additional information**
<!--Add additional information here! :)-->
"""
    }
    
    func getErrorIssueUrl() -> URL {
        let REPO_URL = Constants.Urls.repositoryBaseUrl
        
        var urlComponents = URLComponents(
            url: REPO_URL,
            resolvingAgainstBaseURL: true
        )!
        let queryItems = [
            URLQueryItem(name: "title", value: getIssueTitle()),
            URLQueryItem(name: "body", value: getIssueBody()),
            URLQueryItem(name: "labels", value: "bug")
        ]
        urlComponents.queryItems = queryItems
        return urlComponents.url ?? REPO_URL
    }
    
    private func getTimestamp() -> String {
        if self.errorDate == nil {
            return "n/a"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self.errorDate!)
    }
}
