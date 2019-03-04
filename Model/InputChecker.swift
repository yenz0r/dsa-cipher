//
//  InputChecker.swift
//  DSA-result
//
//  Created by Egor Pii on 11/20/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Cocoa

class InputChecker {
    var workLine = ""

    func isEmptyArr(_ workArr: [UInt8]) -> Bool {
        return workArr.isEmpty
    }

    private func checkNumber() -> Bool {
        return Int(self.workLine) != nil
    }

    func result() -> Bool {
        return checkNumber()
    }

    func dialogError(question: String, text: String) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Ok")
        alert.runModal()
    }
}
