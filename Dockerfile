FROM registry.access.redhat.com/ubi8-minimal

RUN set -o errexit -o nounset \
    && microdnf -y upgrade --refresh --best --nodocs --noplugins --setopt=install_weak_deps=0 \
    # install requisite packages
    && microdnf install -y python39 python39-pip jq gnupg shadow-utils --nodocs --setopt=install_weak_deps=0 \
    && microdnf install -y unzip which curl less groff-base --nodocs --setopt=install_weak_deps=0 \
    && microdnf clean all \
    # install the aws cli from aws
    #&& curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm awscliv2.zip \
    && rm -rf ./aws/ \
    && aws --version \
    # install checkov     
    && python3 -m pip install --upgrade pip \
    && python3 -m pip install checkov


# Add aws user and home directory
RUN set -o errexit -o nounset \
    && echo "Adding aws user and group" \
    && groupadd --system --gid 1000 aws \
    && useradd --system -g aws --uid 1000 --shell /sbin/nologin -m -d /home/aws -c "aws user" aws \
    && chown aws:aws /home/aws 

WORKDIR /home/aws

USER aws
