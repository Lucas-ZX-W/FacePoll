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

extension Notification.Name {
    static let emotionalWindowClose = Notification.Name("emotionalWindowClose")
    static let emotionalWindowOpen = Notification.Name("emotionalWindowOpen")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    var window: NSWindow!

    var emotionalWindow: NSWindow!
    var aggregateWindow: NSWindow!

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
        if emotionalWindow == nil { // create once !!
            // Create the preferences window and set content
            let window = NSWindow(
                contentRect: NSRect(x: 20, y: 20, width: 350, height: 120),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            window.titleVisibility = .hidden
            window.center()

            let view = CurrentEmotionView(creatingNewSession: creatingNewSession)
            window.contentView = NSHostingView(rootView: view)
            window.isReleasedWhenClosed = false
            window.delegate = self

            emotionalWindow = window
        }
        NotificationCenter.default.post(name: .emotionalWindowOpen, object: nil)
        emotionalWindow!.makeKeyAndOrderFront(nil)
    }
    
    @objc func openAggregateWindow() {
        if aggregateWindow == nil { // create once !!
            // Create the preferences window and set content
            let window = NSWindow(
                contentRect: NSRect(x: -20, y: -20, width: 600, height: 80),
                styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            window.titlebarAppearsTransparent = true
            window.level = .floating
            window.center()

            let view = AggregateView()
            window.contentView = NSHostingView(rootView: view)
            window.isReleasedWhenClosed = false
            window.delegate = self

            aggregateWindow = window
        }
        aggregateWindow!.makeKeyAndOrderFront(nil)
    }

    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        switch window {
        case emotionalWindow:
            NotificationCenter.default.post(name: .emotionalWindowClose, object: nil)
        default:
            return
        }
    }
}

