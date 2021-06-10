import CoreMedia
import CoreML
import UIKit
import Vision

class ViewController: UIViewController {
    
    let maxBoundingBoxViews = 10
    let lengthSeconds = 10
    let stopOverSeconds = 5
    let coreMLModel = MobileNetV2_SSDLite()
    
    lazy var predictor: Predictor = {
        let predictorML = Predictor(coreMLModel: coreMLModel)
        predictorML.delegate = self
        return predictorML
    }()
    
    lazy var imageView: UIImageView = UIImageView()
    
    var stopFrameNum: Int = 0
    
    var frames: [UIImage] = []
    
    var boundingBoxViews = [BoundingBoxView]()
    
    var colors: [String: UIColor] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        (boundingBoxViews, colors) = createMLBoundingBox(maxBoundingBox: maxBoundingBoxViews)
    }
    
    @IBAction func tapLoadFile(_ button: UIButton) {
        guard let fileURL = FileLoader.loadURLPath() else { return }
        button.isEnabled = false
        frames = []
        stopFrameNum = 0
        let queue = DispatchQueue(label: "loadFileQueue", attributes: .concurrent)
        queue.async {
            AssetReader.shared.read(url: fileURL, mediaType: .video, outputBuffer: { [weak self] in self?.predictor.predict(sampleBuffer: $0) }) { [weak self] in
                guard let self = self else { return }
                if $0 {
                    var settings = RenderSettings()
                    settings.fps = Int32(self.frames.count / self.lengthSeconds)
                    let imageAnimator = ImageAnimator(settings: settings, images: self.frames)
                    imageAnimator.render() {
                        self.view.showToast(text: "Video saved successfully")
                        button.isEnabled = true
                    }

                }
            }
        }
    }
}

extension ViewController: PredictDelegate {
    
    func processObservations(from pixelBuffer: CVPixelBuffer?, for request: VNRequest, error: Error?) {
        guard let image = pixelBuffer?.image else { return }
        DispatchQueue.main.async {
            if let imageView = self.view.subviews.last as? UIImageView {
                imageView.image = image
            }
            
            if let results = request.results as? [VNRecognizedObjectObservation] {
                self.show(predictions: results)
                self.stopFrameNum = 0
            }else {
                self.show(predictions: [])
                self.stopFrameNum += 1
            }
        }
    }
    
    func show(predictions: [VNRecognizedObjectObservation]) {
        for i in 0..<boundingBoxViews.count {
            if i < predictions.count {
                let prediction = predictions[i]
                
                /*
                 The predicted bounding box is in normalized image coordinates, with
                 the origin in the lower-left corner.
                 
                 Scale the bounding box to the coordinate system of the video preview,
                 which is as wide as the screen and has a 16:9 aspect ratio. The video
                 preview also may be letterboxed at the top and bottom.
                 
                 Based on code from https://github.com/Willjay90/AppleFaceDetection
                 
                 NOTE: If you use a different .imageCropAndScaleOption, or a different
                 video resolution, then you also need to change the math here!
                 */
                
                let width = view.bounds.width
                let height = width * 16 / 9
                let offsetY = (view.bounds.height - height) / 2
                let scale = CGAffineTransform.identity.scaledBy(x: width, y: height)
                let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -height - offsetY)
                let rect = prediction.boundingBox.applying(scale).applying(transform)
                
                // The labels array is a list of VNClassificationObservation objects,
                // with the highest scoring class first in the list.
                let bestClass = prediction.labels[0].identifier
                let confidence = prediction.labels[0].confidence
                
                // Show the bounding box.
                let label = String(format: "%@ %.1f", bestClass, confidence * 100)
                let color = colors[bestClass] ?? UIColor.red
                boundingBoxViews[i].show(frame: rect, label: label, color: color)
                guard stopFrameNum < AssetReader.shared.fps * stopOverSeconds
                else { return }
                self.frames.append(view.renderImage)
            } else {
                boundingBoxViews[i].hide()
            }
        }
    }
    
}
