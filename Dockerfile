FROM perl:5.32
COPY . /usr/src/bot
WORKDIR /usr/src/bot
RUN cpanm --installdeps .
CMD [ "perl", "-Ilib", "./main.pl" ]
