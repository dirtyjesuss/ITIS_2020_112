//
//  LargeImageDetailViewController.swift
//  ImageLoadingProject
//
//  Created by Ruslan Khanov on 28.11.2020.
//

import UIKit

class LargeImageDetailViewController: UIViewController, URLSessionDownloadDelegate {

    var imageSource: String?
    
    @IBOutlet private var largeImageView: UIImageView! {
        didSet {
            largeImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let source = imageSource {
            if let imageURL = getURLFrom(string: source) {
                download(from: imageURL)
            }
        }
    }
    
    // MARK: Download image from url
    private func download(from url: URL) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // MARK: Prepare URL from string
    private func getURLFrom(string: String) -> URL? {
        return URL(string: string)
    }
    
    // MARK: Tracking download progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let downloadedProgressValue = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.progressView.setProgress(downloadedProgressValue, animated: true)
        }
    }
    
    // MARK: Tracking download completion
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let data = readDownloadedData(of: location)
        setImageToLargeImageView(from: data)
    }
    
    // MARK: Read downloaded data
    private func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    private func getUIImageFrom(data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    // MARK: Set image to largeImageView
    private func setImageToLargeImageView(from data: Data?) {
        guard let imageData = data else {
            return
        }
        guard let image = getUIImageFrom(data: imageData) else {
            return
        }
        
        DispatchQueue.main.async {
            self.progressView.isHidden = true
            self.largeImageView.image = image
        }
    }
}
