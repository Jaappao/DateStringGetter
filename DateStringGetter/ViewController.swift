//
//  ViewController.swift
//  DateStringGetter
//
//  Created by Jaappao on 2023/01/13.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    
    var timeBegin: Int = 10
    var timeEnd: Int = 18
    var interval: Int = 30
    var dates: Int = 7
    
    let howManyColumnsWithinDisplay: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView!.register(nib, forCellWithReuseIdentifier: "EachCell")
        collectionView.allowsMultipleSelection = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // init variables
        timeBegin = 10
        timeEnd = 18
        interval = 30
        dates = 7
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getCellNum()
    }
    
    func getTimeDurationOfDay() -> Int {
        return timeEnd - timeBegin
    }
    
    func getRowNum() -> Int {
        return ((timeEnd - timeBegin) * 60) / interval
    }
    
    func getCellHeight(_ collectionViewHeight: CGFloat) -> CGFloat {
        return collectionViewHeight / CGFloat(getRowNum())
    }
    
    func getCellNum() -> Int {
        return dates * getRowNum()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EachCell", for: indexPath) as? EachCell
        else {
            fatalError()
        }
        cell.setup()

        //セル上のTag(1)とつけたUILabelを生成
        let label = cell.contentView.viewWithTag(1) as! UILabel

        let textOfCell = "\(indexPath.row / getRowNum()) \(indexPath.row % getRowNum())"
        label.text = textOfCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight = self.collectionView.bounds.height
        let collectionViewWidth = self.collectionView.bounds.width
        
        let horizontalSpace:CGFloat = 5

        // デバイスの横幅をn分割した横幅　- セル間のスペース*2（セル間のスペースが二つあるため）
        let cellWidth : CGFloat = collectionViewWidth / CGFloat(howManyColumnsWithinDisplay) - horizontalSpace*2
        let cellHeight: CGFloat = getCellHeight(collectionViewHeight) - horizontalSpace*2

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // セル選択時の更新
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        displayDateString(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        displayDateString(indexPath: indexPath)
    }
    
    func displayDateString(indexPath: IndexPath) {
        var indexArray: [Int] = []
        collectionView.indexPathsForSelectedItems?.forEach({ IndexPath in
            indexArray.append(IndexPath.row)
        })
        indexArray.sort()
        textView.text = "\(indexArray)"
    }

}
