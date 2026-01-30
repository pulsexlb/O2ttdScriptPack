#!python

import os
import re
import platform
from shutil import copy2, rmtree, copytree
from glob import iglob
import tarfile
from pathlib import Path

# ----------------------------------
# Definitions:
# ----------------------------------

# Game Script name
gs_name = "O2ttdScriptPack"

# ----------------------------------


# Script:
mainversion = 1
subversion = 5

tmp_dir = gs_name + "-" + str(mainversion) + "." + str(subversion)
tar_name = tmp_dir + ".tar"

if os.path.exists(tmp_dir):
    rmtree(tmp_dir)
os.mkdir(tmp_dir)

files = iglob("*.nut")
for file in files:
    if os.path.isfile(file):
        src_path = file
        dst_path = os.path.join(tmp_dir, os.path.basename(file))
        with open(src_path, 'r', encoding='utf-8') as f:
            content = f.read()
        with open(dst_path, 'w', encoding='utf-8-sig') as f:  # utf-8-sig Add BOM
            f.write(content)

copy2('readme.txt', tmp_dir)
# copy2('license.txt', tmp_dir)
copy2('changelog.txt', tmp_dir)
copytree('lang', os.path.join(tmp_dir, 'lang'))
copytree('rvg', os.path.join(tmp_dir, 'rvg'))

with tarfile.open(tar_name, "w:") as tar_handle:
    for root, dirs, files in os.walk(tmp_dir):
        for file in files:
            tar_handle.add(os.path.join(root, file))

rmtree(tmp_dir)
