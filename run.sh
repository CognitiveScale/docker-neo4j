#!/bin/bash
#
# env var: C12E_DATA_VOL_TYPE=efs
# C12E_EFS_FS_ID=fs-xxxxxx
# C12E_EFS_MOUNTPOINT
# C12E_SERVICE_NAME=neo4j
# C12E_SLUG=triton1

vol_type=${C12E_DATA_VOL_TYPE:-local}
efs_mount=${C12E_EFS_MOUNTPOINT:-}
service_name=${C12E_SERVICE_NAME:-neo4j}
slug=${C12E_SLUG:-triton}

if [ ${C12E_DATA_VOL_TYPE} == "efs" ]; then
   fsid=${C12E_EFS_FS_ID:-none}
   mount_dir=$efs_mount/$slug/$service_name/data

   if [ $fsid == "none" ]; then
      echo "You must proivde a file system id for EFS"
      exit 1
   else
      if [ ! -d $efs_mount ]; then
          mkdir -p $efs_mount
      fi
      # mount efs
      mount -t nfs4 $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).$fsid.efs.us-west-2.amazonaws.com:/ $efs_mount
      if [ $? -ne 0 ]; then
         echo "EFS mount failed"
         exit 1
      fi
   fi

   mkdir -p $mount_dir
   unlink /var/lib/neo4j/data
   ln --symbolic $mount_dir /var/lib/neo4j
   if [ $? -ne 0 ]; then
       echo "failed to create symbolic link for neo4j data"
       exit 1
   fi
fi

# mount start neo4j
/docker-entrypoint.sh neo4j

