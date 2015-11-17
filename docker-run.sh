docker run --privileged -e C12E_DATA_VOL_TYPE=efs -e C12E_EFS_FS_ID=fs-584da3f1 -e NEO4J_THIRDPARTY_JAXRS_CLASSES=com.c12e.ext.neo4j.plugin=\/c12e -p 7474:7474 -p 7473:7473 -t c12e/neo4j:2.3.0
