# -*- coding: utf-8 -*-
# Find the time and value of max load for each of the regions
# COAST, EAST, FAR_WEST, NORTH, NORTH_C, SOUTHERN, SOUTH_C, WEST
# and write the result out in a csv file, using pipe character | as the delimiter.
# An example output can be seen in the "example.csv" file.
import xlrd
import os
import csv
from zipfile import ZipFile
datafile = "2013_ERCOT_Hourly_Load_Data.xls"
outfile = "2013_Max_Loads.csv"


def open_zip(datafile):
    with ZipFile('{0}.zip'.format(datafile), 'r') as myzip:
        myzip.extractall()


def parse_file(datafile):
    workbook = xlrd.open_workbook(datafile)
    sheet = workbook.sheet_by_index(0)
    
    # Remember that you can use xlrd.xldate_as_tuple(sometime, 0) to convert
    # Excel date to Python tuple of (year, month, day, hour, minute, second)    
    
    data = []
    for column in range(1, 9):
        station_name = sheet.col_values(column)[0]
        column_data = sheet.col_values(column)[1:]

        maxvalue = max(column_data)
        
        maxtime_excel = [sheet.cell_value(r, 0) for r in range(sheet.nrows) 
            if sheet.cell_value(r, column) == maxvalue]
        maxtime = xlrd.xldate_as_tuple(maxtime_excel[0], 0)
        
        row =  {"Station": station_name,
                "Year": maxtime[0], 
                "Month": maxtime[1], 
                "Day": maxtime[2], 
                "Hour": maxtime[3], 
                "Max Load": maxvalue}
        
        data.append(row)
          
    return data

def save_file(data, filename):
    with open(filename, 'w') as csvfile:
        fieldnames = ["Station", "Year", "Month", "Day", "Hour", "Max Load"]
        writer = csv.DictWriter(csvfile, fieldnames = fieldnames, delimiter = "|")
    
        writer.writeheader()
        for row in data:
            writer.writerow(row)
    
def test():
    #open_zip(datafile)
    data = parse_file(datafile)
    save_file(data, outfile)

    ans = {'FAR_WEST': {'Max Load': "2281.2722140000024", 'Year': "2013", "Month": "6", "Day": "26", "Hour": "17"}}
    
    fields = ["Year", "Month", "Day", "Hour", "Max Load"]
    with open(outfile) as of:
        csvfile = csv.DictReader(of, delimiter="|")
        for line in csvfile:
            s = line["Station"]
            if s == 'FAR_WEST':
                for field in fields:
                    assert ans[s][field] == line[field]

        
test()