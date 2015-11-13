#!/bin/bash
#
# env var: C12E_DATA_VOL_TYPE=efs
# C12E_EFS_FS_ID=fs-xxxxxx
# C12E_EFS_MOUNTPOINT

vol_type=${C12E_DATA_VOL_TYPE:-local}
mount_dir=${C12E_EFS_MOUNTPOINT:-}

if [ ${C12E_DATA_VOL_TYPE} == "efs" ]; then
   fsid=${C12E_EFS_FS_ID:-none}
   if [ $fsid == "none" ]
      echo "You must proivde a file system id for EFS"
      exit 1
   else
      if [ ! -d $mount_dir ]; then
          mkdir -p $mount_dir
      fi
      # mount efs 
      mount -t nfs4 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).$fsid.efs.us-west-2.amazonaws.com:/ $mount_dir
   fi

   # create soft link
   unlink /data
   ln --symbolic $mount_dir /data
fi

# mount start neo4j
/docker-entrypoint.sh neo4j

