import os,shutil
btt_all_component = open("../8210.txt")

for component in btt_all_component:

    component=component.strip()
    parent_path="../../"
    # clean logs
    ant_log = parent_path + component + "/logs/ant.log"
    if os.path.exists(ant_log):
        os.remove(ant_log)
    # clean updateSite
    updateSite_log = parent_path + component + "/logs/updateSite.log"
    if os.path.exists(updateSite_log):
        os.remove(updateSite_log)
    logs_forder = parent_path + component + "/logs"
    #remove log forder
    if os.path.exists(logs_forder):
        try:
            os.rmdir(logs_forder)
        except OSError as err:
            print(err)
            print(os.listdir(logs_forder))
    #remove deliverables and installation
    deliverables_path=parent_path + component + "/deliverables"
    installation_path=parent_path + component + "/installation"
    if os.path.exists(deliverables_path):
        shutil.rmtree(deliverables_path)
    if os.path.exists(installation_path):
        shutil.rmtree(installation_path)

btt_all_component.close()
