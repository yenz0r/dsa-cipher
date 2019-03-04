//
//  DataProvider.swift
//  DSA-result
//
//  Created by Egor Pii on 11/20/18.
//  Copyright © 2018 yenz0redd. All rights reserved.
//

import Cocoa

class DataProvider {
    var fileURL: URL?

    func dialogPanel() -> URL? {
        let dialog = NSOpenPanel()

        dialog.title                   = "Choose a .txt file"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = false
        dialog.allowsMultipleSelection = false

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            fileURL = dialog.url!
        } else {
            return nil
        }

        return fileURL
    }

    func getFileSize() -> Int {
        do {
            let resources = try fileURL!.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize!
            return fileSize
        } catch {
            print("Error: \(error)")
            return 0
        }
    }


    func loadData() -> [UInt8] {
        fileURL = dialogPanel()
        
        var resultArr: [UInt8] = []
        let inputStream = InputStream(fileAtPath: fileURL!.path)!

        resultArr = [UInt8](repeating: 0, count: Int(getFileSize()))
        inputStream.open()
        inputStream.read(&resultArr, maxLength: Int(getFileSize()))
        inputStream.close()

        return resultArr
    }

    func getString() -> String {
        var result = ""

        if (fileURL != nil) {
            do {
                result = try String(contentsOf: fileURL!, encoding: .utf8)
            }
            catch {
                print("Error")
            }
        }
        return result
    }

    func saveString(_ inputLine: String){
        fileURL = dialogPanel()

        if fileURL != nil {
            do {
                try inputLine.write(to: fileURL!, atomically: true, encoding: .utf8)
            }
            catch {
                print("Error")
            }
        }
    }

}
