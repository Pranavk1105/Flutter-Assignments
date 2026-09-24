double computeFine({required int overdueDays, double dailyRate = 2.0}) {
  if (overdueDays <= 0) {
    return 0.0;
  }
  return overdueDays * dailyRate;
}
