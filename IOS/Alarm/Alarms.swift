import Foundation

class Alarms: Codable {
    private var alarms: [Alarm]
    
    enum CodingKeys: CodingKey {
        case alarms
    }
    
    required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Alarms.CodingKeys> = try decoder.container(keyedBy: Alarms.CodingKeys.self)
        
        self.alarms = try container.decode([Alarm].self, forKey: Alarms.CodingKeys.alarms)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<Alarms.CodingKeys> = encoder.container(keyedBy: Alarms.CodingKeys.self)
        
        try container.encode(self.alarms, forKey: Alarms.CodingKeys.alarms)
    }
    
    
    func add(_ alarm: Alarm) {
        alarms.append(alarm)
        let newIndex = alarms.index { $0 === alarm }!
        Store.shared.save(alarm, userInfo: [
            Alarm.changeReasonKey: Alarm.added,
            Alarm.newValueKey: newIndex
        ])
    }
    
    func remove(_ alarm: Alarm) {
        guard let index = alarms.index(where: { $0 === alarm }) else { return }
        remove(at: index)
    }
    
    func remove(at index: Int) {
        alarms.remove(at: index)
        Store.shared.remove(alarms[index], userInfo: [
            Alarm.changeReasonKey: Alarm.removed,
            Alarm.oldValueKey: index
        ])
    }
    
    var count: Int {
        return alarms.count
    }
    
    subscript(index: Int) -> Alarm {
        return alarms[index]
    }
    
}
