# -*- coding: utf-8 -*-
require 'rubygems'
require 'socialskk'
require 'cgi'
require 'json'

class GoogleImeSkk < SocialSKK
  VERSION_STRING   = "GoogleImeSKK0.1 "

  def encode_to_utf8(text)
    if String.new.respond_to?(:encode)
      text.encode('utf-8', 'euc-jp')
    else
      require 'kconv'
      Kconv.toutf8(text)
    end
  end

  def encode_to_eucjp(text)
    if String.new.respond_to?(:encode)
      text.encode('euc-jp', 'utf-8', {:invaild => true, :replace => '?'})
    else
      require 'kconv'
      Kconv.toeuc(text)
    end
  end

  def social_ime_search(text)
    # listen to local ime
    text = encode_to_utf8(text)
    text = text.sub(/[a-z]?$/) { |m| ',' + m }
    uri = URI.parse 'http://www.google.com/transliterate'
    http = if @proxy
             Net::HTTP.new(uri.host, uri.port, @proxy.host, @proxy.port)
           else
             Net::HTTP.new(uri.host, uri.port)
           end
    begin
      http.read_timeout = 1
      http.open_timeout = 1
      http.start do |h|
        res = h.get("/transliterate?langpair=ja-Hira%7Cja&text=" + URI.escape(text))
        obj = JSON.parse(res.body.to_s)
        candidates = obj[0][1].find_all{|s| s !~ /^(([ァ-ヾ]+)|([ぁ-ゞ]+)|([ｦ-ﾟ]+)|([a-zA-Z]+))$/}
        unless candidates.empty?
          # A/B/C/D/
          # http://code.google.com/p/dbskkd-cdb/source/browse/trunk/skk-server-protocol.txt
          encode_to_eucjp(candidates.join('/') + '/')
        end
      end
    rescue => e
      warn e
      return ""
    end
  end
end


