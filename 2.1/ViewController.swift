
import UIKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate  {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var widthCanvas: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    var lastPoint : CGPoint = CGPoint(x:0,y:0)
    var drawingColor = UIColor.black
    let canvasWidth = 5.0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        lastPoint = (touch?.location(in: self.imageView))!
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let currentPoint = (touch?.location(in: self.imageView))!
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        let drawRect = CGRect.init(x: 0.0, y: 0.0, width: self.imageView.frame.width, height: self.imageView.frame.height)
        self.imageView.image?.draw(in: drawRect)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(drawingColor.cgColor)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(CGFloat(widthCanvas.selectedSegmentIndex + 1))
        context?.beginPath()
        context?.move(to: lastPoint)
        context?.addLine(to: currentPoint)
        context?.strokePath()
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        lastPoint = currentPoint
    }
    func colorPickerViewControllerDidFinish(_ viewController : UIColorPickerViewController) {
        self.drawingColor = viewController.selectedColor
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController : UIColorPickerViewController) {
        self.drawingColor = viewController.selectedColor
    }
    @IBAction func changeColor(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = drawingColor
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        }
    
    @IBAction func savePicture(_ sender: Any) {
        if imageView.image != nil{

            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, #selector(error), nil);
        }
    }
    @objc func error(image: UIImage!, didFinishSavingWithError error: NSError!, contextInfo: AnyObject!) {
        if error == nil{
        print(error ?? "Error")
        }
    }
}
