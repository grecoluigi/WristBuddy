//
//  BuddyScene.swift
//  WristBuddy WatchKit Extension
//
//  Created by Luigi Greco on 23/07/21.
//

import WatchKit
import SpriteKit

class BuddyScene: SKScene {
    var dog = SKSpriteNode()
    var buddyActionFrames: [SKTexture] = []
    var objectAnimationFrames: [SKTexture] = []
    var ballPlayingFrames: [SKTexture] = []
    var firstFrameTexture = SKTexture()
    var boneNode = SKSpriteNode()
    var soapNode = SKSpriteNode()
    var ballNode = SKSpriteNode()
    var boneAnimNode = SKSpriteNode()
    var bubblesNode = SKSpriteNode()
    var ballAnimNode = SKSpriteNode()
    let objectsAtlas = SKTextureAtlas(named: "objects")
    let bubblesAtlas = SKTextureAtlas(named: "bubbles")
    
    override func sceneDidLoad() {
        bubblesNode.name = "bubblesNode"
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
    
    func checkForNode(named: String) -> Bool {
        if (childNode(withName: named) as! SKSpriteNode?) != nil {
            print("Node is already present, wait for animation to finish")
            return true
        } else {
            return false
        }
    }
    
    
    
    func setupBoneAnim(){
        if checkForNode(named: "boneAnimNode") == false {
        let boneAnimAtlas = SKTextureAtlas(named: "boneAnim")
        let numImages = boneAnimAtlas.textureNames.count
        objectAnimationFrames.removeAll()
        for i in 1...numImages {
            let boneAnimTextureName = "boneAnim\(i)"
            objectAnimationFrames.append(boneAnimAtlas.textureNamed(boneAnimTextureName))
        }
        firstFrameTexture = objectAnimationFrames[0]
        let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        boneAnimNode.run(setAnimTexture)
        boneAnimNode.setScale(1.4)
        boneAnimNode.position = CGPoint(x: frame.midX, y: frame.midY + 20)
        scene?.addChild(boneAnimNode)
        boneAnimNode.name = "boneAnimNode"
        boneAnimNode.run(SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: boneEatingAnim)
    }
    }

    func setupBubblesAnim1(){
        if checkForNode(named: "bubblesNode") == false {
            objectAnimationFrames.removeAll()
        for i in 1...6 {
            let bubblesTextureName = "bubbles\(i)"
            objectAnimationFrames.append(bubblesAtlas.textureNamed(bubblesTextureName))
        }
        firstFrameTexture = objectAnimationFrames[0]
        let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        bubblesNode.run(setAnimTexture)
        bubblesNode.setScale(1.5)
        scene?.addChild(bubblesNode)
        bubblesNode.name = "bubblesNode"
        bubblesNode.run(SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: setupBubblesAnim2)
        }
    }
    
    func setupBubblesAnim2(){
        dog.removeAllActions()
        objectAnimationFrames.removeAll()
        let dogBathAtlas = SKTextureAtlas(named: "dogBath")
        let bathFrame = dogBathAtlas.textureNamed("dogBath1")
        let setBathTexture = SKAction.setTexture(bathFrame, resize: false)
        dog.run(setBathTexture)
        let numImages = bubblesAtlas.textureNames.count
        for i in 7...numImages {
            let bubblesTextureName = "bubbles\(i)"
            objectAnimationFrames.append(bubblesAtlas.textureNamed(bubblesTextureName))
        }
        firstFrameTexture = objectAnimationFrames[0]
        let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        bubblesNode.run(setAnimTexture)
        bubblesNode.run(SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: bathDog)
    }
    
    func setupBallAnim(){
        if checkForNode(named: "ballAnimNode") == false {
            let ballAnimAtlas = SKTextureAtlas(named: "ballAnim")
                objectAnimationFrames.removeAll()
            let numImages = ballAnimAtlas.textureNames.count
            for i in 1...numImages {
                let ballAnimTextureName = "ballAnim\(i)"
                objectAnimationFrames.append(ballAnimAtlas.textureNamed(ballAnimTextureName))
            }
            firstFrameTexture = objectAnimationFrames[0]
            let setAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
            ballAnimNode.run(setAnimTexture)
            ballAnimNode.position = CGPoint(x: frame.midX, y: frame.midY - 40)
            scene?.addChild(ballAnimNode)
            ballAnimNode.name = "ballAnimNode"
            ballAnimNode.run(SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.15, resize: false, restore: false), completion: ballAnim)
        }
    }
    
