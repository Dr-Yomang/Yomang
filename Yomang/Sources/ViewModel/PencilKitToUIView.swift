//
//  PencilKitToUIView.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import SwiftUI
import PencilKit

struct MyCanvas: UIViewRepresentable {
    var canvasView: PKCanvasView = PKCanvasView()
    @State var toolPicker: PKToolPicker! = PKToolPicker()
    var undoManager = UndoManager()
    
    func makeUIView(context: Context) -> PKCanvasView {

        canvasView.drawing = PKDrawing()

        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.isScrollEnabled = false

        canvasView.drawingPolicy = .anyInput
        canvasView.isScrollEnabled = false

        canvasView.isOpaque = true

        canvasView.becomeFirstResponder()
        
        // toolpicker
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.colorUserInterfaceStyle = .light
        toolPicker.overrideUserInterfaceStyle = .dark
        toolPicker.addObserver(canvasView)
        
        return canvasView

    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
    }
}

