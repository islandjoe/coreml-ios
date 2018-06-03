import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController {
    
  @IBOutlet weak var previewView: PreviewView!
  @IBOutlet weak var objectTextView: UITextView!
  
  // Live Camera Properties
  let captureSession = AVCaptureSession()
  var captureDevice: AVCaptureDevice!
  var devicePosition: AVCaptureDevice.Position = .back
    
  var requests: [VNRequest] = []
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVision()
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    prepareCamera()
  }
    
  func setupVision() {
    
    // Rectangle Request
    let rectDetectRequest = VNDetectRectanglesRequest(completionHandler: handleRectangles)
    rectDetectRequest.minimumSize = 0.1
    rectDetectRequest.maximumObservations = 1
    
    // Object Classification
    guard let visionModel = try? VNCoreMLModel(for: Inceptionv3().model) else {
      fatalError("Can't load VisionML model")
    }
  
    let classification = VNCoreMLRequest(model: visionModel,
                             completionHandler: handleClassification)
    
    classification.imageCropAndScaleOption = .centerCrop
    self.requests = [rectDetectRequest, classification]
  }
    
  func handleRectangles(request: VNRequest, error: Error?) {
    DispatchQueue.main.async {
      self.drawVisionRequestResults( request.results as! [VNRectangleObservation] )
    }
  }
  
  func drawVisionRequestResults(_ results: [VNRectangleObservation]) {
    previewView.removeMask()
  
    let frame = self.previewView.frame
    let transform = CGAffineTransform(scaleX: 1, y: -1)
                  .translatedBy(x: 0, y: -frame.height)
  
    let translate = CGAffineTransform.identity
                  .scaledBy(x: frame.width, y: frame.height)
  
    for rectangle in results {
      let bounds = rectangle.boundingBox
                .applying(translate)
              .applying(transform)
    
      previewView.drawLayer(in: bounds)
    }
  }
    
  func handleClassification(request: VNRequest, error: Error?) {
    
    guard let observations = request.results else {
      print("No results:\(String(describing: error?.localizedDescription))")
      return
    }
  
    let classifications = observations[0...4]
                      .compactMap { $0 as? VNClassificationObservation }
                    .filter { $0.confidence > 0.3 }
                  .map { $0.identifier }
  
    for classification in classifications {
      DispatchQueue.main.async {
        self.objectTextView.text = classification
      }
    }
  }
  
}
