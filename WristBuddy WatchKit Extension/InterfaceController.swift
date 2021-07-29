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
    let scene = BuddyScene(fileNamed: "Buddy")
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        scene?.size = WKInterfaceDevice.current().screenBounds.size
        buddyScene.isPaused = false
        buddyScene.presentScene(scene)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    
    @IBAction func handleTap(tapGestureRecognizer: WKTapGestureRecognizer){
        let location = tapGestureRecognizer.locationInObject()
        let screenSize = WKInterfaceDevice.current().screenBounds
        print("width \(scene!.size.width)")
        print("height \(scene!.size.height)")
        let tapX = (tapGestureRecognizer.locationInObject().x - (scene!.size.width / 2))
        let tapY = ((scene!.size.height / 2) -  tapGestureRecognizer.locationInObject().y   )
        let tap = CGPoint(x: tapX, y: tapY)
        print("Tapped at \(tap)")
        //let anchorLocation = CGPoint(x: location.x - (screenSize.width)/2, y: location.y - (screenSize.height)/2)
        //print("tapped at \(anchorLocation)")
        WKInterfaceDevice.current().play(.click)
        scene?.didTap(atPosition: tap)
    }
}


