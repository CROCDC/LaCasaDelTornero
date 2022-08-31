abstract class UiStatus {}

class UiLoading extends UiStatus {}

class UiError extends UiStatus {}

class UiListing<T> extends UiStatus {
  List<T> list;

  UiListing(this.list);
}
