//
//  Bank.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

enum Bank: String, CaseIterable {
    case toss = "토스뱅크"
    case nh = "NH농협"
    case kb = "KB국민"
    case kakao = "카카오뱅크"
    case sinhan = "신한"
    case woori = "우리"
    case ibk = "IBK기업"
    case hana = "하나"
    case saemaeul = "새마을"
    case busan = "부산"
    case daegu = "대구"
    case kbank = "케이뱅크"
    case sinhyup = "신협"
    case post = "우체국"
    case sc = "SC제일"
    case bnk = "경남"
    case sh = "수협"
    case kj = "광주"
    case jeonbook = "전북"
    case save = "저축은행"
    case citi = "씨티"
    case jeju = "제주"
    case kdb = "KDB산업"
    case sbi = "SBI저축은행"
    case sanrim = "산림조합"
    case boa = "BOA"
    case hsbc = "HSBC"
    case china = "중국"
    case doichi = "도이치"
    case future = "미래에셋"
    case kium = "키움"
    case kakaopay = "카카오페이증권"
    case kbj = "KB증권"
    case sinhani = "신한투자"
    case koreai = "한국투자"
    case daesin = "대신"
    case nhi = "NH투자"
    case samsung = "삼성증권"
    case youanta = "유안타"
    case meritz = "메리츠증권"
    case tossi = "토스증권"
    case sinyoung = "신영"
    case hanai = "하나증권"
    case hanhwa = "한화투자"
    case sk = "SK"
    case ibki = "IBK투자"
    case kyobo = "교보"
}

#if canImport(SwiftUI)
import SwiftUI
// MARK: - Image
extension Bank {
    var image: Image {
        switch self {
        default: return Image(systemName: "dollarsign")
        }
    }
}
#endif
