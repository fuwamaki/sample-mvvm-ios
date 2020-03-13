//
//  OriginalResult.swift
//  SampleMVVM
//
//  Created by yusaku maki on 2019/09/23.
//  Copyright © 2019 yusaku maki. All rights reserved.
//

import Foundation

// Alamofire.ResultとResult.ResultのConflict解消用
typealias OriginalResult<T, Error: Error> = Result<T, Error>
