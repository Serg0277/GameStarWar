//
//  GameViewController.swift
//  StarWar
//
//  Created by  Сергей on 25.10.2022.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController, AVAudioPlayerDelegate{
//сдесь можно сделать проигрфвание музыки так как этот контроллер работает всегда
    //для фона проигрыватель
    static var play = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        creatBackgroundMusic()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
          //  if let scene = SKScene(fileNamed: "GameScene") { убираем это
            //универмальный набор для размера
            let scene = MainMenuScene(size: CGSize(width: 1536, height: 2048))//раньше так было GameScene(size: CGSize(width: 1536, height: 2048))
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
           
                // Present the scene
                view.presentScene(scene)
           // } это тоже убираем
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true //сколько кадров в секунду их можно отключить
            view.showsNodeCount = true //сколько показывыет узлов
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //настройка фоновой музыки
    func creatBackgroundMusic() {
        let filePach = Bundle.main.path(forResource: "music", ofType: "mp3")
        let audioNSURL = NSURL(fileURLWithPath: filePach!)
        DispatchQueue.main.async {
            do { GameViewController.play = try AVAudioPlayer(contentsOf: audioNSURL as URL)
                GameViewController.play.volume = 0.5 // устанавливаем уровень звука по умолчанию
                GameViewController.play.numberOfLoops = -1 //это зацикливание делегат тогда не нужен
                GameViewController.play.play()
            }
            catch {
                print("Ошибка воспроизведения")
            }
        }
    }
}
