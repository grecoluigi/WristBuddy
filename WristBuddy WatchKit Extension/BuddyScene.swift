//
//  BuddyScene.swift
//  WristBuddy WatchKit Extension
//
//  Created by Luigi Greco on 23/07/21.
//

import WatchKit
import SpriteKit

class BuddyScene: SKScene {
    
    var numImages = Int()
    var dog = SKSpriteNode()
    var buddyActionFrames: [SKTexture] = []
    var objectAnimationFrames: [SKTexture] = []
    var firstFrameTexture = SKTexture()
    var boneNode = SKSpriteNode()
    var soapNode = SKSpriteNode()
    var ballNode = SKSpriteNode()
    var boneAnimNode = SKSpriteNode()
    var bubblesNode = SKSpriteNode()
    var ballAnimNode = SKSpriteNode()
    var background = SKSpriteNode()
    var foreground = SKSpriteNode()
    var celestialObj = SKSpriteNode()
    let objectsAtlas = SKTextureAtlas(named: "objects")
    let bubblesAtlas = SKTextureAtlas(named: "bubbles")
    let dogJumpAtlas = SKTextureAtlas(named: "dogJump")
    let ballPlayingAtlas = SKTextureAtlas(named: "ballPlaying")
    let ballAnimAtlas = SKTextureAtlas(named: "ballAnim")
    var setBackground = SKAction()
    var setForeground = SKAction()
    var setCelestial = SKAction()
    
    override func sceneDidLoad() {
        setScene()
        bubblesNode.name = "bubblesNode"
        setupRestingAnimation()
        restDog()
        scene?.addChild(dog)
        setupBone()
        setupSoap()
        setupBall()
    }
    
    func setScene(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        var celestialPosition = CGPoint(x: 0, y: 0)
        switch hour {
        case 5:
            celestialPosition.x = -70
            celestialPosition.y = 0
            celestialObj.setScale(1.1)
        case 6:
            celestialPosition.x = -65
            celestialPosition.y = 10
            celestialObj.setScale(1.2)
        case 7:
            celestialPosition.x = -55
            celestialPosition.y = 30
            celestialObj.setScale(1.2)
        case 8:
            celestialPosition.x = -40
            celestialPosition.y = 40
            celestialObj.setScale(1.3)
        case 9:
            celestialPosition.x = -30
            celestialPosition.y = 50
            celestialObj.setScale(1.3)
        case 10:
            celestialPosition.x = -25
            celestialPosition.y = 55
            celestialObj.setScale(1.3)
        case 11:
            celestialPosition.x = -20
            celestialPosition.y = 60
            celestialObj.setScale(1.3)
        case 12:
            celestialPosition.x = 0
            celestialPosition.y = 70
            celestialObj.setScale(1.8)
        case 13:
            celestialPosition.x = 20
            celestialPosition.y = 60
            celestialObj.setScale(1.3)
        case 14:
            celestialPosition.x = 25
            celestialPosition.y = 55
            celestialObj.setScale(1.3)
        case 15:
            celestialPosition.x = 30
            celestialPosition.y = 50
            celestialObj.setScale(1.3)
        case 16:
            celestialPosition.x = 40
            celestialPosition.y = 40
            celestialObj.setScale(1.3)
        case 17:
            celestialPosition.x = 55
            celestialPosition.y = 30
            celestialObj.setScale(1.2)
        case 18:
            celestialPosition.x = 70
            celestialPosition.y = 0
            celestialObj.setScale(1)
        case 19:
            celestialPosition.x = -70
            celestialPosition.y = 0
            celestialObj.setScale(1)
        case 20:
            celestialPosition.x = -65
            celestialPosition.y = 10
            celestialObj.setScale(1.1)
        case 21:
            celestialPosition.x = -55
            celestialPosition.y = 30
            celestialObj.setScale(1.1)
        case 22:
            celestialPosition.x = -40
            celestialPosition.y = 40
            celestialObj.setScale(1.2)
        case 23:
            celestialPosition.x = -30
            celestialPosition.y = 50
            celestialObj.setScale(1.2)
        case 24:
            celestialPosition.x = -25
            celestialPosition.y = 55
            celestialObj.setScale(1.2)
        case 1:
            celestialPosition.x = -20
            celestialPosition.y = 60
            celestialObj.setScale(1.2)
        case 2:
            celestialPosition.x = 40
            celestialPosition.y = 40
            celestialObj.setScale(1.2)
        case 3:
            celestialPosition.x = 55
            celestialPosition.y = 30
            celestialObj.setScale(1.1)
        case 4:
            celestialPosition.x = 70
            celestialPosition.y = 0
            celestialObj.setScale(1)
        default:
            celestialPosition.x = 0
            celestialPosition.y = 70
        }
        celestialObj.position = celestialPosition
        if (hour > 7 && hour < 18) {
            addBackground(bgTexture: "skyDay", fgTexture: "grassDay", celestialTexture: "sun")
            print ("è mattina")
        } else if (hour >= 18 && hour <= 20 ){
            addBackground(bgTexture: "skySunset", fgTexture: "grassSunset", celestialTexture: "moon")
            print ("è tramonto")
        } else if ( hour >= 5 && hour <= 7) {
            addBackground(bgTexture: "skySunrise", fgTexture: "grassSunrise", celestialTexture: "sun")
            print("è alba")
        } else {
            addBackground(bgTexture: "skyNight", fgTexture: "grassNight", celestialTexture: "moon")
            print ("è notte")
        }
    }
    
