//
//  MenuScene.swift
//  BubFusion
//
//  Created by Артем Калинкин on 02.05.2021.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {

    let playButton = SKSpriteNode(imageNamed: "play_icon.png")
    let title = SKSpriteNode(imageNamed: "title.png")
    let background = SKSpriteNode(imageNamed: "background.png")
    let ds = SKSpriteNode(imageNamed: "ds.png")
    let settingsButton = SKSpriteNode(imageNamed: "options_icon")
    let exitButton = SKSpriteNode(imageNamed: "exit_icon")
    
    override init(size: CGSize) {
        super.init(size: size)
        self.size = size
    }
    
    override func didMove(to view: SKView) {
        MenuSettins()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func MenuSettins() {
        // BACKGROUND
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = UIScreen.main.bounds.size
        background.size.width = UIScreen.main.bounds.size.width
        self.addChild(background)
        
        // PLAY BUTTTON
        playButton.size = CGSize(width: size.width / 3.7 , height: size.width / 3.7)
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2 + size.height / 5.8)
        playButton.zPosition = 1
        self.addChild(playButton)
        
        // SETTING BUTTON
        settingsButton.size = CGSize(width: size.width / 3.7  , height: size.width / 3.7)
        settingsButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        settingsButton.zPosition = 1
        self.addChild(settingsButton)
        
        // EXIT BUTTON
        exitButton.size = CGSize(width: size.width / 3.7 , height: size.width / 3.7)
        exitButton.position = CGPoint(x: size.width / 2, y: size.height / 3)
        exitButton.zPosition = 1
        self.addChild(exitButton)
        
        // BUTTONS ANIMATIONS
        let scaleIn = SKAction.scale(to: 0.94, duration: 1.2)
        let scaleOut = SKAction.scale(to: 1, duration: 1.2)
        playButton.run(.repeatForever(.sequence([scaleIn, scaleOut])))
        settingsButton.run(.repeatForever(.sequence([scaleIn, scaleOut])))
        exitButton.run(.repeatForever(.sequence([scaleIn, scaleOut])))
        
        // TITLE
        title.position = CGPoint(x: size.width / 2, y: size.height - size.height / 5.5)
        title.size = CGSize(width: size.width / 1.5, height: 50)
        title.zPosition = 1
        self.addChild(title)
        
        // DESCRIPTION
        ds.position = CGPoint(x: size.width / 2, y: size.height / 8)
        ds.size = CGSize(width: size.width / 2, height: 25)
        ds.zPosition = 1
        self.addChild(ds)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = (touch!.location(in: self))
        
        if playButton.contains(touchLocation) {
          playButton.removeAllActions()
          let scale = SKAction.scale(to: 0.85, duration: 0.2)
          let scaleOut = SKAction.scale(to: 1, duration: 0.2)
          let openChooseLevelScene = SKAction.run {
            let scene = SKScene(fileNamed: "GameScene")
            scene?.scaleMode = .aspectFit
            let reveal = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(scene!, transition: reveal)
          }
          let sequence = SKAction.sequence([scale, scaleOut, openChooseLevelScene])
          playButton.run(sequence)
        }
      
        if exitButton.contains(touchLocation) {
          exitButton.removeAllActions()
          let scale = SKAction.scale(to: 0.9, duration: 0)
          let scaleOut = SKAction.scale(to: 1, duration: 0.2)
          let exitApp = SKAction.run { exit(0) }
          let sequence = SKAction.sequence([scale, scaleOut, exitApp])
          exitButton.run(sequence)
        }
        
        if settingsButton.contains(touchLocation) {
          settingsButton.removeAllActions()
          let scale = SKAction.scale(to: 0.9, duration: 0)
          let scaleOut = SKAction.scale(to: 1, duration: 0.2)
          let openSettingsAction = SKAction.run {
            //          let reveal = SKTransition.fade(withDuration: 0.5)
            //          let levelScene = SettingsScene(size: (view?.bounds.size)!)
            //          self.view?.presentScene(levelScene, transition: reveal)
          }
          let sequence = SKAction.sequence([scale, scaleOut, openSettingsAction])
          settingsButton.run(sequence)
       }
    }
}
