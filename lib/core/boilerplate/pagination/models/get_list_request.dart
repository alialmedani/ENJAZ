
class GetListRequest {
  int? skip;
  int? take;

  GetListRequest({
    this.skip,
    this.take,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (skip != null) data['skip'] = skip;
    if (take != null) data['take'] = take;
    return data;
  }
}
