//
//  CalendarView.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/09.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var selectedDate = Date()
    @State private var currentMonth = 0
    private let today = Date()
    private let taxiParties: [TaxiParty] = []

    var body: some View {
        VStack {
            header
            datePicker
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - view property

    var header: some View {
        var navigation: some View {
            HStack {
                Text("\(currentDate.formattedString)")
                Spacer()
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 10)
            .onChange(of: currentMonth) {newValue in
                currentDate = changeCurrentMonth()
            }
        }

        var dayOfWeek: some View {
            let days = ["일", "월", "화", "수", "목", "금", "토"]
            return HStack {
                ForEach(days, id: \.self) {day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                }
            }
        }

        return VStack {
                navigation
                dayOfWeek
            }
        }

    var datePicker: some View {
        let column = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: column) {
            ForEach(getExactDates()) {data in
                dayCell(data)
                    .background(
                        Circle()
                            .opacity(data.date.isSameDay(selectedDate) ? 1 : 0)
                    )
                    .onTapGesture {
                        selectedDate = data.date
                    }
            }
        }
    }

    // MARK: - function

    // 화살표 이동에 따른 달 이동
    private func changeCurrentMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: currentMonth, to: Date()) ?? Date()
    }

    // 해당 달 에서의 날짜 계산
    private func getExactDates() -> [DayContainer] {
        let calendar = Calendar.current
        let current = changeCurrentMonth()
        let components = calendar.dateComponents([.year, .month], from: current)

        let firstDayIndexOfWeek = calendar.component(.weekday, from: calendar.date(from: components) ?? Date())

        var thisMonthDates = currentDate.getMonthDates().map { date in
            DayContainer(day: date.day, date: date, monthType: .participable)
        }

        for _ in 0..<firstDayIndexOfWeek - 1 {
            thisMonthDates.insert(DayContainer(day: 0, date: Date(), monthType: .unparticipable), at: 0)
        }

        return thisMonthDates
    }

    // MARK: - view maker
    private func dayCell(_ value: DayContainer) -> some View {
        VStack {
            if value.day != 0 {
                if let taxiParty = taxiParties.first(where: {party in
                    return value.date.isSameDay(party.meetingDate.intToDate())
                }
                ) {
                    Text("\(taxiParty.meetingDate)")
                } else {
                    ZStack {
                        Circle()
                            .strokeBorder(value.date.isToday() ? .green : .clear, lineWidth: 2)
                        Text("\(value.day)")
                            .frame(maxWidth: .infinity, alignment: .top)
                            .foregroundColor(value.date.isSameDay(selectedDate) ? .white : .black)
                    }
                }
            }
        }
        .frame(height: 50)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
