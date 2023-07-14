import Foundation
import SwiftUI

public class DesignPackage {
    public static var colors = Colors()
    
    public struct Colors {
        public static var primary: Color = .white
        public static var secondary: Color = .black
        
        public static var topGradient: Color = Color(red: 1, green: 0.85, blue: 0.61)
        public static var bottomGradient: Color = Color(red: 0.10, green: 0.33, blue: 0.48)
    }
}
