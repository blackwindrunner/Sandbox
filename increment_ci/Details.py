import time
import sys
def readFile(filepath):
    out=""
    file = open(filepath)
    count = 0
    for oneline in file.readlines():
        count+=1
        if(oneline!=''):
            if (count > 1):
                out += "</br>"
            out+=oneline
    return out

commit_id =readFile("git_logs/commit_id.txt")
print(commit_id)
name_only=readFile("git_logs/name_only.txt")
print(name_only)
log_pretty=readFile("git_logs/log--pretty.txt")
print(log_pretty)
components=readFile("../properties/defectComponent.properties")
print(components)
defectDependCom=readFile("../properties/defectDependCom.properties")
print(defectDependCom)
diff=readFile("git_logs/diff.txt")
print(diff)
Datetime=time.strftime("%Y-%m-%d %H:%M:%S", time.localtime())
print(Datetime)
if(sys.argv.__len__()>1):
    branch=sys.argv[1]
else:
    branch=""
with open('details_templete.html','r',encoding='utf-8') as f1,open('details.html','w',encoding='utf-8') as f2:
    for i in f1:

        i=i.replace("{{username}}","ghost")
        i=i.replace("{{Datetime}}",Datetime)
        i=i.replace("{{commit_id}}", commit_id)
        i=i.replace("{{name_only}}",name_only)
        i=i.replace("{{log_pretty}}",log_pretty)
        i=i.replace("{{components}}",components)
        i=i.replace("{{defectDependCom}}",defectDependCom)
        i=i.replace("{{diff}}",diff)
        i=i.replace("{{branch}}",branch)

        #print(i)
        f2.write(i)
