//
//  HelloScene.swift
//  C5_MySpriteKit
//
//  Created by mac12 on 2022/3/16.
//

import UIKit
import SpriteKit
import GameplayKit

class HelloScene: SKScene {
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func createScene() {
        let bgd = SKSpriteNode(imageNamed: "hellobgd")
        bgd.size.width = self.size.width
        bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgd.zPosition = -1
        
        let hellolabel = SKLabelNode(text: "Space 🚀 Adventure")
        hellolabel.name = "label"
        hellolabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        hellolabel.fontName = "Avenir-Oblique"
        hellolabel.fontSize = 28
        
        self.addChild(bgd)
        self.addChild(hellolabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let labelNode = self.childNode(withName: "label")
        let moveup = SKAction.moveBy(x: 0, y: 200, duration: 1)
        let zoomin = SKAction.scale(to:3.0, duration: 1)
        let pause = SKAction.wait(forDuration: 0.5)
        let zoomout = SKAction.scale(to: 0.5, duration: 0.25)
        let fadeaway = SKAction.fadeOut(withDuration: 0.25)
        let remove = SKAction.removeFromParent()
        let moveSequence = SKAction.sequence([moveup, zoomin, pause, zoomout, fadeaway, remove])
        labelNode?.run(moveSequence, completion: {
            let mainScene = MainScene(size: self.size)
            let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
            self.view?.presentScene(mainScene, transition: doors)
        })
    }
}
