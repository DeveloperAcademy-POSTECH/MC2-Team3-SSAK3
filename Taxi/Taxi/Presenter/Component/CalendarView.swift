//
//  CalendarView.swift
//  Taxi
//
//  Created by sanghyo on 2022/06/14.
//

import SwiftUI

struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date?
    @State private var currentMonth = 0
    @State private var renderDate = Date()
    private let today = Date()
    private let taxiParties: [TaxiParty]
    private let action: (Bool, Date) -> Void
    private let days = ["일", "월", "화", "수", "목", "금", "토"]
    private let calendarHelper = CalendarHelper()

    init(taxiParties: [TaxiParty] = [], action: @escaping (Bool, Date) -> Void) {
        self.taxiParties = taxiParties
        self.action = action
    }

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                navigation
                dayOfWeek
            }
            datePicker
        }
    }

    // MARK: - view property
    var navigation: some View {
        HStack {
            Text("\(currentDate.formattedString)")
                .calendarTitle()
            Spacer()
            HStack(spacing: 40) {
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .calendarArrow()
                        .tint(currentMonth < 1 ? .customGray : .charcoal)
                }
                .disabled(currentMonth < 1)
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .calendarArrow()
                        .tint(currentMonth > 0 ? .customGray : .charcoal)
                }
                .disabled(currentMonth > 0)
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 10)
        .onChange(of: currentMonth) {_ in
            currentDate = calendarHelper.changeCurrentMonth(currentMonth)
        }
    }

    var dayOfWeek: some View {
        HStack {
            ForEach(days, id: \.self) {day in
                Text(day)
                    .calendarDay()
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var datePicker: some View {
        let column = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: column, spacing: 10) {
            ForEach(calendarHelper.getExactDates(currentMonth)) {data in
                makeDayCell(data)
                    .background(
                        ZStack {
                            Capsule()
                                .fill(data.date.isSameDay(selectedDate) ? Color.selectYellow : .clear)
                                .aspectRatio(2/3, contentMode: .fit)
                            Capsule()
                                .strokeBorder(data.date.isSameDay(selectedDate) ? Color.customYellow : todayCapsuleBorder(data.date, borderColor: Color.darkGray))
                                .aspectRatio(2/3, contentMode: .fit)
                        }
                    )
                    .onTapGesture {
                        selectedDate = data.date
                        guard let selectedDate = selectedDate else { return }
                        guard taxiParties.first(where: {party in
                            guard let convertedDate = Date.convertToDateFormat(from: party.meetingDate) else { return false }
                            return data.date.isSameDay(convertedDate)
                        }) == nil else {
                            action(true, selectedDate)
                            return
                        }
                        action(false, selectedDate)
                    }
                    .disabled(data.monthType == .unparticipable)
            }
        }
    }

    // MARK: - function
    private func todayCapsuleBorder(_ date: Date, borderColor: Color) -> Color {
        return date.isToday ? .gray : .clear
    }

    // MARK: - view maker
    private func makeDayCell(_ value: DayContainer) -> some View {
        VStack(spacing: 0) {
            if value.day != 0 {
                if taxiParties.first(where: {party in
                    guard let convertedDate = Date.convertToDateFormat(from: party.meetingDate) else { return false }
                    return value.date.isSameDay(convertedDate)
                }) != nil {
                    Text("\(value.day)")
                        .calendarDate()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(value.date.isOutOfMonth ? .customGray : .charcoal)
                    Circle()
                        .fill(Color.charcoal)
                        .opacity(value.date.isOutOfMonth ? 0 : 1)
                        .frame(width: 5, height: 5)
                        .padding(.top, 5)
                } else {
                    Text("\(value.day)")
                        .calendarDate()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(value.date.isOutOfMonth ? .customGray : .charcoal)
                }
            }
        }
        .padding(.top, 10)
        .frame(height: 50, alignment: .top)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView {bool, date in
            if bool {
                print("there is taxiParty \(date)")
            } else {
                print("there isn't taxiParty \(date)")
            }
        }
    }
}
