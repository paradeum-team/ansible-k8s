#!/usr/bin/env python
# _*_ coding:utf-8 _*_
__author__ = 'yhchen'


import  argparse, re

# get args list
def getArgs():
    parse=argparse.ArgumentParser()
    parse.add_argument('-k',type=str,default="masters",help="ansible hosts section name")
    parse.add_argument('-f',type=str,default="/etc/ansible/hosts",help="ansible hosts文件路径")
    return parse.parse_args()


# get interest content from ansible hosts base section
def getSection(keyWord,ansibleHostFile):
    # open ansible hosts file
    with open(ansibleHostFile, 'r') as f:
        # match all section pattern
        matchAllSectionStr = r'^\[.*\]$'
        matchAllSectionPattern = re.compile(matchAllSectionStr,re.I|re.M|re.U)
        
        # match interest section pattern
        matchSectionStr = r'^\[' + keyWord + r'\]$'
        matchSetcionPattern = re.compile(matchSectionStr,re.I|re.M|re.U) 

        # match Note line pattern
        matchNodeLinePattern = re.compile(r'^#',re.I|re.M|re.U)

        # match blank line
        matchBlankLinePattern = re.compile(r'\s',re.I|re.M|re.U) 
        
        # line number
        linenum = 0
        
        # get line number
        for line in f.readlines(): 
            sectionMatch = matchSetcionPattern.match(line.strip())
            if sectionMatch:
                linenum += 1
                break
            linenum += 1
        
        # move to file head
        f.seek(0, 0)
        
        # get interest line
        for l in f.readlines()[linenum:]:  
            # if node line jump process
            nodeLineMatch = matchNodeLinePattern.match(l.strip())
            if nodeLineMatch:
                continue
            
            # if blank line jump process
            blankLineMatch = matchBlankLinePattern.match(l)
            if blankLineMatch:
                continue
            
            # if pattern next section exit for loop
            nextSectionMatch = matchAllSectionPattern.match(l.strip())
            if nextSectionMatch:
                break
            print l.strip().split(r' ')[0]
        

if __name__=='__main__':
    args=getArgs()
    keyWord = args.k
    ansibleHostFile = args.f
    getSection(keyWord,ansibleHostFile)
