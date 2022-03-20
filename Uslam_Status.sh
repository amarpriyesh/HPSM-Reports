#!/usr/local/bin/expect

spawn ssh hpuslametl@meyuslvapp01
expect "*?assword:*"
send -- "hpuslam!23"
expect "*?assword:*"
send -- "welcome123!"


