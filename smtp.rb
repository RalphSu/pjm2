# -*- encoding : utf-8 -*-
#-- encoding=utf-8
require 'uri'
enc_uri = URI.escape("http://example.com/?a=/file/public/项目报告发布")
p enc_uri
