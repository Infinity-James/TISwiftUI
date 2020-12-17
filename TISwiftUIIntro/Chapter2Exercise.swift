//
//  Chapter2Exercise.swift
//  TISwiftUIIntro
//
//  Created by James Valaitis on 06/12/2020.
//

import SwiftUI

//  MARK: Photo
private struct Photo: Decodable, Identifiable {
	let id: String
	let author: String
	let width: Int
	let height: Int
	let url: URL
	let downloadURL: URL
	
	private enum CodingKeys: String, CodingKey {
		case id
		case author
		case width
		case height
		case url
		case downloadURL = "download_url"
	}
}

//  MARK: Remote
private final class Remote<T: Decodable>: ObservableObject {
	let url: URL
	let transform: (Data) -> [T]
	@Published private(set) var items: [T]?
	
	init(url: URL, transform: @escaping (Data) -> [T]) {
		self.url = url
		self.transform = transform
	}
	
	func load() {
		let task = URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
			guard let data = data, error == nil else { return }
			DispatchQueue.main.async {
				self.items = self.transform(data)
			}
		}
		task.resume()
	}
}

//  MARK: Authors
public struct Authors: View {
	@ObservedObject private var remote = Remote(url: URL(string: "https://picsum.photos/v2/list")!, transform: { data -> [Photo] in
		let decoder = JSONDecoder()
		return try! decoder.decode([Photo].self, from: data)
	})
	
	public var body: some View {
		Group {
			if remote.items != nil {
				NavigationView {
					List(remote.items!) { photo in
						NavigationLink(photo.author, destination: PhotoView(photoURL: photo.downloadURL))
					}
				}
			} else {
				ProgressView()
			}
		}
		.onAppear { remote.load() }
	}
}

//  MARK: Photo View
private struct PhotoView: View {
	let photoURL: URL
	@State var photo: UIImage?
	
	var body: some View {
		Group {
			if photo == nil {
				ProgressView()
			} else {
				Image(uiImage: photo!)
					.resizable()
					.aspectRatio(contentMode: .fit)
			}
		}
		.onAppear {
			let task = URLSession.shared.dataTask(with: photoURL) { data, response, error in
				guard let data = data, error == nil else { return }
				self.photo = UIImage(data: data)
			}
			task.resume()
		}
	}
}

//  MARK: Preview
struct Chapter2Exercise_Previews: PreviewProvider {
	static var previews: some View {
		Authors()
	}
}
