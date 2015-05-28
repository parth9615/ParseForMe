import sys
import re
from pprint import pprint


def getRawData(filename):

  f = open(filename, 'rU')              # Open and read the file. for read only
  rawListOfData = f.readlines()         # get each line as a list

  extractDates(rawListOfData)

def extractDates(rawListOfData):
  dayList = ['Monday' , 'Tuesday' , 'Wednesday' , 'Thursday' , 'Friday', 'Saturday' , 'Sunday'
            'Mondays' , 'Tuesdays' , 'Wednesdays' , 'Thursdays' , 'Fridays' ,'Saturdays' , 'Sundays'
            'Mon' , 'Tue' , 'Wed' , 'Thur' , 'Fri' , 'Sat' , 'Sun']
  relevantDates = []                    # make a list to hold all the dates
                                        # get all days and store in relevantDates
  extractDays(relevantDates , rawListOfData, dayList)

'''
This method iterates through the rawListOfData to find patterns in the method
Current parsing methods included in the pattern
1: Finding a line that contains a day of the week
2: Finding a line that contains a time in the format ##:## (for ex 12:10 or 3:20)
todo : update this numeric list as more patterns are added:
'''
def extractDays(relevantDates , rawListOfData, dayList):
    for individualLine in rawListOfData:  # iterate through each line
        for days in dayList:              # iterate through each day combination

            # regex pattern to find the entire line that contains a day in the dayList
            dayOfTheWeekPattern = ('.+')+(days)+('.+')
            # regex flag to ingnorecase and make the dot include whitespace
            dayOfTheWeekFlags =   re.IGNORECASE | re.DOTALL
            # call findInString to check if such a pattern exists
            findInString(dayOfTheWeekPattern , individualLine , dayOfTheWeekFlags, relevantDates)

        # pattern to find the pattern ##:## which is commonly used to denote time
        clockTimePattern = ('.+\d:\d\d.+')
        # flag to make the dot include whitespace
        clockTimeFlags   = re.DOTALL
        findInString(clockTimePattern , individualLine, clockTimeFlags , relevantDates)

    pprint(relevantDates)


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
