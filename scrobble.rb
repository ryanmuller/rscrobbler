require 'net/http'

require 'rubygems'
require 'json'

$:.push(File.dirname($0))
require 'utility-functions'

@programs = ["Skim"]

def send_scrobble(hashkey)
  @user = 'user'
  @pass = 'password'
  @host = 'localhost'
  @port = '3000'

  @post_ws = "/scrobbles"

  @payload ={
    "scrobble" => { "user_id" => "1", "hashkey" => hashkey }
    }.to_json
    
  def post
    req = Net::HTTP::Post.new(@post_ws, initheader = {'Content-Type' =>'application/json'})
    req.basic_auth @user, @pass
    req.body = @payload
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
    puts "Response #{response.code}"
  end

  thepost = post
end

@programs.each do |prog|
  `lsof | grep ^#{prog}.*pdf$ | awk '{ print $9 }' | sort -u >> pdfs.txt`
end

File.open('pdfs.txt') do |f| 
  f.lines.each do |line|
    hash = hashsum(line.chomp)
    send_scrobble(hash)
  end
end
`rm pdfs.txt`

