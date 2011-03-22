# Copyright 2009-2011 Mark Fiers
# The New Zealand Institute for Plant & Food Research
# 
# This file is part of Moa - http://github.com/mfiers/Moa
# 
# Licensed under the GPL license (see 'COPYING')
# 
"""
**moautil** - Some extra utilities - copy/move jobs
---------------------------------------------------
"""

import os
import re
import sys
import glob
import shutil

import moa.logger as l
import moa.ui

def defineCommands(data):
    data['commands']['cp'] = {
        'desc' : 'Copy a moa job (only the configuration, not the data), '+
        'use moa cp DIR_FROM DIR_TO',
        'call' : moacp }

#    data['commands']['mv'] = {
#        'desc' : 'Move a moa job, ',
#        'call' : moamv }
#        
#    data['commands']['kill'] = {
#        'desc' : 'Kill a running moa job',
#        'call' : moakill }
#
#    data['commands']['pause'] = {
#        'desc' : 'Pause a running moa job',
#        'call' : moapause }
#
#    data['commands']['resume'] = {
#        'desc' : 'Resume a paused moa job',
#        'call' : moaresume }
#
#    data['commands']['tree'] = {
#        'desc' : 'return a tree structure with extra moa information',
#        'call' : moaTree }


#def moaTree(data):
#    """
#    Print a tree with Moa info
#    """
#    cwd = data['cwd']
#    for root, dirs, files in os.walk(cwd):
#        state = moa.info.status(root)
#        print "%-10s %s" % (state, os.path.relpath(root, cwd))

def moakill(data):
    """
    kill a running job
    """
    cwd = data['cwd']

    if not moa.info.status(cwd) == 'running': 
        l.warning("Moa does not seem to be running!")
        sys.exit(-1)

    pid = int(open(os.path.join(cwd, 'moa.runlock')).read())
    l.critical("killing job %d" % pid)
    os.kill(pid, 9)

def moapause(data):
    """
    pause a running job
    """
    cwd = data['cwd']

    if not moa.info.status(cwd) == 'running': 
        l.warning("Moa process does not seem to be active!")
        sys.exit(-1)

    pid = int(open(os.path.join(cwd, 'moa.runlock')).read())
    l.warning("Pausing job %d" % pid)
    os.kill(pid, 19)

def moaresume(data):
    """
    resume a paused job - 

    """
    cwd = data['cwd']
    if not moa.info.status(cwd) == 'paused': 
        l.warning("Moa process does not seem to be paused!")
        sys.exit(-1)

    pid = int(open(os.path.join(cwd, 'moa.runlock')).read())
    l.warning("Resming job %d" % pid)
    os.kill(pid, 18)

def moamv(data):
    
    args = data['newargs']

    fr = args[0]
    if fr[-1] == '/':
        fr = fr[:-1]
        
    if len(args) > 1: to = args[1]
    else: to = '.'

    #see if fr is a number
    if re.match('\d+', fr):
        newfr = glob.glob('%s*' % fr)
        if len(newfr) != 1:
            l.critical("Cannot resolve %s (%s)" % (fr, newfr))
            sys.exit(1)
        fr = newfr[0]
        
    if re.match('\d+', to):
        if re.search('^\d+', fr):
            to = re.sub('^\d+', to, fr)
        else:
            to = '%s.%s' % (to, fr)
    shutil.move(fr, to)
            
    
def moacp(data):
    """
    Copy a moa job - 
      0 create a new directory
      1 copy the configuration

    ::TODO..
      Warn for changing file & dir links
            
    """
    
    args = data['newargs']

    if len(args) > 1: dirTo = args[1]
    else: dirTo = '.'

    
    dirFrom = args[0]
    dirFromM = os.path.join(dirFrom, '.moa')
    if not os.path.exists(dirFromM):
        moa.ui.exitError(
            "%s does not appear to be a moa directory" % dirFrom)
        
    #remove trailing slash & determine basename
    if dirFrom[-1] == '/': dirFrom = dirFrom[:-1]
    fromBase = os.path.basename(dirFrom)

    if dirTo[-1] == '/': dirTo = dirTo[:-1]
    toBase = os.path.basename(dirTo)

    # trick - the second argument is a number
    # renumber the target directory
    if re.match("^[0-9]+$", toBase):
        toBase = re.sub("^[0-9]*\.", toBase + '.', fromBase)
        dirTo = os.path.join(os.path.dirname(dirTo), toBase)
        
    elif os.path.exists(dirTo):
        #if the 'to' directory exists - create a new directory 
        dirTo = os.path.join(dirTo, fromBase)     
    
    dirToM = os.path.join(dirTo, '.moa')
    
    l.info("creating directory %s" % dirTo)
    
    #create the target '.moa' dir    
    #os.makedirs(dirToM)
        
    l.info("Copying from %s to %s" % (dirFrom, dirTo))

    def _ignore(src, names):        
        if src[-5:] == '/.moa': 
            ignore =  [x for x in names 
                       if (x == 'out') or 
                       (x[-4:] == '.fof')]
            return ignore
        return []

    shutil.copytree(dirFromM, dirToM, ignore=_ignore)
