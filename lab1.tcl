set ns [new Simulator]
set tf [open lab1.tr w]
$ns trace-all $tf

set nf [open lab1.nam w]
$ns namtrace-all $nf

set n_(0) [$ns node]
set n_(1) [$ns node]
set n_(2) [$ns node]
set n_(3) [$ns node]

	

puts "Node created"	

$ns color 1 "red"
$ns color 2 "blue"

$n_(0)  label "Source/UDP0"
$n_(1)  label "Source/UDP1"
$n_(2)  label "Router"
$n_(3)  label "Dest/NULL"

$ns duplex-link $n_(0) $n_(2) 10Mb 300ms DropTail
$ns duplex-link $n_(1) $n_(2) 10Mb 300ms DropTail
$ns duplex-link $n_(3) $n_(2) 1Mb 300ms DropTail

 
$ns set queue-limit $n_(0) $n_(2) 10
$ns set queue-limit $n_(1) $n_(2) 10
$ns set queue-limit $n_(3) $n_(2) 5

set udp0 [new Agent/UDP]
$ns attach-agent $n_(0) $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n_(1) $udp1

set null [new Agent/Null]
$ns attach-agent $n_(3) $null

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

$cbr1 set packetSize_ 500Mb
$cbr1 set interval_ 0.005


$udp0 set class_ 1
$udp1 set class_ 2

$ns connect $udp0 $null
$ns connect $udp1 $null

proc finish {} {

global ns nf tf
$ns flush-trace 
exec nam lab1.nam &
close $nf
close $tf
exit 0
}

$ns at 0.1 "$cbr0 start"
$ns at 0.1 "$cbr1 start"
$ns at 4 "$cbr0 stop"
$ns at 4 "$cbr1 stop"
$ns at 5 "finish"
$ns run








