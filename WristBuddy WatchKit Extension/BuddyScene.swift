//
//  BuddyScene.swift
//  WristBuddy WatchKit Extension
//
//  Created by Luigi Greco on 23/07/21.
//

import WatchKit
import SpriteKit

class BuddyScene: SKScene {
    var labelNode = SKLabelNode()
    var testNode = SKSpriteNode()
    var lion = SKSpriteNode()
    var lionRestingFrames: [SKTexture] = []
    var lionWavingFrames: [SKTexture] = []
    var firstFrameTexture = SKTexture()
    override func sceneDidLoad() {
//        labelNode = childNode(withName: "spriteLabel")! as! SKLabelNode
//        testNode = SKSpriteNode(imageNamed: "catSprite")
//        testNode.setScale(0.2)
//        testNode.position = CGPoint(x: 0, y: 0)
        setupLion()
        
//        scene?.addChild(testNode)
//        labelNode.text = "tap the pussy"
//        labelNode.fontSize = 30
//        labelNode.position = CGPoint(x: 0, y: -70)
//        print(labelNode)
    }
    
    func SetupAnimations(){
        
    }
    
    func setupLion(){
        let lionRestingAtlas = SKTextureAtlas(named: "lionResting")
        var restFrames: [SKTexture] = []
        let numImages = lionRestingAtlas.textureNames.count
        for i in 1...numImages {
            let lionTextureName = "lionResting\(i)"
            restFrames.append(lionRestingAtlas.textureNamed(lionTextureName))
        }
        lionRestingFrames = restFrames
        firstFrameTexture = lionRestingFrames[0]
        lion = SKSpriteNode(texture: firstFrameTexture)
        lion.position = CGPoint(x: frame.midX, y: frame.midY - 20)
        scene?.addChild(lion)
        lion.run(SKAction.repeatForever(SKAction.animate(with: lionRestingFrames, timePerFrame: 0.3, resize: false, restore: false)), withKey: "restingLion")
    }
    
    func waveLion(){
        let lionWavingAtlas = SKTextureAtlas(named: "lionWaving")
        var waveFrames: [SKTexture] = []
        let numImages = lionWavingAtlas.textureNames.count
        for i in 1...numImages {
            let lionTextureName = "lionWaving\(i)"
            waveFrames.append(lionWavingAtlas.textureNamed(lionTextureName))
        }
        lionWavingFrames = waveFrames
        firstFrameTexture = lionWavingFrames[0]
        lion = SKSpriteNode(texture: firstFrameTexture)
        let setWaveTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        lion.run(setWaveTexture)
        lion.position = CGPoint(x: frame.midX, y: frame.midY - 20)
        lion.run(SKAction.repeat(SKAction.animate(with: lionWavingFrames, timePerFrame: 0.3, resize: false, restore: true), count: 2))
        //setupLion()
    }
    
    func didTap(atPosition: CGPoint) {
        print("label at \(labelNode.position)")
        print("sprite at \(testNode.position)")
        let hitNodes = self.nodes(at: atPosition)
        if hitNodes.contains(lion) {
            waveLion()
            print("Tapped on buddy")
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}


