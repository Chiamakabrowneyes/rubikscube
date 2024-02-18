//
//  CubePieces.swift
//  RubiksCube
//
//  Created by chiamakabrowneyes on 2/17/24.
//

import UIKit
import SceneKit

enum CubePieceType {
    case center, edge, corner
}

struct CubePieceColor {
    var front: UIColor?
    var back: UIColor?
    var left: UIColor?
    var right: UIColor?
    var top: UIColor?
    var bottom: UIColor?
    
    // Initialize with default colors for simplicity; adjust as needed
    init(front: UIColor? = nil, back: UIColor? = nil, left: UIColor? = nil, right: UIColor? = nil, top: UIColor? = nil, bottom: UIColor? = nil) {
        self.front = front
        self.back = back
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
}

struct CubePiece {
    let id: String 
    let type: CubePieceType
    var colors: CubePieceColor
    var position: SCNVector3
    var orientation: SCNQuaternion
}

