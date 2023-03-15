//
//  ScenGameOver.swift
//  StarWar
//
//  Created by  Сергей on 26.10.2022.
//

import Foundation
import SpriteKit

class scenGameOver: SKScene {
    let restartLable = SKLabelNode(fontNamed: "The Bold Font") //сделали глобальным
    
    var exitLable :  SKLabelNode {
        let lable = SKLabelNode()
        lable.fontName = "The Bold Font"
        lable.text = "Выход"
        lable.fontSize = 85
        lable.fontColor = .white
        lable.position = CGPoint(x: self.size.width / 2, y: self.size.height*0.10)
        lable.zPosition = 1
        return lable
    }
    
    // неправильно сделали надо сдесь обявлять все обьекты
    override func didMove(to view: SKView) {
        
        
        //фоновое изображение
        let background = SKSpriteNode(imageNamed: "background")
        
        background.size = self.size
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        //наслоение
        background.zPosition = 0
        self.addChild(background)
        
        let scoreLable = SKLabelNode(fontNamed: "The Bold Font")
        scoreLable.text = "Счёт: \(gameScore)"
        scoreLable.fontSize = 85
        scoreLable.fontColor = .white
        scoreLable.position = CGPoint(x: self.size.width / 2, y: self.size.height*0.90)
        scoreLable.zPosition = 1
        self.addChild(scoreLable)
        
        let recordLable = SKLabelNode(fontNamed: "The Bold Font")
        
        recordLable.fontSize = 85
        recordLable.fontColor = .white
        recordLable.position = CGPoint(x: self.size.width / 2, y: self.size.height*0.80)
        recordLable.zPosition = 1
        self.addChild(recordLable)
        
        //сохраняем данные пользователя
        let userDefaults = UserDefaults.standard
        var highScore = userDefaults.integer(forKey: "highScoreSave")//тип сохраняемый
        if gameScore > highScore  {
            highScore = gameScore
            userDefaults.set( highScore, forKey: "highScoreSave")
        }
        recordLable.text = "Рекорд: \(highScore)"
        
        
        
        let gameLable = SKLabelNode(fontNamed: "Pusab")
        gameLable.text = "Game Over"
        gameLable.fontSize = 100
        gameLable.fontColor = .white
        gameLable.position = CGPoint(x: self.size.width / 2, y: self.size.height*0.50)
        gameLable.zPosition = 1
        self.addChild(gameLable)
        
        
        
        //let restartLable = SKLabelNode(fontNamed: "The Bold Font") //сделали глобальным
        restartLable.text = "Повторить"
        restartLable.fontSize = 85
        restartLable.fontColor = .white
        restartLable.position = CGPoint(x: self.size.width / 2, y: self.size.height*0.30)
        restartLable.zPosition = 1
        self.addChild(restartLable)
        self.addChild(exitLable)
    }
    // в этот раз перход сделали немного по другому
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self)
            if restartLable.contains(point) {  // если место куда нажали равняется restartLable
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
            if exitLable.contains(point) {
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }
        }
    }
}
