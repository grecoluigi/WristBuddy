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
    var dog = SKSpriteNode()
    var dogRestingFrames: [SKTexture] = []
    var dogWavingFrames: [SKTexture] = []
    var dogBathFrames: [SKTexture] = []
    var dogBoneEatingFrames: [SKTexture] = []
    var boneAnimationFrames: [SKTexture] = []
    var ballAnimationFrames: [SKTexture] = []
    var firstFrameTexture = SKTexture()
    var boneNode = SKSpriteNode()
    var soapNode = SKSpriteNode()
    var ballNode = SKSpriteNode()
    var boneAnimNode = SKSpriteNode()
    var ballAnimNode = SKSpriteNode()
    let objectsAtlas = SKTextureAtlas(named: "objects")
    
    override func sceneDidLoad() {
        setupRestingAnimation()
        restDog()
        scene?.addChild(dog)
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
    
    func setupBoneAnim(){
        let boneAnimAtlas = SKTextureAtlas(named: "boneAnim")
        var boneAnimFrames: [SKTexture] = []
        let numImages = boneAnimAtlas.textureNames.count
        for i in 1...numImages {
            let boneAnimTextureName = "boneAnim\(i)"
            boneAnimFrames.append(boneAnimAtlas.textureNamed(boneAnimTextureName))
        }
        boneAnimationFrames = boneAnimFrames
        firstFrameTexture = boneAnimationFrames[0]
        let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        boneAnimNode.run(setAnimTexture)
        boneAnimNode.setScale(1.4)
        boneAnimNode.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        scene?.addChild(boneAnimNode)
        boneAnimNode.run(SKAction.animate(with: boneAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: boneEatingAnim)
    }
    
    func setupBallAnim(){
        let ballAnimAtlas = SKTextureAtlas(named: "ballAnim")
        var ballAnimFrames: [SKTexture] = []
        let numImages = ballAnimAtlas.textureNames.count
        for i in 1...numImages {
            let ballAnimTextureName = "ballAnim\(i)"
            ballAnimFrames.append(ballAnimAtlas.textureNamed(ballAnimTextureName))
        }
        ballAnimationFrames = ballAnimFrames
        firstFrameTexture = ballAnimationFrames[0]
        let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        ballAnimNode.run(setAnimTexture)
        ballAnimNode.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        scene?.addChild(ballAnimNode)
        ballAnimNode.run(SKAction.animate(with: ballAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: ballAnimNode.removeFromParent)
    }
    
    func boneEatingAnim() {
        boneAnimNode.removeFromParent()
        dog.removeAllActions()
        let dogBonEatingAtlas = SKTextureAtlas(named: "boneEating")
        var boneEatingFrames: [SKTexture] = []
        let numImages = dogBonEatingAtlas.textureNames.count
        for i in 1...numImages {
            let dogBoneEatingTextureName = "boneEating\(i)"
            boneEatingFrames.append(dogBonEatingAtlas.textureNamed(dogBoneEatingTextureName))
        }
        dogBoneEatingFrames = boneEatingFrames
        firstFrameTexture = dogBoneEatingFrames[0]
        let setBoneEatingTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setBoneEatingTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: dogBoneEatingFrames, timePerFrame: 0.2, resize: false, restore: false), count: 6), completion: {
            self.restDog()
        })
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
        dog.removeAllActions()
        let lionRestingAtlas = SKTextureAtlas(named: "lionWaving")
        var restFrames: [SKTexture] = []
        for i in 1...3 {
            let lionTextureName = "lionWaving\(i)"
            restFrames.append(lionRestingAtlas.textureNamed(lionTextureName))
        }
        dogRestingFrames = restFrames
        firstFrameTexture = dogRestingFrames[0]
        let setRestTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setRestTexture)
        dog.position = CGPoint(x: frame.midX, y: frame.midY - 10)
    }
    
    func restDog(){
        
        setupRestingAnimation()
        dog.run(SKAction.repeatForever(SKAction.animate(with: dogRestingFrames, timePerFrame: 0.3, resize: false, restore: false)), withKey: "restingLion")
        
    }
    func waveDog(){
        dog.removeAllActions()
        let dogWavingAtlas = SKTextureAtlas(named: "lionWaving")
        var waveFrames: [SKTexture] = []
        let numImages = dogWavingAtlas.textureNames.count
        for i in 4...numImages {
            let dogTextureName = "lionWaving\(i)"
            waveFrames.append(dogWavingAtlas.textureNamed(dogTextureName))
        }
        // Reverse the animation loop
        for i in stride(from: numImages, to: 1, by: -1) {
            let lionTextureName = "lionWaving\(i)"
            waveFrames.append(dogWavingAtlas.textureNamed(lionTextureName))
        }
        dogWavingFrames = waveFrames
        firstFrameTexture = dogWavingFrames[0]
        let setWaveTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setWaveTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: dogWavingFrames, timePerFrame: 0.2, resize: false, restore: false), count: 1), completion: {
            self.restDog()
        })

    }
    
    func bathDog(){
        dog.removeAllActions()
        let dogBathAtlas = SKTextureAtlas(named: "dogBath")
        var bathFrames: [SKTexture] = []
        let numImages = dogBathAtlas.textureNames.count
        for i in 1...numImages {
            let dogTextureName = "dogBath\(i)"
            bathFrames.append(dogBathAtlas.textureNamed(dogTextureName))
        }
        dogBathFrames = bathFrames
        firstFrameTexture = dogBathFrames[0]
        let setBathTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setBathTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: dogBathFrames, timePerFrame: 0.2, resize: false, restore: false), count: 8), completion: {
            self.restDog()
        })

    }
    
    func didTap(atPosition: CGPoint) {
        let hitNodes = self.nodes(at: atPosition)
        if hitNodes.contains(dog) {
            waveDog()
        } else if hitNodes.contains(boneNode) {
            setupBoneAnim()
        } else if hitNodes.contains(soapNode) {
            bathDog()
        } else if hitNodes.contains(ballNode) {
            setupBallAnim()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}


