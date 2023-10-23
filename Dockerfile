# ベースイメージを指定
FROM ruby:2.7.7

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y nodejs 

# ルートディレクトリを作成
RUN mkdir /genome-img-app

# 作業ディレクトリを設定
WORKDIR /genome-img-app

# ホストのGemfileとGemfile.lockをコピー
COPY Gemfile /genome-img-app/Gemfile
COPY Gemfile.lock /genome-img-app/Gemfile.lock

# ホストのhostsファイルをコピー
COPY hosts /etc/hosts

# 必要なSSL証明書を追加
RUN apt-get install -y ca-certificates

# bundlerのバージョンを固定してインストール
RUN gem install bundler -v '2.3.26'

# Gemのインストール
RUN bundle config --global ssl_ca_cert /etc/ssl/certs/ca-certificates.crt
RUN bundle install

# ホストのRailsアプリケーションのファイルをコピー
COPY . /genome-img-app

