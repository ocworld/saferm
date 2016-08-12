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
var dirs = Set<URL>()
var files = Set<URL>()
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
        
        let url = URL(fileURLWithPath: arg)
        if isDir.boolValue {
            dirs.insert(url)
        } else {
            files.insert(url)
        }
    }
}

var paths:Set<URL> = Set<URL>()
if opts.contains("r") {
    paths = paths.union(dirs)
}

paths = paths.union(files)
let sortedPaths = paths.sorted() {$0.path > $1.path}
let isForced = opts.contains("f")

if isForced {
    NSWorkspace.shared().recycle(sortedPaths)
    { (urlInfo, error) in
        print(urlInfo)
        if let err = error {
            print(err)
        }
    }
}
else {
    for path in sortedPaths {
        var isYes = false
        
        keyboardinputloop: while(true)
        {
            print("\(path.path) (y/n): ", terminator: "")
            
            if let input = readLine() {
                switch(input)
                {
                case "y", "Y", "yes":
                    isYes = true
                    break keyboardinputloop
                    
                case "n", "N", "no":
                    isYes = false
                    break keyboardinputloop
                    
                default:
                    print("Please input yes or no")
                    continue keyboardinputloop
                }
            }
        }
        
        if isYes {
            NSWorkspace.shared().recycle([path], completionHandler: { (urlInfo, error) in if let err = error { print(err) } })
        }
    }
}

