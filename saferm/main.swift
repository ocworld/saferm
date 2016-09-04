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
    
    
    var forced = false
    //-i          Request confirmation before attempting to remove each file, regardless of the file's permissions, or whether or not the standard input device is a terminal.  The -i option overrides any previous -f options.
    if info.opts.contains("i") {
        forced = false
    }
        
    //     -f          Attempt to remove the files without prompting for confirmation, regardless of the file's permissions.  If the file does not exist, do not display a diagnostic message or modify the exit status to reflect an error.  The -f option overrides any previous -i options.
        
    else if info.opts.contains("f") {
        forced = true
    }
    
    moveToTrash(urls: urls, withForceOption: forced)
}

DispatchQueue.main.async(execute: main)
RunLoop.main.run()
