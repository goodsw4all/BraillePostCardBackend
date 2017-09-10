//
//  BrailleTranslater.swift
//  BraillePostCard
//
//  Created by Myoungwoo Jang on 09/09/2017.
//
//

import Cocoa
import CoreFoundation

enum Target {
    case gcode
    case stl
    case all
}

public class BrailleTranslater {
    let makePath = "/usr/bin/make"
    var message = ""
    
    init() {
        //shell(launchPath: "/bin/pwd")
        // Create a FileManager instance
        
        let fileManager = FileManager()
        
        // Get current directory path
        
        fileManager.changeCurrentDirectoryPath("./convert")
        shell(launchPath: makePath, arguments: ["clean"])
        let path = fileManager.currentDirectoryPath
        let list = try? fileManager.contentsOfDirectory(atPath: path)
        print(path)
        print(list ?? "")
        
    }
    
    convenience init(postCard: PostCard) {
        self.init()
        
        var loopcount = 1
        message = "PLAINTEXT=["
        print("\nChecking Message : \(message)")
        
        for element in postCard.message {
            print(element)
            message.append("\"\(element)\"")
            
            if postCard.message.count > loopcount {
                loopcount += 1
                message.append(", ")
            }
        }
        message.append("]")
        
        print("Checking Message : \(message)\n\n")
    }
    
    
    func convert(target: String) {
        //let (output, status) = shell(launchPath: makePath, arguments: [target, "PLAINTEXT=[\"I\", \"Love\", \"U\"]"])
        
        let (output, status) = shell(launchPath: makePath, arguments: [target, message])
        print(output! + " \(status)");
    }

    func shell(launchPath: String, arguments: [String] = []) -> (String? , Int32) {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        var output = ""
        output = String(data: data, encoding: .utf8)!
        
        task.waitUntilExit()
        return (output, task.terminationStatus)
    }
}
