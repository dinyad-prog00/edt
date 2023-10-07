extension StringExtension on String {
  capitalize(){
    return substring(0,1).toUpperCase() + substring(1);
  }
}