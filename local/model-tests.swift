import Foundation
var snapshot = LimitSnapshot.placeholder
for (raw, name) in [("prolite", "Pro 5x"), ("pro", "Pro 20x"), ("plus", "Plus"), ("future", "future")] {
    snapshot.planType = raw
    assert(snapshot.planDisplayName == name)
}
snapshot.bankResetCount = 3
snapshot.bankResetUpdatedAt = Date()
assert(snapshot.bankResetText == "3")
snapshot.bankResetUpdatedAt = Date().addingTimeInterval(-301)
assert(snapshot.bankResetText == "--")
snapshot.bankResetCount = nil
assert(snapshot.bankResetText == "--")
let old = try JSONEncoder.codexLimitEncoder.encode(LimitSnapshot.placeholder)
let decoded = try JSONDecoder.codexLimitDecoder.decode(LimitSnapshot.self, from: old)
assert(decoded.bankResetCount == nil)
print("Plan mapping, freshness, unknown-state and snapshot compatibility passed")
var usage = LimitSnapshot.placeholder.usage!
usage.dailyTokens = [DailyTokenUsage(date: "2026-09-02", tokens: 12), DailyTokenUsage(date: "2026-09-08", tokens: 0)]
assert(usage.sevenDayTokens.count == 7)
assert(usage.sevenDayTokens.first?.date == "2026-09-02")
assert(usage.sevenDayTokens[1].tokens == nil)
assert(usage.sevenDayTokens.last?.tokens == 0)
let todayFormatter = DateFormatter()
todayFormatter.dateFormat = "yyyy-MM-dd"
usage.lastDailyDate = todayFormatter.string(from: Date())
assert(usage.latestDayLabel == "TODAY")
usage.lastDailyDate = "2001-01-01"
assert(usage.latestDayLabel == "LAST DAY")
print("Seven-day calendar range, missing vs zero, and today label passed")
