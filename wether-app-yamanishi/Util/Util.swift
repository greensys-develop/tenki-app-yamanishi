//
//  Util.swift
//  wether-app-yamanishi
//
//  Created by Mayumi Yamanishi on 2021/04/23.
//

import Foundation

class Util {
    static func unixToString(date: TimeInterval) -> String {
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
