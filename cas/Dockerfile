FROM apereo/cas:v5.3.10
COPY pom.xml /cas-overlay/
RUN build.sh package

RUN keytool -genkeypair -alias cas -keyalg RSA -keypass changeit \
            -storepass changeit -keystore /cas-overlay/etc/cas/thekeystore \
            -dname "CN=cas.example.org,OU=Example,OU=Org,C=AU" \
            -ext SAN="dns:example.org,dns:localhost,ip:127.0.0.1"
COPY etc/cas/config/* /cas-overlay/etc/cas/config/
COPY etc/cas/services/* /cas-overlay/etc/cas/services/
COPY etc/cas/users.json /cas-overlay/etc/cas/
COPY pom.xml /cas-overlay/
RUN build.sh copy
