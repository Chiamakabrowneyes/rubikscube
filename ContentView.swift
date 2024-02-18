import SwiftUI
import SceneKit

struct ContentView: View {
    
    @ObservedObject var cubeModel: CubeModel = CubeModel()
    
    var body: some View {
        GeometryReader{
            geometry in ScreneKitView(scene: createScene(), size: geometry.size)
                .edgesIgnoringSafeArea(.all)
                .gesture(DragGesture().onEnded { value in
                    handleSwipe(value: value)
                })
            
        }
    }

        func handleSwipe(value: DragGesture.Value) {
            let swipeThreshold: CGFloat = 5.0 // Minimum distance for a swipe to be recognized
            let horizontalSwipeDistance = value.location.x - value.startLocation.x
            let verticalSwipeDistance = value.location.y - value.startLocation.y

            if abs(horizontalSwipeDistance) > swipeThreshold || abs(verticalSwipeDistance) > swipeThreshold {
                if abs(horizontalSwipeDistance) > abs(verticalSwipeDistance) {
                    // Horizontal swipe
                    if horizontalSwipeDistance > 0 {
                        print("Right swipe detected")
                        // Rotate the cube or a layer to the right
                        cubeModel.rotateLayer(direction: .right)
                    } else {
                        print("Left swipe detected")
                        // Rotate the cube or a layer to the left
                        cubeModel.rotateLayer(direction: .left)
                    }
                } else {
                    // Vertical swipe
                    if verticalSwipeDistance > 0 {
                        print("Down swipe detected")
                        // Rotate the cube or a layer downwards
                        cubeModel.rotateLayer(direction: .down)
                    } else {
                        print("Up swipe detected")
                        // Rotate the cube or a layer upwards
                        cubeModel.rotateLayer(direction: .up)
                    }
                }
            }
        }
    
    func createScene() -> SCNScene {
        let scene = SCNScene()
        
        let squareSize: CGFloat = 1.0
        let spacing: CGFloat = 0 // Spacing between the pieces
        let totalSize = squareSize + spacing
        
        // Colors for each face of the cube
        let faceColors = [
            UIColor.red,    // Front
            UIColor.green,  // Back
            UIColor.blue,   // Left
            UIColor.orange, // Right
            UIColor.white,  // Top
            UIColor.yellow  // Bottom
        ]
        
        // Calculate start offset to center the cube in the scene
        let startOffset = -(totalSize * 2) / 2
        
        // Iterate over x, y, z to create a 3x3x3 structure
        for x in 0..<3 {
            for y in 0..<3 {
                for z in 0..<3 {
                    let box = SCNBox(width: squareSize, height: squareSize, length: squareSize, chamferRadius: 0.1)
                    
                    // Create a material for each face of the cube piece
                    var materials = [SCNMaterial]()
                    for color in faceColors {
                        let material = SCNMaterial()
                        material.diffuse.contents = color
                        materials.append(material)
                    }
                    
                    // Assign materials to the box
                    box.materials = materials
                    
                    let node = SCNNode(geometry: box)
                    node.position = SCNVector3(
                        Float(startOffset + CGFloat(x) * totalSize),
                        Float(startOffset + CGFloat(y) * totalSize),
                        Float(startOffset + CGFloat(z) * totalSize)
                    )
                    
                    scene.rootNode.addChildNode(node)
                }
            }
        }
        
        // Configure the camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 10) // Adjust as needed to fit the cube in view
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
    }
}


struct ScreneKitView: UIViewRepresentable {
    let scene: SCNScene
    let size: CGSize
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: CGRect(origin: .zero, size: size), options: nil)
        view.scene = scene
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = true
        view.backgroundColor = UIColor.black
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
}
