//
//  MineMenu.swift
//  StarWar
//
//  Created by  Сергей on 01.11.2022.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        createMenu()       
    }
    
    private func createMenu() {
        //фон
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.name = "Background"
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameByLable = SKLabelNode(fontNamed: "Pusab")
        gameByLable.text = "Sancho & Nikitos"
        gameByLable.fontSize = 50
        gameByLable.fontColor = SKColor.white
        // lifeLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        gameByLable.zPosition = 1
        gameByLable.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.8)
        self.addChild(gameByLable)
        
        let gameName1Lable = SKLabelNode(fontNamed: "Pusab")
        gameName1Lable.text = "Star"
        gameName1Lable.fontSize = 200
        gameName1Lable.fontColor = SKColor.white
        gameName1Lable.zPosition = 1
        gameName1Lable.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        self.addChild(gameName1Lable)
        
        let gameName2Lable = SKLabelNode(fontNamed: "Pusab")
        gameName2Lable.text = "Wars"
        gameName2Lable.fontSize = 200
        gameName2Lable.fontColor = SKColor.white
        gameName2Lable.zPosition = 1
        gameName2Lable.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        self.addChild(gameName2Lable)
        
        let startGameLable = SKLabelNode(fontNamed: "Pusab")
        startGameLable.text = "Start Game"
        startGameLable.name = "startGame"
        startGameLable.fontSize = 100
        startGameLable.fontColor = SKColor.white
        startGameLable.zPosition = 1
        startGameLable.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        self.addChild(startGameLable)
        
    }
    
    // в этот раз перход сделали немного по другому
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self) // определяем куда нажали
            let nodeITapped = atPoint(pointOfTouch)//место куда нажали превращаем в объект и далее делаем что хотим сравниваем или назначаем действие
            if nodeITapped.name == "startGame" {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
