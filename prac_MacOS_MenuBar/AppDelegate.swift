

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem = {
        NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength )
    }()
    
    var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .transient
        return popover
    }()
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle.main)
        guard let windowController = storyboard.instantiateController(withIdentifier: "MainViewController") as? NSWindowController else {
            return
        }
        
        let contentViewController = windowController.contentViewController
        
        let btn = self.statusItem.button
        btn?.action = #selector(statusItemClicked(_:))
        btn?.sendAction(on: [.leftMouseDown, .rightMouseDown])
        btn?.changeStatus(emojiString: "🇯🇵")
        
        self.popover.contentViewController = contentViewController
    }
    
    @objc func statusItemClicked(_ sender: NSStatusBarButton){
        let isRightClickEvent = NSApp.currentEvent?.isRightClick ?? false
        
        if self.popover.isShown{
            self.popover.close()
        }
        
        if !isRightClickEvent {
            self.popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
            return
        }
        self.showMenu()
    }
    
    func showMenu(){
        var location = NSEvent.mouseLocation
        location.y = NSScreen.main!.frame.height - NSStatusBar.system.thickness - 10
        
        let contentRect = NSRect(origin: location, size: CGSize(width: 0, height: 0))
        
        let tmpWindow = NSWindow(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: false)
        tmpWindow.isReleasedWhenClosed = true
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Info", action: nil, keyEquivalent: " "))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        menu.popUp(positioning: nil, at: .zero, in: tmpWindow.contentView)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

extension String {
    func emojiToImage(with fontSize: CGFloat) -> NSImage? {
        let size = CGSize(width: fontSize, height: fontSize)
        let image = NSImage(size: size, flipped: true, drawingHandler: { dstRect in
            
            let textOrigin = CGPoint(x: 0, y: 0)
            
            let rect = CGRect(origin: textOrigin, size: dstRect.size)
            
            let textFont = NSFont.systemFont(ofSize: fontSize)
            let attributes = [NSAttributedString.Key.font: textFont,]
            
            self.draw(in: rect, withAttributes: attributes)
            return true
        })
        
        return image
    }
}

extension NSStatusBarButton{
    func changeStatus(emojiString: String){
        guard let statusBtnImage = emojiString.emojiToImage(with: 18) else {
            return
        }
        self.image = statusBtnImage
    }
}

extension NSEvent{
    var isRightClick: Bool{
        self.type == .rightMouseDown
    }
}
