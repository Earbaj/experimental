class CalculateCount{
  double calculateVat(double amount) {
    if (amount < 0) return 0;
    return amount * 0.10;
  }
}