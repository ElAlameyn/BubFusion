//
//  BubFusionGame.swift
//  BubFusionApp
//
//  Created by Артем Калинкин on 03.08.2021.
//

import SpriteKit

class BubFusionGame: SKNode {
    var isDevMode = true
    var isWallAppears = false
    var gameplayObjects = [SKSpriteNode]()
    var currentMovingObject: SKSpriteNode!
    

    func swipeObject(to direction: Direction) {
        guard let movingObject = currentMovingObject else { return }
        let pps:Double = 50
      
        // Вынести расчёт duration в отдельную функцию
        
        switch direction {
            // MARK: SWIPE RIGHT INSTRUCTION
        case .right:
            if let object = gameplayObjects.filter({$0.position.y == movingObject.position.y}).filter({$0.position.x > movingObject.position.x}).sorted(by: {$0.position.x < $1.position.x}).first {
                guard !movingObject.hasActions() else { return }
                let duration = TimeInterval(sqrt(sqrt(Float(pow(object.position.x - movingObject.position.x, 2) + pow(object.position.y - movingObject.position.y, 2))))) / pps
              if movingObject.name != object.name  && object.name != "spike" {
                    movingObject.run(SKAction.move(to: CGPoint(x: object.position.x - 60, y: object.position.y), duration: duration))
                } else {
                    fuse(object: movingObject, with: object, with: duration)
                }
            } else {
                guard !movingObject.hasActions() else { return }
                let moving = SKAction.move(to: CGPoint(x: 500, y: movingObject.position.y), duration: 1)
                let sequence = SKAction.sequence([moving, deleteObject(movingObject)])
                movingObject.run(sequence)
            }
            break
            // MARK: SWIPE LEFT INSTRUCTION
        case .left:
            if let object = gameplayObjects.filter({$0.position.y == movingObject.position.y}).filter({$0.position.x < movingObject.position.x}).sorted(by: {$0.position.x > $1.position.x}).first {
                guard !movingObject.hasActions() else { return }
                let duration = TimeInterval(sqrt(sqrt(Float(pow(object.position.x - movingObject.position.x, 2) + pow(object.position.y - movingObject.position.y, 2))))) / pps
              if movingObject.name != object.name && object.name != "spike"{
                    movingObject.run(SKAction.move(to: CGPoint(x: object.position.x + 60, y: object.position.y), duration: duration))
                } else {
                    fuse(object: movingObject, with: object, with: duration)
                }
            } else {
                guard !movingObject.hasActions() else { return }
                let moving = SKAction.move(to: CGPoint(x: -100, y: movingObject.position.y), duration: 1)
                let sequence = SKAction.sequence([moving, deleteObject(movingObject)])
                movingObject.run(sequence)
            }
            break
            // MARK: SWIPE UP INSTRUCTION
        case .up:
            if let object = gameplayObjects.filter({$0.position.x == movingObject.position.x}).filter({$0.position.y > movingObject.position.y}).sorted(by: {$0.position.y < $1.position.y}).first {
                guard !movingObject.hasActions() else { return }
                let duration = TimeInterval(sqrt(sqrt(Float(pow(object.position.x - movingObject.position.x, 2) + pow(object.position.y - movingObject.position.y, 2))))) / pps
              if movingObject.name != object.name && object.name != "spike" {
                    movingObject.run(SKAction.move(to: CGPoint(x: object.position.x, y: object.position.y - 60), duration: duration))
                } else {
                    fuse(object: movingObject, with: object, with: duration)
                }
            } else {
                guard !movingObject.hasActions() else { return }
                let moving = SKAction.move(to: CGPoint(x: movingObject.position.x, y: 1000), duration: 1)
                let sequence = SKAction.sequence([moving, deleteObject(movingObject)])
                movingObject.run(sequence)
            }
            break
            // MARK: SWIPE DOWN INSTRUCTION
        case .down:
            if let object = gameplayObjects.filter({$0.position.x == movingObject.position.x}).filter({$0.position.y < movingObject.position.y}).sorted(by: {$0.position.y > $1.position.y}).first {
                guard !movingObject.hasActions() else { return }
                let duration = TimeInterval(sqrt(sqrt(Float(pow(object.position.x - movingObject.position.x, 2) + pow(object.position.y - movingObject.position.y, 2))))) / pps
              if movingObject.name != object.name  && object.name != "spike" {
                    movingObject.run(SKAction.move(to: CGPoint(x: object.position.x, y: object.position.y + 60), duration: duration))
                } else {
                    fuse(object: movingObject, with: object, with: duration)
                }
            } else {
                guard !movingObject.hasActions() else { return }
                let moving = SKAction.move(to: CGPoint(x: movingObject.position.x, y: -100), duration: 1)
                let sequence = SKAction.sequence([moving, deleteObject(movingObject)])
                movingObject.run(sequence)
            }
            break
        }
    }
    // Object's fusion
    func fuse(object movingObject: SKSpriteNode, with object: SKSpriteNode, with duration: TimeInterval) {
        let runToObject = SKAction.move(to: object.position, duration: duration)
        let sequence = SKAction.sequence([runToObject, deleteObject(movingObject), changeTexture(of: object)])
      if object.name == "spike" {
        let gameOverScene = SKAction.run {
          // тут должен быть вызов сцены пройгрыша
          print("GAME OVER")
        }
        movingObject.run(SKAction.sequence([sequence, gameOverScene]))
      } else {
        movingObject.run(sequence)
    }
    }

    func changeTexture(of object: SKSpriteNode) -> SKAction {
        let action = SKAction.run {
            if object.name == "fullCircle" {
                object.texture = SKTexture(imageNamed: "emptyCircle")
                object.name = "emptyCircle"
            } else {
                object.texture = SKTexture(imageNamed: "fullCircle")
                object.name = "fullCircle"
            }
        }
        return action
    }
    
  // Delete gameplay object
    func deleteObject(_ movingObject: SKSpriteNode ) -> SKAction {
        let action = SKAction.run { [self] in
            movingObject.removeFromParent()
            let index = gameplayObjects.firstIndex(of: movingObject)
            gameplayObjects.remove(at: index!)
        }
        return action
    }
    
  // Add object to scene
    func addOrRemoveHandler(at position: CGPoint, with object: String) {
        guard isDevMode else { return }
        switch object {
        case "fullCircle":
          addObject(name: object, at: position)
        case "wall":
          addObject(name: object, at: position)
        default:
            return
        }
    }
  
  func addObject(name: String, at position: CGPoint) {
    let object: SKSpriteNode
    object = SKSpriteNode(imageNamed: name)
    object.name = name
    
    object.size = CGSize(width: 46, height: 46)
    object.position = position
    object.zPosition = 1
    addChild(object)
    gameplayObjects.append(object)
  }
}
