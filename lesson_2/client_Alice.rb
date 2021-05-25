require 'socket'
require 'openssl'
require 'securerandom'
require 'digest'

$hostname = '10.100.5.66'#'localhost'
$port = 5444

    sock = TCPSocket.open($hostname, $port)
    sock.puts "Alice"
	
	#ALICE losuje R1, R2, i sideOfCoin
	R1 = SecureRandom.random_number(1000..9999).to_s
	puts "R1\t" + R1.inspect
	R2 = SecureRandom.random_number(1000..9999).to_s
	puts "R2\t" + R2.inspect
	sideOfCoin = [0, 1].sample.to_s
	puts "sideOfCoin\t" + sideOfCoin.inspect
	to_hash = R1 + R2 + sideOfCoin
	puts "to_hash\t" + to_hash.inspect
	
	#ALICE generuje hash(R1,R2,sideOfCoin)
	hash = Digest::SHA512.hexdigest to_hash.to_s
	puts "hash\t" + hash.inspect
	
	#ALICE wysyla do BOBa hash i R1 ||||||||||||||||||||||| ALICE ==================>> BOB
	sock.puts hash
	puts "send hash to Bob"
	sock.puts R1
	puts "send R1 to Bob"
	
	#ALICE otrzymuje od BOBa jego hash i R1 ||||||||||||||| ALICE <<================== BOB
	Bob_hash1 = sock.gets.gsub(/\n$/, '')
	puts "Bob_hash1\t" + Bob_hash1.inspect
	Bob_R1 = sock.gets.gsub(/\n$/, '')
	puts "Bob_R1\t" + Bob_R1.inspect
	
	#ALICE odkrywa swoje sideOfCoin ||||||||||||||||||||||| ALICE ==================>> BOB
	sock.puts R1
	puts "send R1 to Bob"
	sock.puts R2
	puts "send R2 to Bob"
	sock.puts sideOfCoin
	puts "send sideOfCoin to Bob"
	
	#BOB odkrywa swoje sideOfCoin_Bob ||||||||||||||||||||| ALICE <<================== BOB
	Bob_R1p = sock.gets.gsub(/\n$/, '')
	puts "Bob_R1p\t" + Bob_R1p.inspect
	Bob_R2 = sock.gets.gsub(/\n$/, '')
	puts "Bob_R2\t" + Bob_R2.inspect
	sideOfCoin_Bob = sock.gets.gsub(/\n$/, '')
	puts "sideOfCoin_Bob\t" + sideOfCoin_Bob.inspect
	to_hash_Bob = Bob_R1p + Bob_R2 + sideOfCoin_Bob
	puts "to_hash_Bob\t" + to_hash_Bob.inspect
	Bob_hash2 = Digest::SHA512.hexdigest to_hash_Bob.to_s
	puts "Bob_hash2\t" + Bob_hash2.inspect
	
	if(Bob_hash1 == Bob_hash2)
		#RZUT MONETA
		throw = sideOfCoin_Bob.to_i ^ sideOfCoin.to_i
		puts "throw\t" + throw.inspect
	
		#SPRAWDZENIE ZWYCIEZCY
		if(sideOfCoin.to_i == throw.to_i)
			puts "WYGRANA"
		end
	
		if(sideOfCoin.to_i != throw.to_i)
			puts "PRZEGRANA"
		end
	end
	if(Bob_hash1 != Bob_hash2)
		puts "Bob oszukuje"
	end