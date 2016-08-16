//
//  func.swift
//  saferm
//
//  Created by OhKeunhyun on 2016. 8. 12..
//  Copyright © 2016년 Keunhyun Oh. All rights reserved.
//

import Foundation
import AppKit

func printUsage() {
    print("usage: saferm [-f | -i] [-dPRrvW] file ...")
    print("unlink file")
}

func parseArgs() -> (opts: Set<Character>, dirs: Set<URL>, files: Set<URL>)?
{
    let supportedOptions : Set<Character> = ["f","i","d","P","R","r","v","W"]
    
    if CommandLine.argc <= 1 {
        assert(CommandLine.argc > 1)
        return nil
    }
    
    let args = CommandLine.arguments.dropFirst()
    
    var opts = Set<Character>()
    var dirs = Set<URL>()
    var files = Set<URL>()
    for arg in args {
        guard let first = arg.characters.first else {
            assert(arg.characters.first != nil)
            return nil
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
            if !FileManager.default.fileExists(atPath: standardedPath, isDirectory: &isDir) {
                continue
            }
            
            let url = URL(fileURLWithPath: arg)
            if isDir.boolValue {
                dirs.insert(url)
            } else {
                files.insert(url)
            }
        }
    }
    
    return (opts, dirs, files)
}

func selectedUrls(opts: Set<Character>, dirs: Set<URL>, files: Set<URL>) -> [URL]? {
    var urls:Set<URL> = Set<URL>(files)
    
    if opts.contains("r") {
        urls = urls.union(dirs)
    }
    else {
        guard dirs.isEmpty else {
            assert(dirs.isEmpty)
            return nil
        }
    }
    
    return urls.sorted() {$0.path < $1.path}
}

func moveToTrash(urls: [URL], withForceOption forced: Bool) {
    if forced {
        NSWorkspace.shared().recycle(urls) {
            (_, error) in

            if let err = error {
                print(err)
            }
            
            exit(0)
        }
    }
    else
    {
        if !urls.isEmpty {
            guard let url = urls.first else {
                exit(0)
            }
            
            let newUrls = Array(urls.dropFirst())
            if confirm(url) {
                NSWorkspace.shared().recycle([url]) {
                    (_, error) in

                    if let err = error {
                        print(err)
                    }
                    
                    if newUrls.isEmpty {
                        exit(0)
                    } else {
                        moveToTrash(urls: newUrls, withForceOption: forced)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    moveToTrash(urls: newUrls, withForceOption: forced)
                }
            }
        }
    }
}

func confirm(_ url: URL) -> Bool {
    var confirmed = false
    keyboardinputloop: while(true)
    {
        print("\(url.path) (y/n): ", terminator: "")
        
        if let input = readLine() {
            switch(input)
            {
            case "y", "Y", "yes":
                confirmed = true
                break keyboardinputloop
                
            case "n", "N", "no":
                confirmed = false
                break keyboardinputloop
                
            default:
                print("Please input yes or no")
                continue keyboardinputloop
            }
        }
    }
    
    return confirmed
}
