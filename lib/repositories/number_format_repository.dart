
class NumberFormatRepository {

     String  changeNumber(String number){
    number = number.replaceAll(RegExp(r'\D+'), '');
    return number;
  }

  
}