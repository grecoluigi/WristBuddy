//
//  InterfaceController.swift
//  WristBuddy WatchKit Extension
//
//  Created by Luigi Greco on 23/07/21.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tapGestureRecognizer: WKTapGestureRecognizer!
    @IBOutlet weak var buddyScene: WKInterfaceSKScene!
    @IBOutlet weak var swipeUpGestureRecognizer: WKSwipeGestureRecognizer!
    @IBOutlet weak var swipeDownGestureRecognizer: WKSwipeGestureRecognizer!
    let scene = BuddyScene(fileNamed: "Buddy")
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        scene?.size = WKInterfaceDevice.current().screenBounds.size
        buddyScene.isPaused = false
        buddyScene.presentScene(scene)
    }
    
    override func willActivate() {
        scene?.removeChildren(in: [scene!.background, scene!.celestialObj, scene!.foreground])
        scene?.redrawBackground()
        scene?.downloadNews()
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    

    
    @IBAction func handleSwipeUp(_ swipeUpGestureRecognizer: WKSwipeGestureRecognizer) {
        if swipeUpGestureRecognizer.state == .ended {
            scene?.nextNews()
        }
        
        
    }
    
    @IBAction func handleSwipeDown(_ swipeDownGestureRecognizer: WKSwipeGestureRecognizer) {
        if swipeDownGestureRecognizer.state == .ended {
            scene?.prevNews()
        }
        
    }
    @IBAction func handleTap(tapGestureRecognizer: WKTapGestureRecognizer){
        let tapX = (tapGestureRecognizer.locationInObject().x - (scene!.size.width / 2))
        let tapY = ((scene!.size.height / 2) -  tapGestureRecognizer.locationInObject().y   )
        let tap = CGPoint(x: tapX, y: tapY)
        WKInterfaceDevice.current().play(.click)
        scene?.didTap(atPosition: tap)
    }
}


