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
    var boneNode = SKSpriteNode()
    var soapNode = SKSpriteNode()
    var ballNode = SKSpriteNode()
    let objectsAtlas = SKTextureAtlas(named: "objects")
    
    override func sceneDidLoad() {
        setupRestingAnimation()
        restLion()
        scene?.addChild(lion)
        setupBone()
        setupSoap()
        setupBall()
    }
    
    func setupBone(){
        let boneFrame = objectsAtlas.textureNamed("bone")
        let setBone = SKAction.setTexture(boneFrame, resize: false)
        boneNode.run(setBone)
        boneNode.position = CGPoint(x: frame.midX - 50 , y: frame.midY - 80)
        scene?.addChild(boneNode)
    }
    
    func setupSoap(){
        let soapFrame = objectsAtlas.textureNamed("soap")
        let setSoap = SKAction.setTexture(soapFrame, resize: false)
        soapNode.run(setSoap)
        soapNode.position = CGPoint(x: frame.midX , y: frame.midY - 80)
        soapNode.setScale(0.5)
        scene?.addChild(soapNode)
    }
    
    func setupBall(){
        let ballFrame = objectsAtlas.textureNamed("ball")
        let setBall = SKAction.setTexture(ballFrame, resize: false)
        ballNode.run(setBall)
        ballNode.position = CGPoint(x: frame.midX + 50, y: frame.midY - 80)
        scene?.addChild(ballNode)
    }
    
    func setupRestingAnimation(){
        lion.removeAllActions()
        let lionRestingAtlas = SKTextureAtlas(named: "lionWaving")
        var restFrames: [SKTexture] = []
        for i in 1...3 {
            let lionTextureName = "lionWaving\(i)"
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
        lion.run(SKAction.repeatForever(SKAction.animate(with: lionRestingFrames, timePerFrame: 0.3, resize: false, restore: false)), withKey: "restingLion")
        
    }
    func waveLion(){
        lion.removeAllActions()
        let lionWavingAtlas = SKTextureAtlas(named: "lionWaving")
        var waveFrames: [SKTexture] = []
        let numImages = lionWavingAtlas.textureNames.count
        for i in 4...numImages {
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
        lion.run(SKAction.repeat(SKAction.animate(with: lionWavingFrames, timePerFrame: 0.2, resize: false, restore: false), count: 1), completion: {
            self.restLion()
        })

    }
    
    func didTap(atPosition: CGPoint) {
        let hitNodes = self.nodes(at: atPosition)
        if hitNodes.contains(lion) {
            waveLion()
        } else if hitNodes.contains(boneNode) {
            print("Gave bone")
        } else if hitNodes.contains(soapNode) {
            print("Washing!")
        } else if hitNodes.contains(ballNode) {
            print("Let's play")
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}


