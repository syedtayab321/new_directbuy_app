class FilterOptions {
  final double? minPrice;
  final double? maxPrice;
  final double? minCostPrice;
  final double? maxCostPrice;
  final double? minRating;
  final List<String> selectedCategories;
  final List<String> statuses; // Changed from selectedStatuses
  final bool inStockOnly;
  final bool onSaleOnly;

  FilterOptions({
    this.minPrice,
    this.maxPrice,
    this.minCostPrice,
    this.maxCostPrice,
    this.minRating,
    this.selectedCategories = const [],
    this.statuses = const ['published'], // Changed from selectedStatuses
    this.inStockOnly = false,
    this.onSaleOnly = false,
  });

  FilterOptions copyWith({
    double? minPrice,
    double? maxPrice,
    double? minCostPrice,
    double? maxCostPrice,
    double? minRating,
    List<String>? selectedCategories,
    List<String>? statuses, // Changed from selectedStatuses
    bool? inStockOnly,
    bool? onSaleOnly,
  }) {
    return FilterOptions(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minCostPrice: minCostPrice ?? this.minCostPrice,
      maxCostPrice: maxCostPrice ?? this.maxCostPrice,
      minRating: minRating ?? this.minRating,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      statuses: statuses ?? this.statuses, // Changed from selectedStatuses
      inStockOnly: inStockOnly ?? this.inStockOnly,
      onSaleOnly: onSaleOnly ?? this.onSaleOnly,
    );
  }
}