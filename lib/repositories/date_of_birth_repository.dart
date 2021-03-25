


class DateOfBirthRepository{

     String  changeDOB(DateTime dob){
       return  dob.month.toString() +  "/" + dob.day.toString() + "/"  + dob.year.toString();
  }

  
}