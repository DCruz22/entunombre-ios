//
//  Extensions.swift
//  instacarro
//
//  Created by Eury Perez Beltre on 12/21/16.
//  Copyright © 2016 Eury Perez Beltre. All rights reserved.
//

import UIKit
import AssociatedValues

extension UIView {
    
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = self.superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
    
    func circular(){
        self.layer.cornerRadius = min(self.frame.width/2 , self.frame.height/2)
        self.layer.masksToBounds = true
    }
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBorderWithColor(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    func addBorderWithColor(color: UIColor, topWidth: CGFloat, rightWidth: CGFloat,
                            bottomWidth: CGFloat, leftWidth: CGFloat) {
        if(topWidth > 0){
            addTopBorderWithColor(color: color, width: topWidth)
        }
        
        if(bottomWidth > 0) {
            addBottomBorderWithColor(color: color, width: bottomWidth)
        }
        
        if(rightWidth > 0) {
            addRightBorderWithColor(color: color, width: rightWidth)
        }
        
        if(leftWidth > 0){
            addLeftBorderWithColor(color: color, width: leftWidth)
        }
    }
    
    func borderRadius(corners:UIRectCorner, radius:CGFloat) {
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:corners,
                                cornerRadii: CGSize(width: radius, height:  radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func gradientBackground(with colors:[UIColor], at locations:[NSNumber], diagonalStyle:Bool = false) {
        self.backgroundColor = UIColor.black
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        gradientLayer.colors = colors.map {$0.cgColor}
        gradientLayer.locations = locations
        
        if diagonalStyle {
            gradientLayer.startPoint = CGPoint(x:0.8, y:0)
            gradientLayer.endPoint = CGPoint(x:0, y:0.8)
        }
        
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func startBlink(repeatCount:Float = 0) {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.autoreverse, .repeat],
                       animations: {
                        UIView.setAnimationRepeatCount(repeatCount)
                        self.alpha = 0
        }, completion: {(finished:Bool) in
            self.stopBlink()
        })
    }
    
    func stopBlink() {
        alpha = 1
        layer.removeAllAnimations()
    }
    
    func fadeInAndOut(withDuration duration:Double = 1, delay:Double = 0, repeatCount:Float = 0) {
        UIView.animate(withDuration: duration,
                       delay:0.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        UIView.setAnimationRepeatCount(repeatCount)
                        self.alpha = 1
                        self.isUserInteractionEnabled = true
        }, completion: {(finished:Bool) in
            UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut, .allowUserInteraction],
                           animations: { () -> Void in
                self.alpha = 0
            }, completion: nil)
        })
    }
    
    public func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    public func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func capture() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        return self.parentView(of: UITableView.self)
    }
}

extension UITapGestureRecognizer {
    var textTag: String? {
        get {
            return getAssociatedValue(key: "textTag", object: self, initialValue: "")
        }
        set {
            set(associatedValue: newValue, key: "textTag", object: self)
        }
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
    
    static func colors(with hexStrings:[String]) -> [UIColor] {
        var colors = [UIColor]()
        
        for val in hexStrings {
            colors.append(UIColor(hexString: val)!)
        }
        
        return colors
    }
    
    func rgb() -> UInt? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return UInt(rgb)
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    
    open class var info: UIColor { return UIColor(hexString: "#EAF7FFFF")! }
    open class var infoText: UIColor { return UIColor(hexString: "#4471A8FF")! }
    
    open class var warning: UIColor { return UIColor(hexString: "#FBF6DDFF")! }
    open class var warningText: UIColor { return UIColor(hexString: "#9A743AFF")! }
    
    open class var error: UIColor { return UIColor(hexString: "#F7D3CEFF")! }
    open class var errorText: UIColor { return UIColor(hexString: "#A70017FF")! }
    
    open class var success: UIColor { return UIColor(hexString: "#CFFFDEFF")! }
    open class var successText: UIColor { return UIColor(hexString: "#317738FF")! }
    
    open class var green: UIColor { return UIColor(hexString: "#47B769FF")! }
    open class var lightGreen: UIColor { return UIColor(hexString: "#ADCFA5FF")! }
    open class var translucentGreen: UIColor { return UIColor(hexString: "#47B76980")! }
    open class var transparentGreen: UIColor { return UIColor(hexString: "#47B7691A")! }
    open class var darkGreen: UIColor { return UIColor(hexString: "#273C44FF")! }
    open class var darkerGreen: UIColor { return UIColor(hexString: "#1C2C33FF")! }
    open class var darkYellow: UIColor { return UIColor(hexString: "#97A214FF")!}
    open class var orange: UIColor { return UIColor(hexString: "#F18C00FF")! }
    open class var border: UIColor { return UIColor(hexString: "#C3C3C3FF")! }
    open class var gray: UIColor { return UIColor(hexString: "#F1F1F1FF")! }
    open class var darkGray:UIColor { return UIColor(hexString: "#A5A5A5FF")!}
    open class var transparent: UIColor { return UIColor(hexString: "#FFFFFF00")! }
    open class var disabledButton: UIColor { return UIColor(hexString: "#A7A7A7FF")! }
    open class var darkGold: UIColor { return UIColor(hexString: "#B57D19FF")! }
    open class var lightGold: UIColor { return UIColor(hexString: "#F3BB50FF")! }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness,
                                  width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness,
                                  height: self.frame.height)
            break
        case UIRectEdge.all:
            addBorder(edge: UIRectEdge.top, color: color, thickness: thickness)
            addBorder(edge: UIRectEdge.bottom, color: color, thickness: thickness)
            addBorder(edge: UIRectEdge.left, color: color, thickness: thickness)
            addBorder(edge: UIRectEdge.right, color: color, thickness: thickness)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
    func removeBorders() {
        sublayers?.forEach {
            if(type(of: $0) == CALayer.self) {
                $0.removeFromSuperlayer()
            }
        }
    }
    
}

