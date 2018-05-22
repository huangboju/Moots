//
//  QuartzPDFView.swift
//  QuartzDemo
//
//  Created by 伯驹 黄 on 2017/4/8.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

class QuartzPDFView: QuartzView {
    var pdfDocument: CGPDFDocument {
        let pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "Quartz.pdf" as CFString, nil, nil)
        return CGPDFDocument(pdfURL!)!
    }

    override func draw(in context:  CGContext) {
        // PDF page drawing expects a Lower-Left coordinate system, so we flip the coordinate system
        // before we start drawing.
        context.translateBy(x: 0.0, y: bounds.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Grab the first PDF page
        let page = pdfDocument.page(at: 1)
        // We're about to modify the context CTM to draw the PDF page where we want it, so save the graphics state in case we want to do more drawing
        context.saveGState()
        // CGPDFPageGetDrawingTransform provides an easy way to get the transform for a PDF page. It will scale down to fit, including any
        // base rotations necessary to display the PDF page correctly.

        let pdfTransform = page?.getDrawingTransform(.cropBox, rect: bounds, rotate: 0, preserveAspectRatio: true)
        // And apply the transform.
        context.concatenate(pdfTransform!)
        // Finally, we draw the page and restore the graphics state for further manipulations!
        context.drawPDFPage(page!)
        context.restoreGState()
    }
}
