class FilterMonthYearDto {
  FilterMonthYearDto({
    this.month,
    this.year,
  });
  final int? month;
  final int? year;

  Map<String, dynamic> toJson() => {
    if (month != null) 'month': month,
    if (year != null) 'year': year,
  };
}
