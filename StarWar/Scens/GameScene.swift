//
//  GameScene.swift
//  StarWar
//
//  Created by  Сергей on 25.10.2022.
//

import SpriteKit
import GameplayKit
import AVFoundation
//создаем счет в игре делаем его глобальным
var gameScore = 0

enum statGame {
    case perGame //состояние перед игрой
    case inGame // состояние в игре
    case outGame //состояние после игры
}


//все удаляем
class GameScene: SKScene, SKPhysicsContactDelegate {
    //начало игры нажатие
    let startGameLabel = SKLabelNode(fontNamed: "Pusab")
    
    //состояние игры
    var currentGame = statGame.perGame
    
    //создаем список жизний
    var life = 3
    //выбираем вид кораблика игрока
    var selectPlayer = SKSpriteNode()
    let lifeLable = SKLabelNode(fontNamed: "Pusab")
    //сщздаем уровень
    var lavelNumber = 0
    
    let scoreLable = SKLabelNode(fontNamed: "Pusab")
    
    //теперь нам необходимо создать взаимосвязь между телами тоесть пуля должна знать что ей не надо взаимодействвать с кораблем игрока а только с врагом и а враг тоже должен знать и для этого деаем структуу
    struct PhysicsCategories {
        //4 категории, что то из двоичной системы
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1//1
        static let Bullet  : UInt32 = 0b10//2
        static let Enemy  : UInt32 = 0b100//4
    }
    
    
    //SKPhysicsContactDelegate - это контак физических тел то есть настройка вокруг наших обхектов и взаимодействие между ними
    
    
    //теперь делаем врагов и все такое
    //это что то врое генератора случайных чисел
    func random () -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random (min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    //определяем игровую область
    let gameArea: CGRect
    // с инициалтзатором аккуратнее он сам напросился и именно в таком формате
    override init(size: CGSize) {
        // максимальное соотнощение сторон просто запомни
        let maxAspectRatio: CGFloat = 16.0/9.0
        //ширина
        let playableWidth = size.height / maxAspectRatio
        //вычисляем промежуток по краям
        let margin = (size.width - playableWidth) / 2
        //сама арена
        gameArea = CGRect(x: margin, y: 0, width: playableWidth , height: size.height)
        //высота
        super.init(size: size)
        print("Ширина экрана: \(size.width)")
        print("Ширина арены: \(playableWidth)")
        print("Центр поля по Х: \(margin)")
        print("Ширина корабля: \(player.size.width)")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //сюда убрали чтоб был доступ
    var player = SKSpriteNode()
    
    
    //звуковой эффект
    let bulletSound = SKAction.playSoundFileNamed("laser-blast.mp3", waitForCompletion: false)
    let soundEnemy = SKAction.playSoundFileNamed("laser-gun.mp3", waitForCompletion: false)
    
    let musicGame = SKAction.playSoundFileNamed("music.mp3", waitForCompletion: false)
    let soundExplosion = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
    
    //основная функция
    override func didMove(to view: SKView) {
        gameScore = 0 // обнуляем результат
        //подключаем делегат взаимодействия физических тел
        self.physicsWorld.contactDelegate = self
        creatBackground()
        // creatPlayer()
    }
    
    
    //настройка экрана
    private func creatBackground() {
        
        //запускаем в цикле так как нам надо три корабля чтобы выбрать
        for i in 1...3 {
            selectPlayer = SKSpriteNode(imageNamed: "playerShip\(i)")
            //print("playerShip\(i)")
            //маштаб картинки 0 - 2
            selectPlayer.setScale(1)
            selectPlayer.position = CGPoint(x: gameArea.width / CGFloat(i), y: 0 - self.size.height)
            //print("Ширина gameArea \(gameArea.width)")
            selectPlayer.zPosition = 2
            selectPlayer.name = "playerShip\(i)"
            self.addChild(selectPlayer)
            let moveShipPlayer = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
            let startGameSequence = SKAction.sequence([moveShipPlayer])
            selectPlayer.run(startGameSequence)
        }
        //запускаем в цикле так как нам надо два фона чтобы двиалось
        for i in 0...1 {
            
            //фоновое изображение
            let background = SKSpriteNode(imageNamed: "background")
            //на весь экран
            background.size = self.size
            background.name = "Background" // чтобы можно было обращаться к нему в любом месте кода
            //изменяем точку привязки фона она по умолчанию в середине фона мы ее меняем на низ (свои координаты 0.5/0, 0.5/1, 0.5/0.5, 0/1,1/1, 0/0, 1/0)
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            
            background.position = CGPoint(x: self.size.width / 2, y: self.size.height * CGFloat(i)) // добавили  CGFloat(i) в первый раз умножится на 0, а во второй на 1
            //                                      y: self.size.height / 2) было так раньше
            //наслоение
            background.zPosition = 0
            self.addChild(background)
            
        }
        
        //Жизни
        
        lifeLable.text = "Жизнь: 3"
        lifeLable.fontSize = 70
        lifeLable.fontColor = SKColor.white
        // lifeLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        lifeLable.zPosition = 1
        lifeLable.position = CGPoint(x: self.size.width / 3, y: self.size.height + lifeLable.frame.height)
        self.addChild(lifeLable)
        
        //Счет
        scoreLable.text = "Счет: 0"
        scoreLable.fontSize = 70
        scoreLable.fontColor = SKColor.white
        // scoreLable.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLable.zPosition = 1
        
        scoreLable.position = CGPoint(x:self.size.width / 2 + scoreLable.frame.width  , y: self.size.height  + scoreLable.frame.height)
        self.addChild(scoreLable)
        
        
        //движение для объектов по У
        let moveOnToScreenAction = SKAction.moveTo(y: self.size.height*0.9, duration: 0.5)
        lifeLable.run(moveOnToScreenAction)
        scoreLable.run(moveOnToScreenAction)
        
        
        startGameLabel.text = "Начать"
        startGameLabel.fontSize = 150
        startGameLabel.fontColor = SKColor.white
        startGameLabel.zPosition = 1
        startGameLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        startGameLabel.alpha = 0
        self.addChild(startGameLabel)
        
        let fageInAction = SKAction.fadeIn(withDuration: 0.3)
        startGameLabel.run(fageInAction)
    }
    
    
    
    ///обновления экрана update
    var lastUpdateTime : TimeInterval = 0
    var daltaFrameTime : TimeInterval = 0
    // на сколько точек в секунду будет перемещвтся экран
    var amountToMovePerSecond : CGFloat = 160.0
    //функция обновления кадра максимум 60 раз в секунду
    override func update(_ currentTime: TimeInterval) {
        //выяснения разницы между кадрами
        if  lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        else{
            daltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        //вычисляем количество перермещений за промежуток времени примерно 600.0 * 0.2 или 0.5
        let amountToMoveBackround = amountToMovePerSecond * CGFloat(daltaFrameTime)
        self.enumerateChildNodes(withName: "Background") {
            background, stop in
            
            //тут немного добавили условия что если игра запущена то меняется фон иначе все остается на своих местах
            if self.currentGame == statGame.inGame {
                background.position.y -= amountToMoveBackround //после того как экран переместится в низ его переместится в верх
            }
            
            //это значит что фон полностью покинул нижнюю часть экрана
            if background.position.y < -self.size.height {
                //верни его обратно
                background.position.y += self.size.height * 2 //добавляем две высоты экрана чтобы его поднять в самый вверх
                print(background.position.y)
                print("экран поднят на вверх")
            }
        }
    }
    
    
    
    ///игрок
    private func creatPlayer(){
        //маштаб картинки 0 - 2
        // player.setScale(1)
        player.size = CGSize(width: self.size.height * 0.08, height: self.size.height * 0.08)
        player.position = CGPoint(x: self.size.width / 2, y: 0 - self.size.height)
        player.zPosition = 2
        
        //это уже добаление функций делегата
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        //отключаем действие гравитации на корабль
        player.physicsBody!.affectedByGravity = false
        //назначаем категорию это структура типо модель
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        //нескем не сталкиваться и ни на кого не влиять
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        //сдесь мы  говорим с кем мы хотим вступить в контакт и сообщить нам об этом
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
    }
    //func score
    private func addScore() {
        gameScore += 1
        scoreLable.text = "Счёт: \(gameScore)"
        
        if gameScore == 20 || gameScore == 45 || gameScore == 60 {
            life += 1
            lifeLable.text = "Жизнь: \(life)"
            print(life)
            startnewLEWEL()
        }
    }
    //func Life
    private func remLife() {
        life -= 1
        lifeLable.text = "Жизнь: \(life)"
        //немного анимации
        let scaleUp = SKAction.scale(by: 2.5, duration: 0.3)
        let scaleDown = SKAction.scale(by: 0.5, duration: 0.3)
        let scaleSeqwoe = SKAction.sequence([scaleUp, scaleDown])
        lifeLable.run(scaleSeqwoe)
        if life == 0 {
            runGameOver()
        }
    }
    
    
    // функция пули
    private func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet" // справочное имя для того чтобы можно было его отыскать в стоке запущенных сценарийев
        bullet.setScale(1)
        //позиция пули
        bullet.position = player.position
        bullet.zPosition = 1
        // настройка гравитации взаимодействия
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        //отнесение к категории
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        //нискем не сталкиваться и ни на кого не влиять
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        //сдесь мы  говорим с кем мы хотим вступить в контакт и сообщить нам об этом
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        
        self.addChild(bullet)
        
        
        //дейстриве пули
        //если грубо то пуля буедт двигатся за границу экрана + свой размер
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        //удаляем пулю когда она улетит щза экран
        let deleteBullet = SKAction.removeFromParent()
        //последовательность маркеров или действий
        //let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
        //теперь добавили звуковой эффект
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
        
    }
    //начать новый уровень
    private func startnewLEWEL() {
        //номер уровня
        lavelNumber += 1
        //сначала останавливаем весь процес а потом запускаем уже с новым уровнем для этого вводим ключ по которому все этто определяется withKey: "spawn"
        if self.action(forKey: "spawn") != nil {
            self.removeAction(forKey: "spawn")
        }
        //счет
        var levelDuration = NSTimeIntervalSince1970
        
        switch lavelNumber {
        case 1 : levelDuration = 1.8
        case 2 : levelDuration = 1.2
        case 3 : levelDuration = 1
        case 4 : levelDuration = 0.8
        default:
            levelDuration = 0.5
            print("Уровень не найден!")
        }
        
        //появление врага
        let spawn = SKAction.run(spawnEnemy)
        //промежуток запуска врага
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        //последовательность действий
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        //повторение действия
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawn")
    }
    
    //MARK: - функция начала контакта функция делегата
    func didBegin(_ contact: SKPhysicsContact) {
        //contact - сюда передаются все контакты между телами тело один тело два
        //проблема кто из них кто, поэтомy телам назначили битовые значения что бы их можно было отсортировать
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        //само расположение по значениям играет роль так как враг всегда имет большуу знаение а игрок самое Mаленькое
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        // теперь разбираемся кто с кем столкнулся
        //если игрок ударил врага
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            //если игрок ударил врага
            
            
            //взрыв игрока
            //так раньше было потмо дети попросили просто уменьшить жизнь
           // if body1.node != nil { // защита
           //     spawnExplosion(spawnPosition: body1.node!.position)
           // }
            //взрыв врага
            if body2.node != nil { // защита
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            // node? - на случай когда две пули одновременно попадут во врага и тогда программа попытается удалить два объекта что выховит ошибку поэтомуне обязательно ставиться
           // body1.node?.removeFromParent() // читается как возми узел тела  и удали его
            body2.node?.removeFromParent()// читается как возми узел тела  и удали его
            //так раньше было потмо дети попросили просто уменьшить жизнь
            //runGameOver()
            //уменьшение жизни
            remLife()
        }
        //если пуля ударила врага
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y ?? 10) < self.size.height{
            // body2.node?.position < self.size.height - означает что враг должен быть на экране
            //если пуля ударила врага
            addScore()
            //взрыв врага
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()// читается как возми узел тела  и удали его
            body2.node?.removeFromParent()// читается как возми узел тела  и удали его
        }
    }
    
    //создание  врага
    private func spawnEnemy() {
        
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX )
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX )
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        //моя идея чтобы каждый раз разные враги появлялись
        var enemy = SKSpriteNode()
        let enemyNum =  Int.random(in: 0...4)
        switch enemyNum {
        case 0:
            enemy = SKSpriteNode(imageNamed: "enemyShip")
        case 1:
            enemy = SKSpriteNode(imageNamed: "enemyShip1")
        case 2:
            enemy = SKSpriteNode(imageNamed: "enemyShip2")
        case 3:
            enemy = SKSpriteNode(imageNamed: "enemyShip3")
        case 4:
            enemy = SKSpriteNode(imageNamed: "enemyShip4")
        default:
            enemy = SKSpriteNode(imageNamed: "enemyShip")
        }
        
