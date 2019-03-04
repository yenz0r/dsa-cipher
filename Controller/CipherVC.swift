//
//  CipherVC.swift
//  DSA-result
//
//  Created by Egor Pii on 11/20/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Cocoa

fileprivate extension Int {
    func isPrime() -> Bool {
        if self == 1 {
            return false
        }

        if self == 2 {
            return true
        }

        for i in 2..<self {
            if self % i == 0 {
                return false
            }
        }
        return true
    }
}

class CipherVC: NSViewController {
    //interface values
    @IBOutlet weak var inputFileTextField: NSTextField!
    @IBOutlet weak var inputFileBinaryTextField: NSTextField!
    @IBOutlet weak var pTextField: NSTextField!
    @IBOutlet weak var qTextField: NSTextField!
    @IBOutlet weak var xTextField: NSSecureTextField!
    @IBOutlet weak var kTextField: NSTextField!
    @IBOutlet weak var rTextField: NSTextField!
    @IBOutlet weak var sTextField: NSTextField!
    @IBOutlet weak var yTextField: NSTextField!
    @IBOutlet weak var hashTextField: NSTextField!
    @IBOutlet weak var timeTextField: NSTextField!
    @IBOutlet weak var fileProgressBar: NSProgressIndicator!
    @IBOutlet weak var resultColorIdentifier: NSColorWell!
    //end interface values

    //global values
    var inputArr = [UInt8]()
    var fileURL: URL!
    var dataProvider = DataProvider()
    var inputChecker = InputChecker()

    var q: Int?
    var p: Int?
    var k: Int?
    var x: Int?
    var s: Int?
    var r: Int?
    var y: Int?
    //end global values

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //interface actions
    @IBAction func loadFileAction(_ sender: Any) {
        inputArr = dataProvider.loadData()

        inputFileBinaryTextField.stringValue = ""
        for element in inputArr {
            inputFileBinaryTextField.stringValue.append(String(element) + " ")
        }

        inputFileTextField.stringValue = dataProvider.getString()
        fileProgressBar.increment(by: 100)
        resultColorIdentifier.color = .blue
    }

    @IBAction func saveFileAction(_ sender: Any) {
        dataProvider.saveString(inputFileTextField.stringValue)
    }
    
    @IBAction func cipherAction(_ sender: Any) {
        takeInputParam(&self.p, pTextField)
        takeInputParam(&self.q, qTextField)
        takeInputParam(&self.x, xTextField)
        takeInputParam(&self.k, kTextField)

        guard !inputChecker.isEmptyArr(inputArr) else {
            inputChecker.dialogError(question: "File", text: "File is Empty / Not Choised")
            return
        }

        guard self.p != nil, self.q != nil, self.x != nil, self.k != nil else {
            inputChecker.dialogError(question: "Data", text: "Only Numbers!")
            return
        }

        guard self.p!.isPrime(), self.q!.isPrime() else {
            inputChecker.dialogError(question: "Data", text: "P / Q is not Prime")
            return
        }

        guard (self.p!-1) % self.q! == 0 else {
            inputChecker.dialogError(question: "Data", text: "(p-1) % q != 0)")
            return
        }

        guard self.k! > 0, self.k! < self.q!, self.x! > 0, self.x! < self.q! else {
            inputChecker.dialogError(question: "Data", text: "K / X is not in (0, q)")
            return
        }

        let cipher = Cipher(self.q!, self.p!, self.k!, self.x!, inputArr)

        guard cipher.getR() != 0 || cipher.getS() != 0 else {
            inputChecker.dialogError(question: "Data", text: "Change plz your K (r == 0 / s == 0)")
            return
        }

        rTextField.stringValue = String(cipher.getR())
        sTextField.stringValue = String(cipher.getS())
        yTextField.stringValue = String(cipher.getY())

        hashTextField.stringValue = String(cipher.getHash())
    }
    @IBAction func checkAction(_ sender: Any) {
        takeInputParam(&self.r, rTextField)
        takeInputParam(&self.s, sTextField)
        takeInputParam(&self.y, yTextField)

        let decipher = Decipher(self.q!, self.p!, self.s!, self.r!, self.y!, inputArr)

        if decipher.getResult() {
            resultColorIdentifier.color = .green
            inputChecker.dialogError(question: "v == r", text: "\(decipher.getV()) == \(decipher.r)")
        } else {
            resultColorIdentifier.color = .red
            inputChecker.dialogError(question: "v != r", text: "\(decipher.getV()) != \(decipher.r)")
        }
    }
    //end interface actions

    //methods
    func takeInputParam(_ param: inout Int?,_ inputTextField: NSTextField) {
        let tmpLine = inputTextField.stringValue
        inputChecker.workLine = tmpLine
        param = (inputChecker.result()) ? Int(tmpLine) : nil
    }
    //end methods
}
