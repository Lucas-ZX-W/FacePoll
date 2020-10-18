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
        window.titlebarAppearsTransparent = true
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func openEmotionalWindow(creatingNewSession: Bool) {
        if nil == emotionalWindow { // create once !!
            let chosenView = FloatingBar(creatingNewSession: creatingNewSession)
            // Create the preferences window and set content
            emotionalWindow = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: 350, height: 120),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            emotionalWindow.titleVisibility = .hidden
            emotionalWindow.center()
            emotionalWindow.setFrameAutosaveName("Preferences")
            emotionalWindow.isReleasedWhenClosed = false
            emotionalWindow.contentView = NSHostingView(rootView: chosenView)
        }
        emotionalWindow.makeKeyAndOrderFront(nil)
    }
    
    @objc func openCamWindow() {
        if nil == camWindow { // create once !!
            let chosenView = CamView()
            // Create the preferences window and set content
            camWindow = NSWindow(
                contentRect: NSRect(x: -20, y: -20, width: 600, height: 80),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            camWindow.titlebarAppearsTransparent = true
            camWindow.center()
            camWindow.setFrameAutosaveName("Preferences")
            camWindow.isReleasedWhenClosed = false
            camWindow.contentView = NSHostingView(rootView: chosenView)
            camWindow.level = .floating
        }
        camWindow.makeKeyAndOrderFront(nil)
    }

}

