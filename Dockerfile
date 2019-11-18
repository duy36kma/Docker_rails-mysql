FROM ruby:2.5.1

LABEL author.name="NguyenDUY" \
  author.email="abc@gmail.com"

#install apt based dependencies required to run on Rails
#Debian image, we use apt-get to install

RUN apt-get update && \
  apt-get install -y nodejs nano vim

# Set the timezone

ENV TZ=Asia/Ho_Chi_Minh
RUN ls -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timzone

#Configure the mail working directory.
#directory used in any futher RUN, COPY and ENTRYPOINT commands
ENV APP_PATH /my_app
WORKDIR $APP_PATH

#Copy thr GENfile as well as the GEMfile.lock and install
COPY Gemfile Gemfile.lock $APP_PATH/
RUN bundle install --without production --retry 2 \
  --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1`

# ADD a script to be executed very time the container start

COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# The main command to run when the container start.
CMD ["rails", "server", "-b", "0.0.0.0"]
