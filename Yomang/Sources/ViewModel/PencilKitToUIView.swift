//
//  PencilKitToUIView.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import SwiftUI
import PencilKit

struct MyCanvas: UIViewRepresentable {
    var cntrl: PKCanvasController
    @State var toolPicker: PKToolPicker! = PKToolPicker()

    func makeUIView(context: Context) -> PKCanvasView {
        cntrl.canvas = PKCanvasView()
        cntrl.canvas.delegate = context.coordinator
        cntrl.canvas.becomeFirstResponder()
        
        cntrl.canvas.drawing = PKDrawing()

        cntrl.canvas.backgroundColor = .clear
        cntrl.canvas.isOpaque = false
        cntrl.canvas.isScrollEnabled = false

        cntrl.canvas.drawingPolicy = .anyInput
        cntrl.canvas.isScrollEnabled = false

        cntrl.canvas.isOpaque = true

        cntrl.canvas.becomeFirstResponder()
        
        toolPicker.setVisible(true, forFirstResponder: cntrl.canvas)
        toolPicker.colorUserInterfaceStyle = .light
        toolPicker.overrideUserInterfaceStyle = .dark
        toolPicker.addObserver(cntrl.canvas)
        
        return cntrl.canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

class Coordinator: NSObject, PKCanvasViewDelegate {
    var parent: MyCanvas

    init(_ uiView: MyCanvas) {
        self.parent = uiView
    }

    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if !self.parent.cntrl.didMove {
            self.parent.cntrl.drawings.append(canvasView.drawing)
        }
    }
}
    
}

class PKCanvasController {
    var canvas = PKCanvasView()
    var drawings = [PKDrawing]()
    var redoDrawings = [PKDrawing]()
    var didMove = false

    func clear() {
        canvas.drawing = PKDrawing()
        drawings = [PKDrawing]()
        redoDrawings = [PKDrawing]()
    }

    func undoDrawing() {
        if !drawings.isEmpty {
            didMove = true
            redoDrawings.append(drawings.removeLast())
            canvas.drawing = drawings.last ?? PKDrawing()
            didMove = false
        }
    }
        
        func redoDrawing() {
            if !redoDrawings.isEmpty {
                didMove = true
                drawings.append(redoDrawings.removeLast())
                canvas.drawing = drawings.last ?? PKDrawing()
                didMove = false
            }
            
        }
}
