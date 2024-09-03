//
//  HTTPClient.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
