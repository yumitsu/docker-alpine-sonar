MAINTAINER Alex Zinchenko, yumitsu@users.noreply.github.com

FROM alpine:latest

VOLUME ['/data']

WORKDIR /data

RUN echo 'http://mirror.yandex.ru/mirrors/alpine/v3.1/main' > /etc/apk/repositories && \
    apk --update add openjdk7-jre \
                     curl && \
    curl -L -o sonarqube.zip http://dist.sonar.codehaus.org/sonarqube-5.1.zip && \
    unzip sonarqube.zip && \
    mv sonarqube-5.1 sonar && \
    sed -i 's|#wrapper.java.additional.6=-server|wrapper.java.additional.6=-server|g' /data/sonar/conf/wrapper.conf && \
    sed -i 's|#sonar.jdbc.password=sonar|sonar.jdbc.password=123qwe|g' /data/sonar/conf/sonar.properties && \
    sed -i 's|#sonar.jdbc.user=sonar|sonar.jdbc.user=sonar|g' /data/sonar/conf/sonar.properties && \
    sed -i 's|sonar.jdbc.url=jdbc:h2|#sonar.jdbc.url=jdbc:h2|g' /data/sonar/conf/sonar.properties && \
    sed -i 's|#sonar.jdbc.url=jdbc:mysql://localhost|sonar.jdbc.url=jdbc:mysql://${env:DB_PORT_3306_TCP_ADDR}|g' /data/sonar/conf/sonar.properties && \
    echo 'sonar.web.javaOpts=-server' >> /data/sonar/conf/sonar.properties && \
    rm sonarqube.zip && \
    apk del --purge curl

EXPOSE 9000

CMD ["/data/sonar/bin/linux-x86-64/sonar.sh", "console"]
