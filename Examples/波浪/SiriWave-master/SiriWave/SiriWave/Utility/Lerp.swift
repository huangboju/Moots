//
//  Lerp.swift
//  SiriWave
//
//  Created by politom on 09/03/2019.
//

import Foundation
import UIKit

public class Lerp {
    public static func lerp(_ v0: CGFloat, _ v1: CGFloat, _ t: CGFloat) -> CGFloat {
        return v0 * (1 - t) + v1 * t
    }
}