extension UIDevice {
    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .unknown
        }
    }
}

extension Double {
    func getDateStringFromMillis() -> String {
        let date = Date(timeIntervalSince1970: self/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    func toDateFromMillis() -> Date {
        return Date(timeIntervalSince1970: self/1000)
    }
    
    func toTimeIntervalFromMillis(isFutureTime:Bool) -> TimeInterval {
        let interval = Date().timeIntervalSince(toDateFromMillis())
        return isFutureTime ? interval * (-1) : interval
    }
    
    func toTimeIntervalFromMillis(since date:Date) -> TimeInterval {
        return Date().timeIntervalSince(date)
    }
    
    var rounded: Int {
        return Int(self)
    }
    
    func roundTo(places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }
    
    func minDigits(digits: Int) -> String {
        return String(format: "%0\(digits)d", self)
    }
}

extension Float {
    func roundTo(places: Int) -> String {
        return String(format: "%.\(places)f", self).replacingOccurrences(of: ".", with: ",")
    }
    
    var rounded: Int {
        return Int(self)
    }
}

extension IndexPath {
    func isValid(collectionView:UICollectionView) -> Bool {
        return self.section < collectionView.numberOfSections && self.row < collectionView.numberOfItems(inSection: self.section)
    }
}

extension NSDictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}
extension NSArray {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}

extension TimeInterval {
    func toMillis() -> Double {
        return self.rounded() * 1000
    }
    func toSeconds() -> Double {
        return self.rounded()
    }
    
    func toMinutes() -> Double {
        return self.rounded() / 60
    }
}

extension UIImageView {
    func tint( color:UIColor) -> UIImage
    {
        image = image!.withRenderingMode(.alwaysTemplate)
        tintColor = color
        return image!
    }
}

extension UIImage {
    
    var uncompressedPNGData: Data?      { return UIImagePNGRepresentation(self)        }
    var highestQualityJPEGNSData: Data? { return UIImageJPEGRepresentation(self, 1.0)  }
    var highQualityJPEGNSData: Data?    { return UIImageJPEGRepresentation(self, 0.75) }
    var mediumQualityJPEGNSData: Data?  { return UIImageJPEGRepresentation(self, 0.5)  }
    var lowQualityJPEGNSData: Data?     { return UIImageJPEGRepresentation(self, 0.25) }
    var lowestQualityJPEGNSData:Data?   { return UIImageJPEGRepresentation(self, 0.0)  }
    
    func resizeImageWithAspect(width:CGFloat, height :CGFloat)->UIImage
    {
        let oldWidth = self.size.width;
        let oldHeight = self.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight);
        
        return imageWithSize(size: newSize);
    }
    
