FROM alpine:latest

RUN apk add --no-cache --virtual .persistent-deps \
		ca-certificates \
		curl 

ENV COW_VERSION 0.9.8

RUN curl -sSL https://github.com/cyfdecyf/cow/releases/download/0.9.8/cow-linux64-{$COW_VERSION}.gz -o /tmp/cow.gz

RUN gunzip /tmp/cow.gz \
	&& chmod +x /tmp/cow \
	&& mv /tmp/cow /usr/local/bin/cow \
	&& rm -f /tmp/cow.gz \
 	&& mkdir $HOME/.cow

RUN curl -L https://cdn.rawgit.com/cyfdecyf/cow/master/doc/sample-config/rc-en > $HOME/.cow/rc

EXPOSE 7777

VOLUME $HOME/.cow/

CMD ["cow"]



