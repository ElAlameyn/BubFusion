//
//  GameScene.swift
//  BubFusionApp
//
//  Created by Артем Калинкин on 02.08.2021.
//

import SpriteKit

class GameScene: SKScene {
    private lazy var game = BubFusionGame()
    private var startPlayerTouchLocation: CGPoint?
    private var gridCoordinates = [[CGPoint]]()
    
    override func didMove(to view: SKView) {
        
        // Загрузка уровня
        if game.isDevMode {
            addDevLabel()
            addClearLabel()
            addWallLabel()
            addSaveLabel()
        }
        
        drawGameGrid()
        addChild(game)
    }
    
    // MARK: TOUCHES
    internal override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let startTouchLocation = touches.first else { return }
      
        startPlayerTouchLocation = startTouchLocation.location(in: self)

        let tappedNodes = nodes(at: startPlayerTouchLocation!)
        
      // Check if labels tapped
        for node in tappedNodes {
            devLabels(for: node)
        }
      
      // In devMode
        if game.isDevMode {
            devModeSettings()
        } else {
      // In gameMode
            for node in tappedNodes {
                gameModeSettings(for: node)
            }
        }
        
    }
    
    internal override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchMoved = touches.first else { return }
        guard let startTouchLocation = startPlayerTouchLocation else { return }
        guard !game.isDevMode else { return }
        
        let endPlayerTouchLocation = touchMoved.location(in: self)
        
        if endPlayerTouchLocation.x - startTouchLocation.x > 30 {
            game.swipeObject(to: .right)
        } else
        
        if startTouchLocation.x - endPlayerTouchLocation.x > 30 {
            game.swipeObject(to: .left)
        } else
        
        if endPlayerTouchLocation.y - startTouchLocation.y > 30 {
            game.swipeObject(to: .up)
        } else 
        
        if startTouchLocation.y - endPlayerTouchLocation.y > 30 {
            game.swipeObject(to: .down)
        }
    }
    
  // If game object tapped
    func gameModeSettings(for node: SKNode) {
        switch node.name {
        case "fullCircle", "emptyCircle":
            guard !game.isDevMode else { return }
            guard let movingNode = node as? SKSpriteNode else { return }
            game.currentMovingObject = movingNode
            return
        default:
            return
        }
    }

  // Add object ot scene ( in devMode)
    func devModeSettings() {
        for coordMas in gridCoordinates {
            for coord in coordMas {
                let areaX = startPlayerTouchLocation!.x - 25...startPlayerTouchLocation!.x + 25
                let areaY = startPlayerTouchLocation!.y - 25...startPlayerTouchLocation!.y + 25
                if areaX ~= coord.x && areaY ~= coord.y {
                    for object in game.gameplayObjects {
                      // add walls & spikes
                      if game.isWallAppears {
                        if object.position == coord {
                          if object.name == "wall" {
                            object.name = "spike"
                            object.texture = SKTexture(imageNamed: "spike")
                            return
                          } else if object.name == "spike" {
                            object.name = "wall"
                            object.texture = SKTexture(imageNamed: "wall")
                            }
                        }
                      } else {
                      // add circles
                        if object.position == coord {
                            if object.name == "fullCircle" {
                                object.name = "emptyCircle"
                                object.texture = SKTexture(imageNamed: "emptyCircle")
                                return
                            } else if object.name == "emptyCircle" {
                                object.name = "fullCircle"
                                object.texture = SKTexture(imageNamed: "fullCircle")
                                return
                            }
                            return
                        }
                      }
                    }
                    
                    if game.isWallAppears && game.isDevMode {
                        game.addOrRemoveHandler(at: coord, with: "wall")
                    } else {
                        game.addOrRemoveHandler(at: coord, with: "fullCircle")
                    }
                    return

                }
            }
        }
    }
    
  // Change devMode's labels if tapped
    func devLabels(for node: SKNode) {
        switch node.name {
        case "devLabel":
            guard let label = node as? SKLabelNode else { return }
            if game.isDevMode {
                label.text = "DevMode: false"
                game.isDevMode.toggle()
            } else {
                label.text = "DevMode: true"
                game.isDevMode.toggle()
            }
        case "clearLabel":
            game.gameplayObjects.forEach({$0.removeFromParent()})
            game.gameplayObjects.removeAll()
        case "wallLabel":
            guard let label = node as? SKLabelNode else { return }
            if game.isWallAppears {
                label.text = "WallMode: false"
                game.isWallAppears.toggle()
            } else {
                label.text = "WallMode: true"
                game.isWallAppears.toggle()
            }
        case "saveLabel":
          print("saved")
          //
          // сохранение текущего уровня
          //
        default:
            return
        }
    }
  
    func addSaveLabel() {
      let label = SKLabelNode(fontNamed: "Chalkduster")
      label.text = "Save"
      label.position = CGPoint(x: 300, y: 700)
      label.fontColor = #colorLiteral(red: 0.8291199803, green: 0.8193305135, blue: 0.728226006, alpha: 1)
      label.fontSize = 18
      label.horizontalAlignmentMode = .left
      label.name = "saveLabel"
      addChild(label)
    }
  // Label to go in devMode
    func addDevLabel() {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "DevMode: true"
        label.position = CGPoint(x: 30, y: 660)
        label.fontColor = #colorLiteral(red: 0.8291199803, green: 0.8193305135, blue: 0.728226006, alpha: 1)
        label.fontSize = 18
        label.horizontalAlignmentMode = .left
        label.name = "devLabel"
        addChild(label)
    }
    
  // Label to clear objects from scene
    func addClearLabel() {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Clear"
        label.position = CGPoint(x: 300, y: 660)
        label.fontColor = #colorLiteral(red: 0.8291199803, green: 0.8193305135, blue: 0.728226006, alpha: 1)
        label.fontSize = 18
        label.horizontalAlignmentMode = .left
        label.name = "clearLabel"
        addChild(label)
    }
    
    // Label to add walls
    func addWallLabel() {
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Add wall: false"
        label.position = CGPoint(x: 30, y: 700)
        label.fontColor = #colorLiteral(red: 0.8291199803, green: 0.8193305135, blue: 0.728226006, alpha: 1)
        label.fontSize = 16
        label.horizontalAlignmentMode = .left
        label.name = "wallLabel"
        addChild(label)
    }
    

    // MARK: GAME GRID
    private func drawGameGrid() {
        let numberRows = 10 // number of rows
        let numberColumns = 6  // number of columns
        let size = 60 // size of item
        
      // Add vertical lines
        for i in 0...numberRows {
            let linePath = CGMutablePath()
            linePath.move(to: CGPoint(x:size / 2 , y:  i * size + size / 2))
            linePath.addLine(to: CGPoint(x: numberColumns * size + size / 2, y: i * size + size / 2))
            
            let lineX = SKShapeNode()
            lineX.path = linePath
            lineX.strokeColor = SKColor(cgColor: .init(red: 204, green: 202, blue: 182, alpha: 0.4))
            addChild(lineX)
        }
          
      // Add gorizontal lines
        for i in 0...numberColumns {
            let linePath = CGMutablePath()
            linePath.move(to: CGPoint(x: i * size + size / 2, y: size / 2))
            linePath.addLine(to: CGPoint(x: i * size + size / 2, y: numberRows * size + size / 2))

            let lineY = SKShapeNode()
            lineY.path = linePath
            lineY.strokeColor = SKColor(cgColor: .init(red: 204, green: 202, blue: 182, alpha: 0.4))
            addChild(lineY)
        }
        
        var deltaX = 60
        var deltaY = 660
        var group = [CGPoint]()

        for _ in 0..<numberRows {
            deltaY -= 60
            deltaX = 60
            gridCoordinates.append(group)
            group.removeAll()
            for _ in 0..<numberColumns {
                group.append(CGPoint(x: deltaX, y: deltaY))
                deltaX += 60
            }
        }
        gridCoordinates.append(group)
    }
}

