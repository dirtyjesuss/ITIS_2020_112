//
//  ViewController.swift
//  ImageLoadingProject
//
//  Created by Teacher on 16.11.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    enum Row {
        case image(title: String, urlString: String)
        case largeImage(title: String, previewUrlString: String, urlString: String)
    }

    private var rows: [Row] = [
        .image(
            title: "Guinea pig",
            urlString: "https://news.clas.ufl.edu/files/2020/06/AdobeStock_345118478-copy-1440x961-1.jpg"
        ),
        .largeImage(
            title: "Large satellite photo",
            previewUrlString: "https://ichef.bbci.co.uk/news/976/cpsprodpb/F3BC/production/_113769326_1.jpg",
            urlString: "https://www.dropbox.com/s/vylo8edr24nzrcz/Airbus_Pleiades_50cm_8bit_RGB_Yogyakarta.jpg?dl=1"
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ImageCell else {
            fatalError("Could not dequeue cell")
        }

        switch rows[indexPath.row] {
        case .image(title: let title, urlString: let urlString):
            cell.title = title
            cell.imageUrl = URL(string: urlString)
        case .largeImage(title: let title, previewUrlString: let previewUrlString, urlString: _):
            cell.title = title
            cell.imageUrl = URL(string: previewUrlString)
        default:
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        switch rows[indexPath.row] {
        case .largeImage(title: _, previewUrlString: _, urlString: let urlString):
            guard let largeImageDetailViewController: LargeImageDetailViewController = storyboard?.instantiateViewController(identifier: "LargeImageDetailViewController") else {
                return
            }
            largeImageDetailViewController.imageSource = urlString
            navigationController?.pushViewController(largeImageDetailViewController, animated: true)
        default:
            return
        }
    }
}

