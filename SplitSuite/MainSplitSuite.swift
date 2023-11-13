//
//  MainSplitSuite.swift
//  SplitSuite
//
//  Created by Javier Avrudsky on 08/11/2023.
//

import Foundation
import Split

class MainSplitSuite: SharedSplitSuite {
    func blabla() {

    }
}

protocol SplitClient {
    func pepe()
}

class DefaultSplitClient: SplitClient {
    var client: Split.SplitClient?
    func pepe() {
    }
}
