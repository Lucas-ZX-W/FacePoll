//
//  AppDelegate.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var emotionalWindow: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = MainTabView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func openEmotionalWindow() {
        if nil == emotionalWindow {      // create once !!
            let chosenView = FloatingBar()
            // Create the preferences window and set content
            emotionalWindow = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            emotionalWindow.center()
            emotionalWindow.setFrameAutosaveName("Preferences")
            emotionalWindow.isReleasedWhenClosed = false
            emotionalWindow.contentView = NSHostingView(rootView: chosenView)
        }
        emotionalWindow.makeKeyAndOrderFront(nil)
    }


}

