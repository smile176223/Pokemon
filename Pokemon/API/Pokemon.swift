//
//  Pokemon.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation

public struct Pokemon: Hashable {
    public let name: String
    public let height: Int
    public let weight: Int
    public let id: Int
    public let type: String
    public let spritesImage: String
    
    public init(name: String, height: Int, weight: Int, id: Int, type: String, spritesImage: String) {
        self.name = name
        self.height = height
        self.weight = weight
        self.id = id
        self.type = type
        self.spritesImage = spritesImage
    }
}
