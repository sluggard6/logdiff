class FileTool {
  static int readDateTime(String datetime) {
    return DateTime.parse(datetime.replaceAll("/", "-")).millisecondsSinceEpoch;
  }
}

void main() async {
  print(FileTool.readDateTime("2020/01/01 00:00:00.235"));
}
