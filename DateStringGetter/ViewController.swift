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
    
    var dateBegin: Date = Date()
    
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
        
        dateBegin = Date()
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
        let dateString = dateStringBuilder(indexArray)
        textView.text = "\(dateString)"
    }
    
    
    // 表示させる文字列を生成する処理
    func convertIndexPathsArrayToDateSeparated2DArray(_ selectedItems: [Int]) -> [[Int]] {
        // Ex)
        //   global:
        //     timeBegin = 10
        //     timeEnd = 18
        //     interval = 30
        //     dates = 7
        //     getRowNum()...17
        //   input: [24, 25, 42, 46, 47, 48, 49]
        //   Output: [[], [6, 7], [7, 11, 12, 13, 14], [], [], [], []]
        
        
        // 返り値初期化
        // 要素値は 「 interval分 をブロックとして、**その日の開始時刻から**何ブロック目か」 を示す headerも無視するために-1している
        // ExのOutput例における6という値は 10:00 から interval * 6 = 180 分後 のblockがselectedだったことを示す
        var dateSeparatedSelectedItems : [[Int]] = []
        for _ in 0 ..< dates {
            dateSeparatedSelectedItems.append([]) // dataSeparetedSelectedItemsを初期化
        }
        
        // 日別に分類する
        selectedItems.forEach { itemIdx in
            dateSeparatedSelectedItems[itemIdx / getRowNum()].append(itemIdx % getRowNum() - 1)
        }
        
        // ソートする
        for i in 0 ..< dates {
            dateSeparatedSelectedItems[i].sort()
        }
        
        return dateSeparatedSelectedItems
    }
    
    func printTimeOfBlock(_ blockVal: Int, offset: Int = 0) -> String {
        let offsetHours = (blockVal * interval + offset) / 60
        let offsetMinutes = (blockVal * interval + offset) % 60
        let beginTime = "\(timeBegin + offsetHours):\(String(format: "%02d", offsetMinutes))"
        return beginTime
    }
    
    func printBeginTimeOfBlock(_ blockVal: Int) -> String {
        return printTimeOfBlock(blockVal)
    }
    
    func printEndTimeOfBlock(_ blockVal: Int) -> String {
        return printTimeOfBlock(blockVal, offset: interval)
    }
    
    func printFrom2ToTime(fromBlockVal: Int, toBlockVal: Int) -> String {
        let fromStr = printBeginTimeOfBlock(fromBlockVal)
        let toStr = printEndTimeOfBlock(toBlockVal)
        return "\(fromStr)~\(toStr)"
    }
    
    func printDate(_ offset: Int = 0) -> String {
        let dateFormatter = DateFormatter()
        
        // フォーマット設定
//        dateFormatter.dateFormat = "yyyy'年'M'月'd'日('EEEEE') 'H'時'm'分's'秒'" // 曜日1文字
        dateFormatter.dateFormat = "M'月'd'日('EEE')'" // 曜日3文字

        // ロケール設定（日本語・日本国固定）
        dateFormatter.locale = Locale(identifier: "ja_JP")

        // タイムゾーン設定（日本標準時固定）
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")

        // 変換
        let targetDate = Calendar.current.date(byAdding: .day, value: offset, to: dateBegin)!
        let str = dateFormatter.string(from: targetDate)
        
        return str
    }
    
    // 表示文字列を組み立てるコード
    func dateStringBuilder(_ selectedItems: [Int]) -> String {
        let dateSeparatedSelectedItems = convertIndexPathsArrayToDateSeparated2DArray(selectedItems)
        print(dateSeparatedSelectedItems)
        
        var retVal: String = ""
        
        for idx_date in 0..<dateSeparatedSelectedItems.count {
            if dateSeparatedSelectedItems[idx_date].count != 0 {
                
                retVal += "\(printDate(idx_date)) "
                var fromBlockVal = -1
                for idx_block in 0..<dateSeparatedSelectedItems[idx_date].count {
                    if fromBlockVal == -1 {
                        fromBlockVal = dateSeparatedSelectedItems[idx_date][idx_block]  //
                    }
                    
                    let toBlockVal = dateSeparatedSelectedItems[idx_date][idx_block]
                    
                    // 右側を見て、連続値だったらcontinue, 連続値じゃなかったらそこまでの経過を文字列化
                    if idx_block == dateSeparatedSelectedItems[idx_date].count - 1 {
                        // 右を見る前に、終端の時かどうかチェック
                        // proceed concat
                        let timeString = printFrom2ToTime(fromBlockVal: fromBlockVal, toBlockVal: toBlockVal)
                        print("proceed \(idx_date):\(fromBlockVal)-\(toBlockVal) \(timeString)")
                        retVal += "\(timeString)"
                        fromBlockVal = -1
                    } else {
                        if toBlockVal + 1 ==  dateSeparatedSelectedItems[idx_date][idx_block + 1] {
                            // 右にある値が連続値の場合
                            continue
                        } else {
                            // 右にある値が連続値じゃない場合
                            // proceed concat
                            let timeString = printFrom2ToTime(fromBlockVal: fromBlockVal, toBlockVal: toBlockVal)
                            print("proceed \(idx_date):\(fromBlockVal)-\(toBlockVal) \(timeString)")
                            retVal += "\(timeString), "
                            fromBlockVal = -1
                        }
                            
                    }
                    
                }
            }
            retVal += "\n"
        }
        return retVal
    }

}
