# Introduction
ObjectDetection is a testing CoreML iOS APP and it can be used to detect the person in video file.


# Step
1. [ViewController](#ViewController)
2. [FileLoader](#FileLoader)
3. [AssetReader](#AssetReader)
4. [Predictor](#Predictor)
5. [VideoWrite and ImageAnimator](#Videowrite-and-Imageanimator)
6. [PhotoLibrary](#PhotoLibrary)

### ViewController
- Initialize the result image view and detected bounding boxes UI.
- Input file by FileLoader and show the ML detection result after AssetReader.
- Only save the images that persons are detected.
- Determine the fps by the fix output duration and trigger ImageAnimator to render picture.
- Stop video recording after no one has been detected for a while.
- Show the finished toast finally.

### FileLoader
- Fetch the local mp4 file from Bundle.

### AssetReader
- Read the asset media file by AVAssetReader and call the function startReading() to output CMSampleBuffers.  
- Assign the input video fps for stopping the record when no more person detected later.

### Predictor
- Refer to [Reference](#Reference), we can get the training model coreMLModel from MobileNetV2_SSDLite and predict the item detection result.

### VideoWrite and ImageAnimator
- Refer to [Reference](#Reference), using the AVAssetWriter and AVAssetWriterInput to add images into video file.
- ImageAnimator can be used to control the writing process, when the rendering completed it will callback to the view controller.

### PhotoLibrary
- Request the app photos authorization and save the media file into app.

# Requirements
* Swift 5.0
* iOS 11+

# Reference
[ObjectDetection](https://github.com/hollance/coreml-survival-guide/tree/master/MobileNetV2%2BSSDLite)  
[ExportImagesToVideo](https://stackoverflow.com/questions/3741323/how-do-i-export-uiimage-array-as-a-movie) 

## Author

minyingwu, minyingwu123@gmail.com


## License

ObjectDetection is available under the MIT license. See the LICENSE file for more info.