    func imageWithSize(size: CGSize)->UIImage{
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)){
            UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.main.scale);
        }
        else
        {
            UIGraphicsBeginImageContext(size);
        }
        
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage!;
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    var png: Data? { return UIImagePNGRepresentation(self) }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
    func resizeImage(image: UIImage) -> UIImage {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(0.0, 0.0, CGFloat(actualWidth), CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!,CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
    
    // MARK: - UIImage+Resize
    func compressTo(_ expectedSizeInMb:Int) -> UIImage? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = UIImageJPEGRepresentation(self, compressingValue) {
                if data.count < sizeInBytes {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < sizeInBytes) {
                return UIImage(data: data)
            }
        }
        return nil
    }
    
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resizedTo1MB() -> UIImage? {
        guard let imageData = UIImageJPEGRepresentation(self, 1) else { return nil }
        
        var resizingImage = self
        var imageSizeKB = Double(imageData.count) / 1024.0
        
        while imageSizeKB > 1024 {
            guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
                let imageData = UIImageJPEGRepresentation(resizedImage, 1)
                else { return nil }
            
            resizingImage = resizedImage
            imageSizeKB = Double(imageData.count) / 1024.0
        }
        
        return resizingImage
    }
}

extension UITextField{
    func nextTextFieldField() -> UITextField?{
        //field to return
        var returnField : UITextField?
        if self.superview != nil{
            //for each view in superview
            for (_, view) in self.superview!.subviews.enumerated(){
                //if subview is a text's field
                if type(of:view) == UITextField.self{
                    //cast curent view as text field
                    let currentTextField = view as! UITextField
                    //if text field is after the current one
                    if currentTextField.frame.origin.y > self.frame.origin.y{
                        //if there is no text field to return already
                        if returnField == nil {
                            //set as default return
                            returnField = currentTextField
                        }
                            //else if this this less far than the other
                        else if currentTextField.frame.origin.y < returnField!.frame.origin.y{
                            //this is the field to return
                            returnField = currentTextField
                        }
                    }
                }
            }
        }
        //end of the method
        return returnField
    }
}

extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    func encodedUrl() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func toDate(format:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
    
    func formatDate(inFormat:String, outFormat:String) -> String {
        let date = toDate(format:inFormat)
        return date.format(format: outFormat)
    }
    
    public func index(of char: Character) -> Int? {
        if let idx = characters.index(of: char) {
            return characters.distance(from: startIndex, to: idx)
        }
        return nil
    }
    
    func paramsFromJSON() -> [String : AnyObject]?
    {
        let objectData: NSData = (self.data(using: String.Encoding.utf8))! as NSData
        var jsonDict: [ String : AnyObject]!
        do {
            jsonDict = try JSONSerialization.jsonObject(with: objectData as Data, options: .mutableContainers) as! [ String : AnyObject]
            return jsonDict
        } catch {
            print("JSON serialization failed:  \(error)")
            return nil
        }
    }
    
    func format(parameters: CVarArg...) -> String {
        return String(format: self, arguments: parameters)
    }
    
    func subString(start: Int, length: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: length)
        
        let finalString = self.substring(from: startIndex)
        return finalString.substring(to: endIndex)
    }
    
    func addBoldText(boldPartOfString: String, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedStringKey.font:font!]
        let boldFontAttribute = [NSAttributedStringKey.font:boldFont!]
        let boldString = NSMutableAttributedString(string: self, attributes:nonBoldFontAttribute)
        boldString.addAttributes(boldFontAttribute, range: (self as NSString).range(of: boldPartOfString))
        return boldString
    }
    
    func addColoredText(coloredPartOfString: String, font: UIFont!, color:UIColor, boldColoredText:Bool = false) -> NSAttributedString {
        let range = (self as NSString).range(of: coloredPartOfString)
        let attribute = NSMutableAttributedString.init(string: self)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color , range: range)
        if boldColoredText {
            attribute.addAttribute(NSAttributedStringKey.font, value: font.bold(), range: range)
        }
        return attribute
    }
}

extension NSAttributedString {
    func addBoldText(boldPartOfString: String, boldFont: UIFont!) -> NSAttributedString {
        let boldFontAttribute = [NSAttributedStringKey.font:boldFont!]
        let boldString = NSMutableAttributedString()
        boldString.append(self)
        boldString.addAttributes(boldFontAttribute, range: (self.string as NSString).range(of: boldPartOfString))
        return boldString
    }
    
