import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class DateUtils
{
  
  static String getFormattedDate(DateTime date)
  {
    final now = DateTime.now();
    final aDate = DateTime(date.year, date.month, date.day);

    if(aDate == DateTime(now.year, now.month, now.day)) 
    {
      return("Today");
    } 
    else if (aDate == DateTime(now.year, now.month, now.day + 1)) 
    {
      return("Tomorrow");
    }
    else
    {
      return(_getWeekdayShort(aDate.weekday, Platform.localeName.split('_')[0]));
    }
  }

  static List<String> _weekDays(String localeName) 
  {    
    initializeDateFormatting(localeName);
    DateFormat formatter = DateFormat(DateFormat.WEEKDAY, localeName);
    return [DateTime(2000, 1, 3, 1), DateTime(2000, 1, 4, 1), DateTime(2000, 1, 5, 1),
      DateTime(2000, 1, 6, 1), DateTime(2000, 1, 7, 1), DateTime(2000, 1, 8, 1),
      DateTime(2000, 1, 9, 1)].map((day) => formatter.format(day)).toList();
  }

  static String _getWeekdayShort(int weekday, String localeName) => _weekDays(localeName)[weekday-1];
}
