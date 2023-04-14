class HeaderPagination {
  int? total;
  int? totalPages;
  bool? firstPage;
  bool? lastPage;
  int? previousPage;
  int? nextPage;

  HeaderPagination(
      {this.total,
      this.totalPages,
      this.firstPage,
      this.lastPage,
      this.previousPage,
      this.nextPage});

  HeaderPagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    totalPages = json['total_pages'];
    firstPage = json['first_page'];
    lastPage = json['last_page'];
    previousPage = json['previous_page'];
    nextPage = json['next_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['total_pages'] = totalPages;
    data['first_page'] = firstPage;
    data['last_page'] = lastPage;
    data['previous_page'] = previousPage;
    data['next_page'] = nextPage;
    return data;
  }
}
