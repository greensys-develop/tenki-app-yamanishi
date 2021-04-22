//
//  TableViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/12.
//

import UIKit

class TableViewController: UITableViewController {
    
    var isWeeklyWeather = false
    var dailyList: [Daily] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isWeeklyWeather {
            return dailyList.count
         } else {
             return prefecture.count
         }
    }
    
    // セルに都道府県を表示
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isWeeklyWeather {
            // 週間の日付セルを表示
            cell.textLabel?.text = unixToString(date: TimeInterval(dailyList[indexPath.row].dt))
        } else {
            // 都道府県のセルを表示
            cell.textLabel!.text = prefecture[indexPath.row].name
        }
        return cell
    }
    
    // Cell が選択された場合
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "WeatherDetail", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "WeatherDetail") as! WeatherDetailViewController
        if isWeeklyWeather {
            // 週間天気のセルを選択された時の処理
            nextView.dailySelectedItem = dailyList[indexPath.row]
            nextView.dateStr = unixToString(date: TimeInterval(dailyList[indexPath.row].dt))
        } else {
            // 都道府県のセルを選択された時の処理
            nextView.selectedItem = prefecture[indexPath.row]
            
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
