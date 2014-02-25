require 'net/smtp'

message = <<MESSAGE_END
From: Private Person <suliangfei@163.com>
To: A Test User <suliangfei@163.com>
MIME-Version: 1.0
Content-type: text/html
Subject: SMTP e-mail test

This is an e-mail message to be sent in HTML format

<b>This is HTML message.</b>
<h1>This is headline.</h1>
MESSAGE_END

Net::SMTP.start('smtp.163.com', 25, 'suliangfei.163.com', 'suliangfei', 'Smjx1tdh') do |smtp|
  smtp.send_message message, 'suliangfei@163.com', 
                             'suliangfei@163.com'
end