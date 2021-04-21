//
//  TableViewController.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/12.
//

import UIKit

class TableViewController: UITableViewController {
    
    var isWeeklyWeather = false
    var weeklyLists: [(dt: Int, dateStr: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isWeeklyWeather {
             return weeklyLists.count
         } else {
             return prefecture.count
         }
    }
    
    // セルに都道府県を表示
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if isWeeklyWeather == false {
            // 都道府県のセルを表示
            cell.textLabel!.text = prefecture[indexPath.row].name
        } else {
            // 週間の日付セルを表示
            cell.textLabel?.text = weeklyLists[indexPath.row].dateStr
        }
        return cell
    }
    
    // Cell が選択された場合
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "WeatherDetail", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "WeatherDetail") as! WeatherDetailViewController
        if isWeeklyWeather == false {
            // 都道府県のセルを選択された時の処理
            nextView.selectedItem = prefecture[indexPath.row]
        } else {
            // 週間天気のセルを選択された時の処理
            nextView.weeklySelectedItem = weeklyLists[indexPath.row]
        }
        self.present(nextView, animated: true, completion: nil)
    }

}
