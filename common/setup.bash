#!/bin/bash -x

function setup_redstack() {
    cd ${VM_USER_HOME}
    #prepare devstack
    cd devstack

    cd ${VM_USER_HOME}
    cd trove-integration/scripts

    HOST_IP=$(ifconfig eth0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

    if [[ $ENABLE_NEUTRON = true ]]
    then
        USING_VAGRANT=False
        ENABLED_SERVICES=key,n-api,n-cpu,n-cond,n-sch,n-crt,n-cauth,n-novnc,g-api,g-reg,c-sch,c-api,c-vol,horizon,rabbit,tempest,mysql,dstat,trove,tr-api,tr-tmgr,tr-cond,s-proxy,s-object,s-container,s-account,heat,h-api,h-api-cfn,h-api-cw,h-eng,neutron,q-svc,q-agt,q-dhcp,q-l3,q-meta

    else
        USING_VAGRANT=True
        ENABLED_SERVICES=key,n-api,n-cpu,n-cond,n-sch,n-crt,n-cauth,n-novnc,g-api,g-reg,c-sch,c-api,c-vol,horizon,rabbit,tempest,mysql,dstat,trove,tr-api,tr-tmgr,tr-cond,s-proxy,s-object,s-container,s-account,heat,h-api,h-api-cfn,h-api-cw,h-eng,n-net

    fi

    cat > ${VM_USER_HOME}/.devstack.local.conf <<EOF
IP_VERSION=4
HOST_IP=$HOST_IP
SWIFT_LOOPBACK_DISK_SIZE=10G
VOLUME_BACKING_FILE_SIZE=50G
SCREEN_LOGDIR=/opt/stack/logs/screen
ENABLED_SERVICES=$ENABLED_SERVICES
EOF

    chown -R ${VM_USER}:${VM_USER} ${VM_USER_HOME}
    chown -R ${VM_USER}:${VM_USER} ${VM_USER_HOME}

    su - ${VM_USER} -c  "export ENABLE_NEUTRON=${ENABLE_NEUTRON};
                         export USING_VAGRANT=${USING_VAGRANT};
                         export LIBS_FROM_GIT_ALL_CLIENTS=false;
                         export LIBS_FROM_GIT_ALL_OSLO=false;
                         export ENABLE_CEILOMETER=false;
                         export ENABLE_PROFILER=false;
                         cd  ${VM_USER_HOME}/trove-integration/scripts
                         ./redstack install"
}