    func ballAnim(){
        ballAnimNode.removeFromParent()
        ballPlayingFrames.removeAll()
        let ballPlayingAtlas = SKTextureAtlas(named: "ballPlaying")
        let numImages = ballPlayingAtlas.textureNames.count
        for i in 1...numImages {
            let ballPlayingTextureName = "ballPlaying\(i)"
            ballPlayingFrames.append(ballPlayingAtlas.textureNamed(ballPlayingTextureName))
        }
        firstFrameTexture = ballPlayingFrames[0]
        let setBallAnimTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setBallAnimTexture)
        dog.run(SKAction.animate(with: ballPlayingFrames, timePerFrame: 0.15, resize: false, restore: true))
        
    }
    
    func boneEatingAnim() {
        boneAnimNode.removeFromParent()
        dog.removeAllActions()
        buddyActionFrames.removeAll()
        let dogBonEatingAtlas = SKTextureAtlas(named: "boneEating")
        let numImages = dogBonEatingAtlas.textureNames.count
        for i in 1...numImages {
            let dogBoneEatingTextureName = "boneEating\(i)"
            buddyActionFrames.append(dogBonEatingAtlas.textureNamed(dogBoneEatingTextureName))
        }
        firstFrameTexture = buddyActionFrames[0]
        let setBoneEatingTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setBoneEatingTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.2, resize: false, restore: false), count: 6), completion: {
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
        buddyActionFrames.removeAll()
        let lionRestingAtlas = SKTextureAtlas(named: "lionWaving")
        for i in 1...3 {
            let lionTextureName = "lionWaving\(i)"
            buddyActionFrames.append(lionRestingAtlas.textureNamed(lionTextureName))
        }
        firstFrameTexture = buddyActionFrames[0]
        let setRestTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setRestTexture)
        dog.position = CGPoint(x: frame.midX, y: frame.midY - 10)
    }
    
    func restDog(){
        setupRestingAnimation()
        dog.run(SKAction.repeatForever(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.3, resize: false, restore: false)), withKey: "restingLion")
        
    }
    func waveDog(){
        dog.removeAllActions()
        buddyActionFrames.removeAll()
        let dogWavingAtlas = SKTextureAtlas(named: "lionWaving")
        let numImages = dogWavingAtlas.textureNames.count
        for i in 4...numImages {
            let dogTextureName = "lionWaving\(i)"
            buddyActionFrames.append(dogWavingAtlas.textureNamed(dogTextureName))
        }
        // Reverse the animation loop
        for i in stride(from: numImages, to: 1, by: -1) {
            let lionTextureName = "lionWaving\(i)"
            buddyActionFrames.append(dogWavingAtlas.textureNamed(lionTextureName))
        }
        firstFrameTexture = buddyActionFrames[0]
        let setWaveTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setWaveTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.2, resize: false, restore: false), count: 1), completion: {
            self.restDog()
        })

    }
    
    func bathDog(){
        bubblesNode.removeFromParent()
        buddyActionFrames.removeAll()
        dog.removeAllActions()
        let dogBathAtlas = SKTextureAtlas(named: "dogBath")
        let numImages = dogBathAtlas.textureNames.count
        for i in 1...numImages {
            let dogTextureName = "dogBath\(i)"
            buddyActionFrames.append(dogBathAtlas.textureNamed(dogTextureName))
        }
        firstFrameTexture = buddyActionFrames[0]
        let setBathTexture = SKAction.setTexture(firstFrameTexture, resize: false)
        dog.run(setBathTexture)
        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.2, resize: false, restore: false), count: 8), completion: {
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
            setupBubblesAnim1()
        } else if hitNodes.contains(ballNode) {
            setupBallAnim()
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    }
}