        enemy.size = CGSize(width: self.size.height * 0.08, height: self.size.height * 0.08)
        enemy.name = "Enemy" // справочное имя для того чтобы можно было его отыскать в стоке запущенных сценарийев
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 1
        // настройка гравитации взаимодействия
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        //физическая категория структура типо модель
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        //mыф не хотим чтобы физическое тело врага с кемто сталкивалось
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        //сдесь мы  говорим с кем мы хотим вступить в контакт
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        //enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Bullet
        
        self.addChild(enemy)
        //дейстриве врага
        //если грубо то пуля буедт двигатся за границу экрана + свой размер
        let moveEnemy = SKAction.move(to: endPoint, duration: 2.0)
        // когда законсил полет удаляем
        let deleteEnemy = SKAction.removeFromParent()
        //тут вставляем если полет закончился значит мы проиграли счет жизни уменбшается запускаем функцию уменьшения жизни
        //let lostLife = SKAction.run(remLife)
        //последовательность маркеров или действий
        let bulletSequence = SKAction.sequence([soundEnemy, moveEnemy, deleteEnemy]) //lostLife
        if currentGame == statGame.inGame {
            enemy.run(bulletSequence)
        }
        //интересно, это определение координат поворота картинки в нужную сторону
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        // это всево лишь аркттангенс из высшей математики
        let amountToRotate = atan2(dy, dx)
        // print("Угол поворота:\(amountToRotate)")
        enemy.zRotation = amountToRotate
    }
    
    //взрыв врага
    private func spawnExplosion(spawnPosition : CGPoint) {
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(1) // маленькое изображение
        self.addChild(explosion)
        //анимация взрыва
        
        let scaleIn = SKAction.scale(by: 1, duration: 0.1) // маштаб изображения
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)//затухание
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([soundExplosion, scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
    }
    
    
    //останавливаем игру stopGame
    private func runGameOver() {
        currentGame = statGame.outGame
        
        GameViewController.play.stop()
        self.enumerateChildNodes(withName: "Bullet") { bullet, stop in
            bullet.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy") { enemy, stop in
            enemy.removeAllActions()
        }
        
        //загрузка нового контроллера или сцены
        let changScene = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let sequenc = SKAction.sequence([ waitToChangeScene, changScene])
        self.run(sequenc)
    }
    
    
    //настройка новой сцены для завершения или нового контроллера
    private func changeScene (){
        
        let moveToScene = scenGameOver(size: self.size)
        moveToScene.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(moveToScene, transition: myTransition)
        
    }
    
    ///startGame
    private func startGame() {
        currentGame = statGame.inGame
        //delete lable
        for i in 1...3 {
            self.enumerateChildNodes(withName: "playerShip\(i)") { playerShip, stop in
                playerShip.removeFromParent()
            }
        }
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        startGameLabel.run(deleteSequence)
        
        let moveShipPlayer = SKAction.moveTo(y: self.size.height*0.2, duration: 0.5)
        let startLevel = SKAction.run(startnewLEWEL)
        let startGameSequence = SKAction.sequence([moveShipPlayer,startLevel])
        player.run(startGameSequence)
    }
    
    //функция прикосновения на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGame == statGame.perGame {
            for touch in touches {
                let pointOfTouch = touch.location(in: self) // определяем куда нажали
                let nodeITapped = atPoint(pointOfTouch)//место куда нажали превращаем в объект и далее делаем что хотим сравниваем или назначаем действие
               //сдесь просто выбор корабля через иф каряво получается
                switch nodeITapped.name {
                case "playerShip1":
                    player = SKSpriteNode(imageNamed: "playerShip1")
                case "playerShip2":
                    player = SKSpriteNode(imageNamed: "playerShip2")
                case "playerShip3":
                    player = SKSpriteNode(imageNamed: "playerShip3")
                default:
                    player = SKSpriteNode(imageNamed: "playerShip3")
                    print("Ошибка при выборе корабля")
                
                }
//                if nodeITapped.name == "Background" {
//                     player = SKSpriteNode(imageNamed: "playerShip1")
//                }else{
//                    player = SKSpriteNode(imageNamed: nodeITapped.name!)
//                }
            }
            creatPlayer()
            startGame()
        }
        
        if currentGame == statGame.inGame {
            fireBullet()
        }
    }
    //функция перемещения по экрану
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //определение касаний
        for touch: AnyObject in touches {
            //начальная позиция прикосновения
            let pointOfTouch = touch.location(in: self)
            // перемещение пальцем на новую позицию
            let previsionPointOfTouth = touch.previousLocation(in: self)
            
            //разница между начальной точкой и конечной
            let amountDraggedX = pointOfTouch.x - previsionPointOfTouth.x
            //  let amountDraggedY = pointOfTouch.y - previsionPointOfTouth.y
            //перемещыем игрока
            if currentGame == statGame.inGame {
                player.position.x += amountDraggedX
                //player.position.y += amountDraggedY
            }
            //ограничение по Х игровой зоны
            if player.position.x > gameArea.maxX -  player.size.width { // максимальная точка с права
                player.position.x = gameArea.maxX -  player.size.width// возвращает игрока на край области с права
            }
            //то же самое и про левый экран
            if player.position.x < gameArea.minX + player.size.width{ // максимальная точка с права
                player.position.x = gameArea.minX + player.size.width // возвращает игрока на край области с права
                
            }
            //ограничение по У игровой зоны
        }
    }
}
