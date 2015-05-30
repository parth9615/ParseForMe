import sys
import re
from pprint import pprint


def getRawData(filename):

  f = open(filename, 'rU')              # Open and read the file. for read only
  rawListOfData = f.readlines()         # get each line as a list

  extractDates(rawListOfData)

def extractDates(rawListOfData):
  dayAndMonthList = ['Monday' , 'Tuesday' , 'Wednesday' , 'Thursday' , 'Friday', 'Saturday' , 'Sunday'
'Mondays' , 'Tuesdays' , 'Wednesdays' , 'Thursdays' , 'Fridays' ,'Saturdays' , 'Sundays' 'Mon' , 'Tue',
 'Wed' , 'Thur' , 'Fri' , 'Sat' , 'Sun' , 'January', 'February' , 'March' , 'April' , 'May' , 'June',
'July' , 'August' , 'September' , 'October' , 'November' , 'December' ,'Jan' , 'Feb' , 'Mar',
   'Apr' , 'May' , 'Jun' , 'Jul' , 'Aug' , 'Sep' , 'Oct' , 'Nov' , 'Dec'  ]
  relevantDates = []                    # make a list to hold all the dates
                                        # get all days and store in relevantDates
  extractDays(relevantDates , rawListOfData, dayAndMonthList)

'''
This method iterates through the rawListOfData to find patterns in the method
Current parsing methods included in the pattern
1: Finding a line that contains a day of the week
2: Finding a line that contains a time in the format ##:## (for ex 12:10 or 3:20)
3: Finding a line that contains a month of the year
4: Finding a line that contains a date in the format ##/##
todo : update this numeric list as more patterns are added:
'''
def extractDays(relevantDates , rawListOfData, dayAndMonthList):
    for individualLine in rawListOfData:  # iterate through each line
        for days in dayAndMonthList:              # iterate through each day combination
            # regex pattern to find the entire line that contains a day in the dayList
            dayOfTheWeekPattern = ('.+')+(days)+('\s.+')
            # regex flag to ingnorecase and make the dot include whitespace
            dayOfTheWeekFlags =   re.IGNORECASE | re.DOTALL
            # call findInString to check if such a pattern exists
            result = findInString(dayOfTheWeekPattern , individualLine , dayOfTheWeekFlags, relevantDates)
            if result:
                getSensibleDatesFromMonth(individualLine)

        # pattern to find the pattern ##:## which is commonly used to denote time
        clockTimePattern = ('.+\d:\d\d?.+')
        # flag to make the dot include whitespace
        clockTimeFlags   = re.DOTALL
        findInString(clockTimePattern , individualLine, clockTimeFlags , relevantDates)

        # pattern to find the pattern ##/## which is commonly used to denote dates
        dateTimePattern = ('.+\d/\d\d?.+')
        dateTimeFlags   = re.DOTALL
        findInString(dateTimePattern , individualLine , dateTimeFlags , relevantDates)
    pprint(relevantDates)

def getSensibleDatesFromMonth(stringToSearch):
    monthFound = ''
    dateFound = ''
    informationArroundDate = ''
    monthToNumDict = {'January' :1, 'February':2 , 'March':3 , 'April':4 , 'May':5, 'June' :6,
   'July':7 , 'August':8 , 'September':9 , 'October':10 , 'November':11 , 'December':12 ,'Jan':1 ,
    'Feb':2 , 'Mar':3, 'Apr':4 , 'May':5 , 'Jun':6 , 'Jul':7 , 'Aug':8 , 'Sep':9 , 'Oct':10 ,
     'Nov':11 , 'Dec':12}
    for month in monthToNumDict.keys():
        monthFound = re.search ('\s' + month , stringToSearch, re.IGNORECASE) # try to find a month
        if monthFound:

            monthIndex = stringToSearch.lower().find(month.lower()) # find the index of where the month is
            # try to find a date with a range of +- 10 chars from where the monthIndex was
            dateFound = re.search( '\d\d?' , stringToSearch[monthIndex - 10: monthIndex+10])
            #print 'the month = =====' , month , stringToSearch
            if dateFound:
                print 'the date is ' , str(monthToNumDict[month]) + '/' + dateFound.group()
                firstPart = stringToSearch[monthIndex - 25:monthIndex]
                secondPart = stringToSearch[monthIndex+1: monthIndex+50]
                print 'the date is ' , str(monthToNumDict[month]) + '/' + dateFound.group() + '[ ' ,firstPart , secondPart + ']'
                break



'''
patternToFind = regexExpression that the regular expression looks for
textToSearch  = the text to find the pattern in
flags         = any and all flags required for the paticular search
relevantDates = the list to store the line if pattern is matched
This method takes the patternToFind and tries to search for it in the
textToSearch and if it is found then it stores it in the relevantDates if
it already doesn't exist
'''
def findInString(patternToFind, textToSearch, flags, relevantDates):
    if flags:                                      # if flags not empty
        matchResult = re.search((patternToFind) , textToSearch, flags)
    else:                                          # no flags to include
        matchResult = re.search((patternToFind) , textToSearch)

    if matchResult:                                  # if there was a match
        if matchResult.group() not in relevantDates: # if match doesn't exist in datex
            relevantDates.append(matchResult.group()) # add it to the date list
            return matchResult.group()

def main():

  # This command-line parsing code is provided.
  # Make a list of command line arguments, omitting the [0] element
  # which is the script itself.
  args = sys.argv[1:]

  for filename in args:                 # iterate through each filename
    getRawData(filename)     # extract dates from each file



## boiler plate python main function
if __name__ == '__main__':
  main()