    func addColoredText(coloredPartOfString: String, font: UIFont!, color:UIColor, boldColoredText:Bool = false) -> NSAttributedString {
        let range = (self.string as NSString).range(of: coloredPartOfString)
        let attribute = NSMutableAttributedString()
        attribute.append(self)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color , range: range)
        if boldColoredText {
            attribute.addAttribute(NSAttributedStringKey.font, value: font.bold(), range: range)
        }
        return attribute
    }
}

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
    
    struct Format {
        public static var longDate: String { return "EEEE, dd 'de' MMMM, 'às' HH:mm'h'" }
        public static var slots: String { return "M/dd/yyyy" }
        public static var slotsDate: String {return "dd/MMM (EE)"}
        public static var inspectionDate: String { return "yyyy-MM-dd'T'HH:mm:'00.000Z'"}
        public static var shortDate:String {return "dd/MM/yyyy"}
        public static var shortTime:String {return "HH'h'mm'm'"}
        public static var shortTimeNoLiterals:String {return "HH:mm"}
        public static var dateAndMonth:String {return "dd/MM"}
    }
    
    func format(format:String, locale:Locale = Locale.current, timeZone:String? = NSTimeZone.default.identifier) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        if let zone = timeZone {
            dateFormatter.timeZone = NSTimeZone(name: zone) as TimeZone!
        }
        return dateFormatter.string(from: self)
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of exact seconds from another date
    func exactMinutes(from date: Date) -> Float {
        return ((Float)(Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0)/60)
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

extension Locale {
    public static var current:Locale {
        return Locale.init(identifier: "pt_BR")
    }
}

extension Dictionary {
    public func mapDict<T: Hashable, U>( transform: (Key, Value) -> (T, U)) -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }
    
    public func mapDict<T: Hashable, U>( transform: (Key, Value) throws -> (T, U)) rethrows -> [T: U] {
        var result: [T: U] = [:]
        for (key, value) in self {
            let (transformedKey, transformedValue) = try transform(key, value)
            result[transformedKey] = transformedValue
        }
        return result
    }
}

extension Dictionary where Value: Equatable {
    func containsKey(key : Key) -> Bool {
        return self.contains { $0.0 == key }
    }
    func containsValue(value : Value) -> Bool {
        return self.contains { $0.1 == value }
    }
}

extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}

extension Int {
    func format(minDigits:Int = 2) -> String{
        return String(format: "%0\(minDigits)d", self)
    }
    
    
    func withSeparators() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension UILabel {
    
}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
}

extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(0, childStartPoint.y, 1, self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
        
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}


extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}

@objc protocol TabBarSwitcher {
    func handleSwipes(sender:UISwipeGestureRecognizer)
}

extension TabBarSwitcher where Self: UIViewController {
    func initSwipe(_ direction: UISwipeGestureRecognizerDirection){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
        swipe.direction = direction
        self.view.addGestureRecognizer(swipe)
    }
    func initSwipe(_ directions: [UISwipeGestureRecognizerDirection]){
        for direction in directions {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
            swipe.direction = direction
            self.view.addGestureRecognizer(swipe)
        }
    }
}

extension UITabBarController {
     var customSelectedIndex: Int{
        get{
            return self.selectedIndex
        }
        set{
            animateToTab(toIndex: newValue)
            self.selectedIndex = newValue
        }
    }
    
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = viewControllers, tabViewControllers.count > toIndex, let fromViewController = selectedViewController, let fromIndex = tabViewControllers.index(of: fromViewController), fromIndex != toIndex else {return}
        
        view.isUserInteractionEnabled = false
        
        let toViewController = tabViewControllers[toIndex]
        let push = toIndex > fromIndex
        let bounds = UIScreen.main.bounds
        
        let offScreenCenter = CGPoint(x: fromViewController.view.center.x + bounds.width, y: toViewController.view.center.y)
        let partiallyOffCenter = CGPoint(x: fromViewController.view.center.x - bounds.width*0.25, y: fromViewController.view.center.y)
        
        if push{
            fromViewController.view.superview?.addSubview(toViewController.view)
            toViewController.view.center = offScreenCenter
        }else{
            fromViewController.view.superview?.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            toViewController.view.center = partiallyOffCenter
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            toViewController.view.center   = fromViewController.view.center
            fromViewController.view.center = push ? partiallyOffCenter : offScreenCenter
        }, completion: { finished in
            fromViewController.view.removeFromSuperview()
            self.view.isUserInteractionEnabled = true
        })
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
