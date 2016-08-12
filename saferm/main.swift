//
//  main.swift
//  saferm
//
//  Created by OhKeunhyun on 2016. 8. 9..
//  Copyright © 2016년 Keunhyun Oh. All rights reserved.
//

import Foundation
import Darwin
import AppKit

func input() -> String? {
    let keyboard = FileHandle.standardInput
    let inputData = keyboard.availableData
    let input = String(data: inputData, encoding: String.Encoding.utf8)
    return input
}

func printUsage() {
    print("usage: saferm [-f | -i] [-dPRrvW] file ...")
    print("unlink file")
}

let supportedOptions : Array<Character> = ["f","i","d","P","R","r","v","W"]

let argc = Process.arguments.count
if argc <= 1 {
    printUsage()
    exit(1)
}

let args = Process.arguments.dropFirst()

var opts = Set<Character>()
var dirs = Set<String>()
var files = Set<String>()
for arg in args {
    guard let first = arg.characters.first else {
        break
    }
    
    //options
    if first == "-" {
        let dataOpts = arg.characters.dropFirst()
        for opt in dataOpts {
            if supportedOptions.contains(opt) {
                opts.insert(opt)
            }
        }
    }
    else
    {
        let tmpPath = NSString(string: arg)
        let standardedPath = tmpPath.standardizingPath
        var isDir : ObjCBool = false
        guard FileManager.default.fileExists(atPath: standardedPath, isDirectory: &isDir) else {
            break
        }
        
        if isDir.boolValue {
            dirs.insert(arg)
        } else {
            files.insert(arg)
        }
    }
}

var paths:Set<String> = Set<String>()
if opts.contains("r") {
    paths = paths.union(dirs)
}

paths = paths.union(files)
let sortedPaths = paths.sorted(by: >)

let isForced = opts.contains("f")
for path in paths {
//    if !isForced {
//        print("\(path) (y/n)")
//        while(true)
//        {
//            if let input = input() {
//                input
//            }
//        }
//        
//    }
}
print(sortedPaths)


//let trashUrls = filemanager.urls(for: .trashDirectory, in: .userDomainMask)
//guard !trashUrls.isEmpty else {
//    printUsage()
//    exit(1)
//}
//

