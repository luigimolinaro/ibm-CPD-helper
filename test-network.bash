#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

domains_bastion=(
  "registry.access.redhat.com"
  "quay.io"
  "icr.io"
  "cdn.redhat.com"
  "cdn-ubi.redhat.com"
  "rpm.releases.hashicorp.com"
  "dl.fedoraproject.org"
  "mirrors.fedoraproject.org"
  "fedora.mirrorservice.org"
  "pypi.org"
  "galaxy.ansible.com"
)

domains_oc=(
  "github.com"
  "gcr.io"
  "quay.io"
  "objects.githubusercontent.com"
  "mirror.openshift.com"
  "ocsp.digicert.com"
  "subscription.rhsm.redhat.com"
)

# Test dei domini sul bastion host
echo "Testing domini sul bastion Host"
for domain in "${domains_bastion[@]}"
do
  echo "Testing $domain..."
  if curl -s --head --fail $domain > /dev/null; then
    echo -e "[${GREEN}OK${NC}] $domain is accessible"
  else
    echo -e "[${RED}KO${NC}] $domain is not accessible"
  fi
  echo
done

# Test dei domini su OpenShift
echo "Testing domini su OpenShift"
image="curlimages/curl"
oc run test-pod --image=$image --restart=Never -- /bin/sh -c '
for domain in "${domains_oc[@]}"; do
  echo "Testing $domain..."
  if curl -s --head --fail $domain > /dev/null; then
    echo -e "[${GREEN}OK${NC}] $domain is accessible"
  else
    echo -e "[${RED}KO${NC}] $domain is not accessible"
  fi
  echo
done
'

# Pulizia del pod di test
oc delete pod test-pod
