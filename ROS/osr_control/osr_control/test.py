import subprocess
def run_command(cmd):
    subprocess.run(cmd,check=True)
run_command(["sudo","apt","update"])
run_command(["sudo","apt","install","-y","software-properties-common"])
print("apt working")