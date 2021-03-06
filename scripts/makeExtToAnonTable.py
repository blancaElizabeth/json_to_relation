#!/usr/bin/env python
# Copyright (c) 2014, Stanford University
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

'''
Created on Jan 11, 2015

@author: paepcke
'''
import os
import random
import stat
import string
from subprocess import PIPE, Popen
import subprocess
import sys
import tempfile

from pymysql_utils.pymysql_utils import MySQLDB

source_dir = [os.path.join(os.path.dirname(os.path.abspath(__file__)), "../json_to_relation/")]
source_dir.extend(sys.path)
sys.path = source_dir

from edxTrackLogJSONParser import EdXTrackLogJSONParser

class ExtToAnonTableMaker(object):
    
    def __init__(self, extIdsFileName):
        
        user = 'root'
        # Try to find pwd in specified user's $HOME/.ssh/mysql
        currUserHomeDir = os.getenv('HOME')
        if currUserHomeDir is None:
            pwd = None
        else:
            try:
                # Need to access MySQL db as its 'root':
                with open(os.path.join(currUserHomeDir, '.ssh/mysql_root')) as fd:
                    pwd = fd.readline().strip()
                # Switch user to 'root' b/c from now on it will need to be root:
                user = 'root'
                
            except IOError:
                # No .ssh subdir of user's home, or no mysql inside .ssh:
                pwd = None
        
        self.db = MySQLDB(user=user, passwd=pwd, db='Misc')
        
        self.makeTmpExtsTable()
        self.loadExtIds(extIdsFileName)
        outfile = tempfile.NamedTemporaryFile(prefix='extsIntsScreenNames', suffix='.csv', delete=True)
        # Need to close this file, and thereby delete it,
        # so that MySQL is willing to write to it. Yes,
        # that's a race condition. But this is an
        # admin script, run by one person:
        outfile.close()
        self.findScreenNames(outfile.name)
        self.computeAnonFromScreenNames(outfile.name)

    def makeTmpExtsTable(self):
        # Create table to load the CSV file into:
        self.externalsTblNm = self.idGenerator(prefix='ExternalsTbl_')
        mysqlCmd = 'CREATE TEMPORARY TABLE %s (ext_id varchar(32));' % self.externalsTblNm
        self.db.execute(mysqlCmd)
        
    def loadExtIds(self, csvExtsFileName):
        # Clean up line endings in the extIds file.
        # Between Win, MySQL, Mac, and R, we get
        # linefeeds and crs:
        cleanExtsFile = tempfile.NamedTemporaryFile(prefix='cleanExts', suffix='.csv', delete=False)
        os.chmod(cleanExtsFile.name, stat.S_IRUSR | stat.S_IRGRP | stat.S_IROTH)
        rawExtsFd = open(csvExtsFileName, 'r')
        for line in rawExtsFd:
            cleanExtsFile.write(line.strip() + '\n')
        cleanExtsFile.close()
        rawExtsFd.close()
        
        mysqlCmd = "LOAD DATA INFILE '%s' " % cleanExtsFile.name +\
                   'INTO TABLE %s ' % self.externalsTblNm +\
                   "FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;"
        self.db.execute(mysqlCmd)
        
        # Delete the cleaned-exts file:
        os.remove(cleanExtsFile.name)
        
    def findScreenNames(self, outCSVFileName):
        
        mysqlCmd = "SELECT 'ext_id','user_int_id','screen_name'" +\
		    	   "UNION " +\
		    	   "SELECT ext_id," +\
		    	   "       user_int_id," +\
		    	   "       username " +\
		    	   "  INTO OUTFILE '%s'" % outCSVFileName +\
		    	   "  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n'" +\
		    	   "  FROM "  +\
		    	   "    (SELECT ext_id,"  +\
		    	   "       user_id AS user_int_id "  +\
		    	   "       FROM %s LEFT JOIN edxprod.student_anonymoususerid " % self.externalsTblNm +\
		    	   "           ON %s.ext_id = edxprod.student_anonymoususerid.anonymous_user_id " % self.externalsTblNm +\
		    	   "    ) AS ExtAndInts " +\
		    	   "    LEFT JOIN edxprod.auth_user "  +\
		    	   "      ON edxprod.auth_user.id = ExtAndInts.user_int_id;"
        self.db.execute(mysqlCmd)
              
        
    def computeAnonFromScreenNames(self, extIntNameFileName):
        with open(extIntNameFileName, 'r') as inFd:
            print('ext_id,anon_screen_name')
            firstLineDiscarded = False
            for line in inFd:
                (extId, intId, screenName) = line.split(',') #@UnusedVariable
                #********
                #print('ScreenName.strip(\'"\'): \'%s\'' % screenName.strip().strip('"'))
                #********
                if firstLineDiscarded:
                    screenName = screenName.strip().strip('"')
                    if screenName == '\\N':
                        print ('%s,%s' % (extId.strip('"'),'NULL'))
                    else:
                        print('%s,%s' % (extId.strip('"'),EdXTrackLogJSONParser.makeHash(screenName)))
                else:
                    firstLineDiscarded = True
        
    def idGenerator(self, prefix='', size=6, chars=string.ascii_uppercase + string.digits):
        randPart = ''.join(random.choice(chars) for _ in range(size))
        return prefix + randPart



#     def computeAnonFromScreenNames(self, extIntNameFileName):
#         currDir = os.path.dirname(__file__)
#         scriptPath = '%s/makeAnonScreenName.py' % currDir
#         anonMaker = subprocess.Popen([scriptPath, '-'], stdout=PIPE, stdin=PIPE)
#         with open(extIntNameFileName, 'r') as inFd:
#             for line in inFd:
#                 (extId, intId, screenName) = line.split(',') #@UnusedVariable
#                 (anonScreenName, errRets) = anonMaker.communicate(screenName)  #@UnusedVariable
#                 print('%s,%s' % (extId, anonScreenName))
    
if __name__ == '__main__':
    
    converter = ExtToAnonTableMaker('/tmp/unmappables.csv');
