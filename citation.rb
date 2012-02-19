require 'net/http'

require 'rubygems'
require 'json'

require 'appscript'
include Appscript

$:.push(File.dirname($0))
require 'utility-functions'

@pdf_path = '/Users/ramuller/Dropbox/PDFs/*.pdf'
@bd = app("BibDesk").document

def send_citation(bibtex, hashkey)
  @user = 'user'
  @pass = 'password'
  @host = 'localhost'
  @port = '3000'

  @post_ws = "/citations"

  @payload ={ "bibtex" => bibtex, "hashkey" => hashkey }.to_json
    
  def post
    req = Net::HTTP::Post.new(@post_ws, initheader = {'Content-Type' =>'application/json'})
    req.basic_auth @user, @pass
    req.body = @payload
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }
    puts "Response #{response.code} #{response.body} #{response.message}"
  end

  post
end


if ARGV[0] == "batch"
  c=0
  path = @pdf_path 
  Dir[path].select  do |f| 
    fname = File.basename(f)
    citekey = fname[0..-5]
    puts citekey
    begin
      bibtx = @bd.search({:for =>citekey})[0].BibTeX_string.get.to_s
      hash = hashsum(f)
      send_citation(bibtx, hash)
    rescue
      puts "Not found"
      next
    end
    c = c+1
  end
  puts "Total #{c} entries added"
end