    func addBackground(bgTexture: String, fgTexture: String, celestialTexture: String) {
        setBackground = SKAction.setTexture(objectsAtlas.textureNamed(bgTexture), resize: false)
        setForeground = SKAction.setTexture(objectsAtlas.textureNamed(fgTexture), resize: false)
        setCelestial = SKAction.setTexture(objectsAtlas.textureNamed(celestialTexture), resize: false)
        background.run(setBackground)
        scene?.addChild(background)
        celestialObj.run(setCelestial)
        scene?.addChild(celestialObj)
        foreground.run(setForeground)
        scene?.addChild(foreground)
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
        numImages = boneAnimAtlas.textureNames.count
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
    func
    boneEatingAnim() {
        boneAnimNode.removeFromParent()
        dog.removeAllActions()
        buddyActionFrames.removeAll()
        let dogBonEatingAtlas = SKTextureAtlas(named: "boneEating")
        numImages = dogBonEatingAtlas.textureNames.count
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
        numImages = bubblesAtlas.textureNames.count
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
        objectAnimationFrames.removeAll()
        numImages = ballAnimAtlas.textureNames.count
        for i in 1...numImages {
            let ballAnimTextureName = "ballAnim\(i)"
            objectAnimationFrames.append(ballAnimAtlas.textureNamed(ballAnimTextureName))
        }
        scene?.addChild(ballAnimNode)
        ballAnimNode.name = "ballAnimNode"
        let incomingBall = SKAction.setTexture(objectAnimationFrames[0], resize: false)
        let animateIncomingBall = SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.1, resize: false, restore: false)
        let sequence = SKAction.sequence([incomingBall, animateIncomingBall])
            ballAnimNode.setScale(1.5)
        ballAnimNode.run(sequence, completion: setupBallAnim2)
        }
    }
    
    func setupBallAnim2(){
        
            numImages = dogJumpAtlas.textureNames.count
            buddyActionFrames.removeAll()
            for i in 1...numImages {
                let dogJumpTextureName = "dogJump\(i)"
                buddyActionFrames.append(dogJumpAtlas.textureNamed(dogJumpTextureName))
            }
            let playWithBall = SKAction.run { [self] in

                        buddyActionFrames.removeAll()
                        numImages = ballPlayingAtlas.textureNames.count
                        for i in 1...numImages {
                            let ballPlayingTextureName = "ballPlaying\(i)"
                            buddyActionFrames.append(ballPlayingAtlas.textureNamed(ballPlayingTextureName))
                        }
                        dog.removeAllActions()
                        dog.position = CGPoint(x: frame.midX, y: frame.midY - 17)
                        dog.run(SKAction.setTexture(ballPlayingAtlas.textureNamed("ballPlaying1"), resize: true))
                        dog.run(SKAction.setTexture(buddyActionFrames[0], resize: false))
                        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.15), count: 3), completion: restDog)
                ballAnimNode.removeFromParent()
            }

            // far giocare il cane - azione cane
            
            let sequence = SKAction.sequence([  playWithBall])
            dog.run(sequence)

    }
    
    
    
//    func setupBallAnim(){
//        if checkForNode(named: "ballAnimNode") == false {
//            numImages = dogJumpAtlas.textureNames.count
//            buddyActionFrames.removeAll()
//            for i in 1...numImages {
//                let dogJumpTextureName = "dogJump\(i)"
//                buddyActionFrames.append(dogJumpAtlas.textureNamed(dogJumpTextureName))
//            }
//            dog.run(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.15, resize: false, restore: false), completion: setDogTexture)
//        }
//    }
//
//    func setDogTexture(){
//        dog.removeAllActions()
//        dog.run(SKAction.setTexture(dogJumpAtlas.textureNamed("dogJump4"), resize: true), completion: setupBallAnim2)
//    }
//
//    func setupBallAnim2(){
//        let ballAnimAtlas = SKTextureAtlas(named: "ballAnim")
//        objectAnimationFrames.removeAll()
//        numImages = ballAnimAtlas.textureNames.count
//        for i in 1...numImages {
//            let ballAnimTextureName = "ballAnim\(i)"
//            objectAnimationFrames.append(ballAnimAtlas.textureNamed(ballAnimTextureName))
//        }
//        scene?.addChild(ballAnimNode)
//        ballAnimNode.run(SKAction.setTexture(objectAnimationFrames[0], resize: false))
//        ballAnimNode.name = "ballAnimNode"
//        ballAnimNode.run(SKAction.animate(with: objectAnimationFrames, timePerFrame: 0.1, resize: false, restore: true), completion: ballAnim)
//    }
//
//    func ballAnim(){
//        ballAnimNode.removeFromParent()
//        buddyActionFrames.removeAll()
//        numImages = ballPlayingAtlas.textureNames.count
//        for i in 1...numImages {
//            let ballPlayingTextureName = "ballPlaying\(i)"
//            buddyActionFrames.append(ballPlayingAtlas.textureNamed(ballPlayingTextureName))
//        }
//        dog.removeAllActions()
//        dog.position = CGPoint(x: frame.midX, y: frame.midY - 17)
//        dog.run(SKAction.setTexture(ballPlayingAtlas.textureNamed("ballPlaying1"), resize: true))
//        dog.run(SKAction.setTexture(buddyActionFrames[0], resize: false))
//        dog.run(SKAction.repeat(SKAction.animate(with: buddyActionFrames, timePerFrame: 0.15), count: 3), completion: restDog)
//    }
    

    
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
        ballNode.setScale(0.75)
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
        numImages = dogWavingAtlas.textureNames.count
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
        numImages = dogBathAtlas.textureNames.count
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
