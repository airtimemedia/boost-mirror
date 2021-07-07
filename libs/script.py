import os
import subprocess

# os.chdir('numeric')
libs = list(filter(os.path.isdir, os.listdir()))
for lib in libs:
	print(lib)
	os.chdir(lib)
	subprocess.call(["git", "checkout", "feature/CAR-1802---update-boost"])
	# subprocess.call(["git", "remote", "add", "upstream", "https://github.com/boostorg/"+lib+".git"])
	# try:
	# 	subprocess.call(["git", "pull", "upstream", "master"])
	# except:
	# 	print('extra work needed: ' + lib)
	# 	continue
	# subprocess.call(["git", "remote", "set-url", "origin", ])
	# print(os.getcwd())
	os.chdir('..')
