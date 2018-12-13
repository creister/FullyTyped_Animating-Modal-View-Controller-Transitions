import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {

  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private let reuseId = "Cell"

class EmojiViewController: UICollectionViewController {

  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let emojis = (0x1F601...0x1F64F).map { String(UnicodeScalar($0)!) }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .black

    let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
    flowLayout.itemSize = CGSize(width: 44, height: 44)
    collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
  }
}

// MARK: UICollectionViewDataSource
extension EmojiViewController {

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return emojis.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! EmojiCollectionViewCell
    cell.label.text = emojis[indexPath.row]
    return cell
  }

}

// MARK: UICollectionViewDelegate
extension EmojiViewController {

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let emoji = emojis[indexPath.row]
    print("TODO: present emoji detail with: \(emoji)")
  }

}
