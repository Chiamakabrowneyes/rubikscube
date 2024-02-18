//
//  CubeModel.swift
//  RubiksCube
//
//  Created by chiamakabrowneyes on 2/17/24.
//

import Foundation
import UIKit
import SceneKit

var pieceNodes: [String: SCNNode] = [:]

class CubeModel: ObservableObject {
    @Published var pieces: [CubePiece] = []
     // Maps cube piece positions to their corresponding SCNNode
        
    
    init() {
        self.pieces = initializeCube()
    }

    private func initializeCube() -> [CubePiece] {
        var pieces: [CubePiece] = []

        // Define default colors for each side for demonstration
        let colorScheme = [
            UIColor.red,    // Front
            UIColor.green,  // Back
            UIColor.blue,   // Left
            UIColor.orange, // Right
            UIColor.white,  // Top
            UIColor.yellow  // Bottom
        ]
        
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    let position = SCNVector3(x, y, z)
                    let id = "x\(x)y\(y)z\(z)"
                    var colors = CubePieceColor()
                    // Determine colors based on position; this is simplified
                    if x == 1 { colors.right = colorScheme[3] }
                    if x == -1 { colors.left = colorScheme[2] }
                    if y == 1 { colors.top = colorScheme[4] }
                    if y == -1 { colors.bottom = colorScheme[5] }
                    if z == 1 { colors.front = colorScheme[0] }
                    if z == -1 { colors.back = colorScheme[1] }
                    
                    let type: CubePieceType = (x != 0 && y != 0 && z != 0) ? .corner : ((x != 0 && y != 0) || (x != 0 && z != 0) || (y != 0 && z != 0)) ? .edge : .center
                    let piece = CubePiece(id: id, type: type, colors: colors, position: position, orientation: SCNQuaternion(0, 0, 0, 1))
                    pieces.append(piece)
                }
            }
        }

        return pieces
    }
}


extension CubeModel {
    
    enum RotationDirection {
        case up, down, left, right
    }
    
    func rotateLayer(direction: RotationDirection) {
        switch direction {
            case .up:
                rotateTopLayerClockwise()
            case .down:
                rotateBottomLayerClockwise()
            case .left:
                rotateLeftLayerClockwise()
            case .right:
                rotateRightLayerClockwise()
            }
        
        // Update the SceneKit scene accordingly
        updateScene()
    }
    func rotateLeftLayerClockwise() {
            // Temporary storage for the new positions of the pieces in the left layer
            var newPositions = [SCNVector3]()

            // Collect new positions for each piece in the left layer
            for piece in pieces where piece.position.x == -1 {
                let oldPosition = piece.position
                // For a clockwise rotation, the y position becomes the negative z position, and the z position becomes the y position
                let newPosition = SCNVector3(oldPosition.x, -oldPosition.z, oldPosition.y)
                newPositions.append(newPosition)
            }

            // Update the positions of the pieces in the left layer
            for (index, piece) in pieces.enumerated().filter({ $0.element.position.x == -1 }) {
                pieces[index].position = newPositions[index]
            }
        }
    
    private func rotateRightLayerClockwise() {
        var newPositions = [SCNVector3]()

        for piece in pieces where piece.position.x == 1 {
            let oldPosition = piece.position
            let newPosition = SCNVector3(oldPosition.x, -oldPosition.z, oldPosition.y)
            newPositions.append(newPosition)
        }

        for (index, piece) in pieces.enumerated().filter({ $0.element.position.x == 1 }) {
            pieces[index].position = newPositions[index]
        }
    }

    
    private func rotateBottomLayerClockwise() {
        var newPositions = [SCNVector3]()

        for piece in pieces where piece.position.y == -1 {
            let oldPosition = piece.position
            let newPosition = SCNVector3(oldPosition.z, oldPosition.y, -oldPosition.x)
            newPositions.append(newPosition)
        }

        for (index, piece) in pieces.enumerated().filter({ $0.element.position.y == -1 }) {
            pieces[index].position = newPositions[index]
        }
    }

    
    private func rotateTopLayerClockwise() {
        var newPositions = [SCNVector3]()

        for piece in pieces where piece.position.y == 1 {
            let oldPosition = piece.position
            let newPosition = SCNVector3(-oldPosition.z, oldPosition.y, oldPosition.x)
            newPositions.append(newPosition)
        }

        for (index, piece) in pieces.enumerated().filter({ $0.element.position.y == 1 }) {
            pieces[index].position = newPositions[index]
        }
    }

    func updateScene() {
        for piece in pieces {
            if let node = pieceNodes[piece.id] {
                // Update the node's position and orientation
                node.position = piece.position
                node.orientation = piece.orientation
            }
        }
    }

    
    func mapPiecesToNodes(scene: SCNScene) {
        for piece in pieces {
            // Assuming each piece's SCNNode is named with the piece's unique identifier
            if let node = scene.rootNode.childNode(withName: piece.id, recursively: true) {
                pieceNodes[piece.id] = node
            }
        }
    }
}
