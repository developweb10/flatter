import 'package:intl/intl.dart';

String timeAgoSinceDate(DateTime date1, {bool numericDates = true}) {
  DateTime date = date1;
  final date2 = DateTime.now();
  final difference = date2.difference(date);

  if ((difference.inDays / 365).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} years ago';
  } else if ((difference.inDays / 365).floor() >= 1) {
    return (numericDates) ? '1 year ago' : 'Last year';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return '${(difference.inDays / 365).floor()} months ago';
  } else if ((difference.inDays / 30).floor() >= 1) {
    return (numericDates) ? '1 month ago' : 'Last month';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return '${(difference.inDays / 7).floor()} weeks ago';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? '1 week ago' : 'Last week';
  } else if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? '1 day ago' : 'Yesterday';
  } else if (difference.inHours >= 2) {
    return '${difference.inHours} hours ago';
  } else if (difference.inHours >= 1) {
    return (numericDates) ? '1 hour ago' : 'An hour ago';
  } else if (difference.inMinutes >= 2) {
    return 'A few minutes ago';
  } else if (difference.inMinutes >= 1) {
    return (numericDates) ? '1 minute ago' : 'A minute ago';
  } else if (difference.inSeconds >= 3) {
    return 'A few seconds ago';
  } else {
    return 'Just now';
  }
}

String conversationTimestamp(DateTime date1, ) {
  
  final date2 = DateTime.now().toUtc();
  // print(date1);
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  // DateTime date = dateFormat.parse(date1.toString(), true);
 
  final difference = date2.difference(date1);
   DateFormat timeFormat = DateFormat.jm();

  if (difference.inDays >= 2) {
    return dateFormat.format(date1);
  } else if (difference.inDays >= 1) {
    return  'Yesterday';
  } else {
    return timeFormat.format(date1);
  }
}
