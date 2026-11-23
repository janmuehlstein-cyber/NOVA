import Foundation
import EventKit

@MainActor
final class AppleCalendarService {
    private let store = EKEventStore()
    private let iso = ISO8601DateFormatter()
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    private let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "HH:mm"
        return f
    }()

    func perform(action: String, payload: [String: Any]) async throws -> [String: Any] {
        switch action {
        case "status":
            return ["connected": EKEventStore.authorizationStatus(for: .event) == .fullAccess]
        case "requestAccess":
            let granted = try await store.requestFullAccessToEvents()
            guard granted else { throw CalendarBridgeError.permissionDenied }
            return ["connected": true]
        case "listEvents":
            try await ensureFullAccess()
            guard let startText = payload["start"] as? String,
                  let endText = payload["end"] as? String,
                  let start = iso.date(from: startText), let end = iso.date(from: endText) else {
                throw CalendarBridgeError.invalidDate
            }
            let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
            let events = store.events(matching: predicate).sorted { $0.startDate < $1.startDate }
            return ["events": events.map(mapEvent)]
        case "createEvent":
            try await ensureFullAccess()
            let event = try makeEvent(payload: payload)
            try store.save(event, span: .thisEvent, commit: true)
            return ["externalId": event.eventIdentifier ?? ""]
        case "updateEvent":
            try await ensureFullAccess()
            guard let externalId = payload["externalId"] as? String,
                  let event = store.event(withIdentifier: externalId) else { throw CalendarBridgeError.eventNotFound }
            try apply(payload: payload, to: event)
            try store.save(event, span: .thisEvent, commit: true)
            return ["externalId": event.eventIdentifier ?? externalId]
        case "deleteEvent":
            try await ensureFullAccess()
            guard let externalId = payload["externalId"] as? String,
                  let event = store.event(withIdentifier: externalId) else { throw CalendarBridgeError.eventNotFound }
            try store.remove(event, span: .thisEvent, commit: true)
            return ["deleted": true]
        default:
            throw CalendarBridgeError.unknownAction
        }
    }

    private func ensureFullAccess() async throws {
        guard EKEventStore.authorizationStatus(for: .event) == .fullAccess else {
            throw CalendarBridgeError.permissionDenied
        }
    }

    private func makeEvent(payload: [String: Any]) throws -> EKEvent {
        let event = EKEvent(eventStore: store)
        try apply(payload: payload, to: event)
        event.calendar = store.defaultCalendarForNewEvents
        return event
    }

    private func apply(payload: [String: Any], to event: EKEvent) throws {
        guard let title = payload["title"] as? String,
              let day = payload["date"] as? String,
              let date = dateFormatter.date(from: day) else { throw CalendarBridgeError.invalidDate }
        let allDay = payload["allDay"] as? Bool ?? false
        var start = date
        if !allDay, let time = payload["time"] as? String {
            let parts = time.split(separator: ":").compactMap { Int($0) }
            if parts.count == 2 {
                start = Calendar.current.date(bySettingHour: parts[0], minute: parts[1], second: 0, of: date) ?? date
            }
        }
        event.title = title
        event.location = payload["location"] as? String
        event.notes = payload["note"] as? String
        event.isAllDay = allDay
        event.startDate = start
        event.endDate = allDay
            ? Calendar.current.date(byAdding: .day, value: 1, to: date)!
            : Calendar.current.date(byAdding: .hour, value: 1, to: start)!
    }

    private func mapEvent(_ event: EKEvent) -> [String: Any] {
        [
            "externalId": event.eventIdentifier ?? UUID().uuidString,
            "title": event.title ?? "(Ohne Titel)",
            "date": dateFormatter.string(from: event.startDate),
            "time": event.isAllDay ? "" : timeFormatter.string(from: event.startDate),
            "allDay": event.isAllDay,
            "location": event.location ?? "",
            "note": event.notes ?? ""
        ]
    }
}

enum CalendarBridgeError: LocalizedError {
    case permissionDenied, invalidDate, eventNotFound, unknownAction
    var errorDescription: String? {
        switch self {
        case .permissionDenied: return "Kein Zugriff auf Apple Kalender. Bitte erlaube den Kalenderzugriff in den iPhone-Einstellungen."
        case .invalidDate: return "Das Datum oder der Termin ist ungültig."
        case .eventNotFound: return "Der Apple-Kalendertermin wurde nicht gefunden. Bitte synchronisieren und erneut versuchen."
        case .unknownAction: return "Unbekannte Kalenderaktion."
        }
    }
}
