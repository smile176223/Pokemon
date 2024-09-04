//
//  Pokemon.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation

public struct Pokemon: Hashable {
    public let name: String
    public let height: Double
    public let weight: Double
    public let id: Int
    public let type: String
    public let spritesImage: String
    
    public init(name: String, height: Double, weight: Double, id: Int, type: String, spritesImage: String) {
        self.name = name
        self.height = height
        self.weight = weight
        self.id = id
        self.type = type
        self.spritesImage = spritesImage
    }
}
