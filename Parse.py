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

def extractDays(relevantDates , rawListOfData, dayList):
    for individualLine in rawListOfData:  # iterate through each line
        for days in dayList:              # iterate through each day combination

            # this regex tries to retrieve any line that contains a day of the week
            dayMatch = re.search(('.+')+(days)+('.+'), individualLine, re.IGNORECASE | re.DOTALL  )
            if dayMatch:                  # if match was found append to list:
                                          # check if the item is already in the list
                if dayMatch.group() not in relevantDates:
                    relevantDates.append(dayMatch.group())
    pprint(relevantDates)




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
