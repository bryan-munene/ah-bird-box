FROM python:3.7

ENV PYTHONUNBUFFERED 1
ENV DATABASE_URL="postgresql://postgres:postgres@db:5432/authorshaven" \
    SECRET_KEY="7pgozr2jn7zsbsdbgsbdjghuhetngn853u832utu2u3t3289htuhty93vh2whrtu298t3jnjsht895h298jt" \
    FACEBOOK_KEY="247837426149873" \
    FACEBOOK_SECRET="2e84a49d93c22149d8fc0a9ca4b637e8" \
    GOOGLE_OAUTH2_KEY="1002458434953-pacsegk23bhcmuqso0obfk6h0g72ma76.apps.googleusercontent.com" \
    GOOGLE_OAUTH2_SECRET="UHFx0lVYiHWAEz-Rm0aU_DpN" \
    OAUTH2_ACCESS_TOKEN="EAADhaCWZCafEBAFUJbrqpS3BqZAVah0YZCNGi7GXdzEPLdkhT7yYfx32Ayt0NTPbhQ3ykTUhGCtAw1pNIPsKLBgvlj1N3KyhElXZByP0jntknsVmMHWdCdXzFTAFtGeUtMSCVVKEBVLU1DrXZBzNTYWeGQ8idofwZD" \
    EMAIL_SENDER="ahbirdbox03@gmail.com" \
    EMAIL_HOST="smtp.gmail.com" \
    EMAIL_HOST_USER="ahbirdbox03@gmail.com" \
    EMAIL_HOST_PASSWORD="@Birdbox2019" \
    EMAIL_PORT=587 \
    CLOUDINARY_NAME="muthuri" \
    CLOUDINARY_KEY="873127371616125" \
    CLOUDINARY_SECRET="XjqUIFkfYmu2GBjgY041EZcg_-8" \
    APP_BASE_URL="http://127.0.0.1:8000"

RUN mkdir /code
WORKDIR /code
COPY . /code/
RUN pip3 install -r requirements.txt
RUN ls -al
RUN chmod +x startapp.sh

RUN chown -R $(whoami) ../code
RUN ls -al
