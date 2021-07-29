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
        setupRestingAnimation()
        restLion()
        scene?.addChild(lion)
        
    }
    
    func setupRestingAnimation(){
        lion.removeAllActions()
        let lionRestingAtlas = SKTextureAtlas(named: "lionResting")
        var restFrames: [SKTexture] = []
        let numImages = lionRestingAtlas.textureNames.count
        for i in 1...numImages {
            let lionTextureName = "lionResting\(i)"
            restFrames.append(lionRestingAtlas.textureNamed(lionTextureName))
        }
        lionRestingFrames = restFrames
        firstFrameTexture = lionRestingFrames[0]
        let setRestTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        lion.run(setRestTexture)
        lion.position = CGPoint(x: frame.midX, y: frame.midY - 10)
    }
    
    func restLion(){
        setupRestingAnimation()
        print("Resting...")
        lion.run(SKAction.repeatForever(SKAction.animate(with: lionRestingFrames, timePerFrame: 0.3, resize: false, restore: false)), withKey: "restingLion")
    }
    func waveLion(){
        print("Hello!")
        lion.removeAllActions()
        let lionWavingAtlas = SKTextureAtlas(named: "lionWaving")
        var waveFrames: [SKTexture] = []
        let numImages = lionWavingAtlas.textureNames.count
        for i in 1...numImages {
            let lionTextureName = "lionWaving\(i)"
            waveFrames.append(lionWavingAtlas.textureNamed(lionTextureName))
        }
        // Reverse the animation loop
        for i in stride(from: numImages, to: 1, by: -1) {
            let lionTextureName = "lionWaving\(i)"
            waveFrames.append(lionWavingAtlas.textureNamed(lionTextureName))
        }
        lionWavingFrames = waveFrames
        firstFrameTexture = lionWavingFrames[0]
        let setWaveTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        lion.run(setWaveTexture)
        lion.run(SKAction.repeat(SKAction.animate(with: lionWavingFrames, timePerFrame: 0.3, resize: false, restore: true), count: 1), completion: {
            self.restLion()
        })
        

    }
    
    func didTap(atPosition: CGPoint) {
        print("label at \(labelNode.position)")
        print("sprite at \(testNode.position)")
        let hitNodes = self.nodes(at: atPosition)
        if hitNodes.contains(lion) {
            waveLion()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}


