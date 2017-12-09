set ns [new Simulator]

set tf [open lab2.tr w]
$ns trace-all $tf

set nf [open lab2.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns duplex-link $n0 $n2 100Mb 300ms RED
$ns duplex-link $n1 $n2 1Mb 300ms RED
$ns duplex-link $n5 $n2 100Mb 300ms RED
$ns duplex-link $n3 $n2 1Mb 300ms RED
$ns duplex-link $n4 $n2 1Mb 300ms RED
$ns duplex-link $n6 $n2 1Mb 300ms RED

$ns set queue-limit $n0 $n2 10
$ns set queue-limit $n4 $n2 3
$ns set queue-limit $n5 $n2 10 
$ns set queue-limit $n6 $n2 2

$ns color 1 "red"
$ns color 2 "blue"

$n0 label "Ping 0"
$n2 label "Router"
$n4 label "Ping 4"
$n5 label "Ping 5"
$n6 label "Ping 6"

set ping0 [new Agent/Ping]
$ns attach-agent $n0 $ping0

set ping4 [new Agent/Ping]
$ns attach-agent $n4 $ping4

set ping5 [new Agent/Ping]
$ns attach-agent $n5 $ping5


set ping6 [new Agent/Ping]
$ns attach-agent $n6 $ping6

Agent/Ping instproc recv { from rtt} {



}

$ping0 set packetSize_ 5000
$ping0 set interval_ 0.0001

$ping5 set packetSize_ 6000
$ping5 set interval_ 0.0001

$ping0 set class_ 1
$ping5 set class_ 2


$ns connect $ping0 $ping4
$ns connect $ping5 $ping6

proc Send {} {

global ns ping0 ping5
set intervalTime 0.001
set now [$ns now]

$ns at [ expr $now+$intervalTime] "$ping0 send"
$ns at [ expr $now+$intervalTime] "$ping5 send"
$ns at [ expr $now+$intervalTime] "Send"

}

proc finish {} {

global ns tf nf

$ns flush-trace

exec nam lab2.nam &
close $nf
close $tf
exit 0
}

$ns at 0.1 "Send"
$ns at 5 "finish"
$ns run


