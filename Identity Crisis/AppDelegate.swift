//
//  AppDelegate.swift
//  Identity Crisis
//
//  Created by Lucas Wang on 2020-10-17.
//

import Cocoa
import SwiftUI
import FirebaseCore
import FirebaseDatabase

let database = Database.database().reference()


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    var emotionalWindow: NSWindow!
    var camWindow: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Firebase
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        // Create the SwiftUI view that provides the window contents.
        let contentView = MainTabView()
        // For camera testing:
        // let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 250),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.backgroundColor = .white
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func openEmotionalWindow(creatingNewSession: Bool) {
        if nil == emotionalWindow {      // create once !!
            let chosenView = FloatingBar(creatingNewSession: creatingNewSession)
            // Create the preferences window and set content
            emotionalWindow = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: 300, height: 200),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            emotionalWindow.center()
            emotionalWindow.setFrameAutosaveName("Preferences")
            emotionalWindow.isReleasedWhenClosed = false
            emotionalWindow.contentView = NSHostingView(rootView: chosenView)
            emotionalWindow.backgroundColor = .white
        }
        emotionalWindow.makeKeyAndOrderFront(nil)
    }

    
    @objc func openCamWindow() {
        if nil == camWindow {      // create once !!
            let chosenView = CamView()
            // Create the preferences window and set content
            camWindow = NSWindow(
                contentRect: NSRect(x: -20, y: -20, width: 300, height: 200),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            camWindow.center()
            camWindow.setFrameAutosaveName("Preferences")
            camWindow.isReleasedWhenClosed = false
            camWindow.contentView = NSHostingView(rootView: chosenView)
            camWindow.backgroundColor = .white
        }
        camWindow.makeKeyAndOrderFront(nil)
    }

}

