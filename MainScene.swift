//
//  MainScene.swift
//  C5_MySpriteKit
//
//  Created by mac12 on 2022/3/16.
//

import UIKit
import SpriteKit

class MainScene: SKScene, SKPhysicsContactDelegate {
    var spaceShip: SKSpriteNode?
    var score: Int?
    var isLose: Bool = false
    override func didMove(to view: SKView) {
        print("Main Scene")
        score = 0
        createScene()
        let Panrentcognizer = UIPanGestureRecognizer(target: self, action: #selector(handpan))
        view.addGestureRecognizer(Panrentcognizer)
        physicsWorld.contactDelegate = self
    }
    
    
    func createScene() {
        let mainbgd = SKSpriteNode(imageNamed: "mainbgd")
        mainbgd.size.width = self.size.width
        mainbgd.size.height = self.size.height
        mainbgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mainbgd.zPosition = -1
        
        spaceShip = newSpaceShip()
        spaceShip!.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 150)
        
        self.addChild(mainbgd)
        self.addChild(spaceShip!)
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(newRock), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(newCoin), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(newBullet), userInfo: nil, repeats: true)
    }
    
    func newLight() -> SKShapeNode {
        let light = SKShapeNode()
        light.path = CGPath(rect: CGRect(x: -2, y: -4, width: 4, height: 8), transform: nil)
        light.strokeColor = SKColor.white
        light.fillColor = SKColor.yellow
        
        let blink =  SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.25),
            SKAction.fadeIn(withDuration: 0.25)])
        let blinkForever = SKAction.repeatForever(blink)
        light.run(blinkForever)
        return light
    }
    
    func newSpaceShip() -> SKSpriteNode {
        let ship = SKSpriteNode(imageNamed: "spaceship")
        ship.size = CGSize(width: 75, height: 75)
        ship.name = "ships"
        
        let leftlight = newLight()
        leftlight.position = CGPoint(x: -20, y: 6)
        ship.addChild(leftlight)
        
        let rightlight = newLight()
        rightlight.position = CGPoint(x: 20, y: 6)
        ship.addChild(rightlight)
        
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.size.width / 2)
        ship.physicsBody?.usesPreciseCollisionDetection = true
        ship.physicsBody?.isDynamic = false
        
        ship.physicsBody?.categoryBitMask = 0x1 << 1
        ship.physicsBody?.contactTestBitMask = 0x1 << 2
        return ship
    }
    
    @objc func newRock() {
        let rock = SKSpriteNode(imageNamed: "rock")
        rock.size = CGSize(width: 40, height: 40)
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        rock.position = CGPoint(x: x, y: h)
        rock.name = "rocks"
        rock.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        rock.physicsBody?.usesPreciseCollisionDetection = true
        rock.run(remove)
        self.addChild(rock)
        
    }
    
    @objc func newCoin() {
        let coin = SKSpriteNode(imageNamed: "coin")
        coin.size = CGSize(width: 30, height: 30)
        let remove = SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.removeFromParent()])
        let w = self.size.width
        let h = self.size.height
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        coin.position = CGPoint(x: x, y: h)
        coin.name = "coins"
        coin.physicsBody = SKPhysicsBody(circleOfRadius: 4)
        coin.physicsBody?.usesPreciseCollisionDetection = true
        coin.run(remove)
        self.addChild(coin)
    }
    @objc func newBullet() {
        let _width = 7
        let _height = 20
        let bullet = SKShapeNode()
        bullet.name = "bullets"
        bullet.position = CGPoint(x: spaceShip?.position.x ?? 0, y: (spaceShip?.position.y)! + 40)
        bullet.path = CGPath(rect: CGRect(x: 0, y: 0, width: _width, height: _height), transform: nil)
        bullet.strokeColor = SKColor.yellow
        bullet.fillColor = SKColor.red
        let moveAndRemove = SKAction.sequence([SKAction.moveBy(x: 0, y: 1000, duration: 1.5), SKAction.removeFromParent()])
        bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: _width, height: _height))
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        //bullet.physicsBody?.isDynamic = false
        bullet.physicsBody?.affectedByGravity = false
        bullet.run(moveAndRemove)
        bullet.physicsBody?.categoryBitMask = 0x1 << 1
        bullet.physicsBody?.contactTestBitMask = 0x1 << 2
        self.addChild(bullet)
    }
    
    @objc func newExplosion(point: CGPoint) {
        let explosion = SKShapeNode()
        explosion.name = "explosions"
        explosion.position = point
        //explosion.path = CGPath(
    }
    @objc func handpan(recognizer: UIPanGestureRecognizer) {
        let viewLocation = recognizer.location(in: view)
        let sceneLocation = convertPoint(fromView: viewLocation)
        let moveAction = SKAction.moveTo(x: sceneLocation.x, duration: 0.1)
        self.childNode(withName: "ships")!.run(moveAction)
        
    }
    
    func lose() {
        isLose = true
        let alertController = UIAlertController(title: "You lose!", message: "Score: \(score!)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Go to menu", style: .default, handler: { _ in
            let helloScene = HelloScene(size: self.size)
            let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
            self.view?.presentScene(helloScene, transition: doors)
        })
        alertController.addAction(okAction)
        view?.window?.rootViewController?.present(alertController, animated: true)
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if isLose {
            return
        }
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        if contact.bodyA.node?.name == "ships" || contact.bodyA.node?.name == "bullets"{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "ships" && secondBody.node?.name == "rocks" {
            print("You lose!")
            lose()
        }
        else if firstBody.node?.name == "ships" && secondBody.node?.name == "coins" {
            print("Get point 100\n")
            score! += 100
            secondBody.node?.removeFromParent()
        }
        else if firstBody.node?.name == "bullets" && (secondBody.node?.name == "rocks" || secondBody.node?.name == "coins" ){
            print("COLLISIONS!")
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        print("didEnd")
    }
}
