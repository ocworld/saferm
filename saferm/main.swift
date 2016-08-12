//
//  main.swift
//  saferm
//
//  Created by OhKeunhyun on 2016. 8. 9..
//  Copyright © 2016년 Keunhyun Oh. All rights reserved.
//

import Foundation
import Darwin

func main() {
    guard let info = parseArgs() else {
        assert(parseArgs() != nil)
        printUsage()
        exit(1)
    }
    
    guard let urls = selectedUrls(opts: info.opts, dirs: info.dirs, files: info.files) else {
        assert(selectedUrls(opts: info.opts, dirs: info.dirs, files: info.files) != nil)
        printUsage()
        exit(1)
    }
    
    let forced = info.opts.contains("f")
    moveToTrash(urls: urls, withForceOption: forced)
}

DispatchQueue.main.async(execute: main)
RunLoop.main.run()
