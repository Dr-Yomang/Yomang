//
//  PencilKitToUIView.swift
//  Yomang
//
//  Created by jose Yun on 2023/08/20.
//

import SwiftUI
import PencilKit

struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @State var toolPicker: PKToolPicker! = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.becomeFirstResponder()
        canvasView.drawing = PKDrawing()
        
        canvasView.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: Constants.widgetSize.height / Constants.widgetSize.width * UIScreen.width )

        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.isScrollEnabled = false

        canvasView.drawingPolicy = .anyInput
        canvasView.isScrollEnabled = false

        canvasView.isOpaque = true
        canvasView.becomeFirstResponder()

        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.colorUserInterfaceStyle = .dark
        toolPicker.overrideUserInterfaceStyle = .dark
        toolPicker.addObserver(canvasView)
        
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) { }
}
