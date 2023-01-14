//
//  ViewController.swift
//  DateStringGetter
//
//  Created by Jaappao on 2023/01/13.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var bodyCollectionView: UICollectionView!
    @IBOutlet var leftCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    
    var timeBegin: Int = 10
    var timeEnd: Int = 18
    var interval: Int = 30
    var dates: Int = 7
    
    let howManyColumnsWithinBody: Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nibHeader = UINib(nibName: "CollectionViewHeaderCell", bundle: nil)
        bodyCollectionView!.register(nibHeader, forCellWithReuseIdentifier: "HeaderCell")
        leftCollectionView!.register(nibHeader, forCellWithReuseIdentifier: "HeaderCell")
        
        let nibBody = UINib(nibName: "BodyCollectionViewCell", bundle: nil)
        bodyCollectionView!.register(nibBody, forCellWithReuseIdentifier: "BodyEachCell")
        bodyCollectionView.allowsMultipleSelection = true
        
        let nibLeft = UINib(nibName: "LeftCollectionViewCell", bundle: nil)
        leftCollectionView!.register(nibLeft, forCellWithReuseIdentifier: "LeftEachCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // init variables
        timeBegin = 10
        timeEnd = 18
        interval = 30
        dates = 7
    }
    
    func getTimeDurationOfDay() -> Int {
        return timeEnd - timeBegin
    }
    
    func getRowNum() -> Int {
        return (((timeEnd - timeBegin) * 60) / interval) + 1
    }
    
    func getCellHeight(_ collectionViewHeight: CGFloat) -> CGFloat {
        return collectionViewHeight / CGFloat(getRowNum())
    }
    
    func getCellNum() -> Int {
        return dates * getRowNum()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.bodyCollectionView {
            return getCellNum()
        } else {
            return getRowNum()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row % getRowNum() == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as? CollectionViewHeaderCell
            else {
                fatalError()
            }
            
            let label = cell.contentView.viewWithTag(1) as! UILabel
            label.text = "\(indexPath.row / getRowNum())"
            
            return cell
        } else {
            // body
            if collectionView == self.bodyCollectionView {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyEachCell", for: indexPath) as? bodyCollectionViewCell
                else {
                    fatalError()
                }
                cell.setup()
                
                //セル上のTag(1)とつけたUILabelを生成
                let label = cell.contentView.viewWithTag(1) as! UILabel
                
                let textOfCell = "\(indexPath.row / getRowNum()) \(indexPath.row % getRowNum())"
                label.text = textOfCell
                
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeftEachCell", for: indexPath) as? LeftCollectionViewCell
                else {
                    fatalError()
                }
                
                //セル上のTag(1)とつけたUILabelを生成
                let label = cell.contentView.viewWithTag(1) as! UILabel
                
                let textOfCell = "\(indexPath.row / getRowNum()) \(indexPath.row % getRowNum())"
                label.text = textOfCell
                
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.bodyCollectionView {
            let collectionViewHeight = self.bodyCollectionView.bounds.height
            let collectionViewWidth = self.bodyCollectionView.bounds.width
            
            let horizontalSpace:CGFloat = 5

            // デバイスの横幅をn分割した横幅　- セル間のスペース*2（セル間のスペースが二つあるため）
            let cellWidth : CGFloat = collectionViewWidth / CGFloat(howManyColumnsWithinBody) - horizontalSpace*2
            let cellHeight: CGFloat = getCellHeight(collectionViewHeight) - horizontalSpace*2

            return CGSize(width: cellWidth, height: cellHeight)
        } else {
            let collectionViewHeight = self.leftCollectionView.bounds.height
            let collectionViewWidth = self.leftCollectionView.bounds.width
            
            let horizontalSpace:CGFloat = 5

            // デバイスの横幅をn分割した横幅　- セル間のスペース*2（セル間のスペースが二つあるため）
            let cellWidth : CGFloat = collectionViewWidth - horizontalSpace*2
            let cellHeight: CGFloat = getCellHeight(collectionViewHeight) - horizontalSpace*2

            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
    // セル選択時の更新
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return (indexPath.row % getRowNum()) != 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.bodyCollectionView {
            displayDateString(indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.bodyCollectionView {
            displayDateString(indexPath: indexPath)
        }
    }
    
    func displayDateString(indexPath: IndexPath) {
        var indexArray: [Int] = []
        bodyCollectionView.indexPathsForSelectedItems?.forEach({ IndexPath in
            indexArray.append(IndexPath.row)
        })
        indexArray.sort()
        textView.text = "\(indexArray)"
    }

}
