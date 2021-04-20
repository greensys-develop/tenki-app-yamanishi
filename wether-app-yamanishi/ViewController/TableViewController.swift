//
//  TableViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/12.
//

import UIKit

class TableViewController: UITableViewController {
    
    var flag = 0
    var tableCountNum = 0
    var coordinate: Coordinate = (lat: 0.0, lon: 0.0)
    var weeklyLists: [(dt: Int, dateStr: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag == 0 {
            tableCountNum = prefecture.count
        }
        return tableCountNum
    }
    
    // セルに都道府県を表示
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if flag == 0 {
            // 都道府県のセルを表示
            cell.textLabel!.text = prefecture[indexPath.row].name
        } else if flag == 1 {
            // 週間の日付セルを表示
            cell.textLabel?.text = weeklyLists[indexPath.row].dateStr
        }
        return cell
    }
    
    // Cell が選択された場合
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "WeatherDetail", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "WeatherDetail") as! WeatherDetailViewController
        if flag == 0 {
            // 都道府県のセルを選択された時の処理
            nextView.selectedItem = prefecture[indexPath.row]
        } else if flag == 1 {
            // 週間天気のセルを選択された時の処理
            nextView.weeklySelectedItem = weeklyLists[indexPath.row]
        }
        self.present(nextView, animated: true, completion: nil)
    }
    
    func unixToString(date: TimeInterval) -> String {
        // UNIX時間 "dateUnix" をNSDate型 "date" に変換
        let dateUnix: TimeInterval = TimeInterval(date)
        let date = NSDate(timeIntervalSince1970: dateUnix)
        
        // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
        let dateStr: String = formatter.string(from: date as Date)
        
        return dateStr
    }

}
