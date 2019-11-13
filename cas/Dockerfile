FROM apereo/cas:v5.3.10
RUN keytool -genkeypair -alias cas -keyalg RSA -keypass changeit \
            -storepass changeit -keystore /cas-overlay/etc/cas/thekeystore \
            -dname "CN=cas.example.org,OU=Example,OU=Org,C=AU" \
            -ext SAN="dns:example.org,dns:localhost,ip:127.0.0.1"
COPY cas.properties /cas-overlay/etc/cas/config/cas.properties
# COPY users.json /cas-overlay/etc/cas/users.json

RUN build.sh package \
  && build.sh copy
