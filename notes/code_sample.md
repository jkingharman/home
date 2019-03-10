title: Code Sample
date: 05-03-2019

The code you'll see here samples from a Ruby script that was written and tested in two hours.

What's the script do? It's passed a log as an argument — ```webserver.log``` — and outputs two lists. Both lists show webpage views that are sorted from most to least views. One list is of unique views, the other non-unique.

**Example Input:**

~~~shell
/help_page/1 126.318.035.038  
/contact 184.123.665.067  
/home 184.123.665.067  
/about/2 444.701.448.104  
/help_page/1 929.398.951.889  
/index 444.701.448.104  
/help_page/1 722.247.931.582  
...  
~~~
{: .hljs}
**Example Output:**

~~~shell
NON-UNIQUE VIEWS:
******************************
/about/2           | 810 visits
/contact           | 801 visits
/index             | 738 visits
/about             | 729 visits
/help_page/1       | 720 visits
/home              | 702 visits
******************************
~~~
{: .hljs}
~~~shell
UNIQUE VIEWS
******************************
/index             | 23 visits
/home              | 23 visits
/contact           | 23 visits
/help_page/1       | 23 visits
/about/2           | 22 visits
/about             | 21 visits
******************************
~~~
{: .hljs}
Writing this script was simple enough. I’ve picked an easy task as a sample for the same reason people build Todo apps when learning languages: it has simple requirements and so you’re freed up to think about the code’s concepts and design.

<br/>

{::options parse_block_html="true" /}

###### Code

<span> Folder structure: </span>
{::options parse_block_html="true" /}

~~~shell
├── Gemfile
├── Gemfile.lock
├── README.md
├── lib
│   ├── log_formatter.rb
│   ├── log_parser.rb
│   └── log_printer.rb
├── printer.rb
├── spec
│   ├── lib
│   │   ├── log_formatter_spec.rb
│   │   ├── log_parser_spec.rb
│   │   └── log_printer_spec.rb
│   ├── spec_helper.rb
│   └── support
│       └── webserver.log
└── webserver.log
~~~
{: .hljs}
<span class="subhead"> log_parser.rb </span>
{::options parse_block_html="true" /}

~~~ruby
class LogParser
  attr_reader :web_pages

  def initialize
    @web_pages = {}
  end

  def parse(log_path)
    read_log(log_path)
    add_pages_to_webpages
    add_ips_to_webpages
    web_pages
  end

  private

  attr_reader :entries

  def read_log(log_path)
    raise "No logfile found at: #{log_path}" unless File.exist?(log_path)
    @entries = File.new(log_path).readlines
  end

  def add_pages_to_webpages
    pages = entries.map { |entry| entry.split(/\s+/).first }.uniq
    pages.each { |page| web_pages[page.to_sym] = [] }
  end

  def add_ips_to_webpages
    entries.each do |entry|
      page = entry.split(/\s+/).first
      ip = entry.split(/\s+/).last
      web_pages[page.to_sym] << ip
    end
  end
end
~~~
{: .hljs}
`LogParser` parses the log. Each page (e.g ``"/about/2"``) becomes a hash key. Each key points to an array. Where a page is visited, an IP is pushed into its array. I don't keep state for visits and unique visits. I derive them from the IPs instead.

<span class="subhead"> log_formatter.rb </span>
{::options parse_block_html="true" /}

~~~ruby
class LogFormatter
  def most_views_to_least(web_pages)
    web_pages.sort_by { |_page, visits| visits.uniq.length }.reverse.to_h
  end

  def unique_most_views_to_least(web_pages)
    web_pages.sort_by { |_page, visits| visits.length }.reverse.to_h
  end
end
~~~
{: .hljs}
``LogFormatter`` exposes methods that format ``LogParser``'s `#parse` output. It formats by sorting pages by visit count.

<span class="subhead"> log_parser_spec.rb </span>
{::options parse_block_html="true" /}

~~~ruby
describe LogParser do
  describe "#parse" do
    let(:webserver_path) { "spec/support/webserver.log" }
    let(:wrong_path) { "./wrong/path" }

    let(:parse_result) {
        {:"/search/1"=>["126.318.035.038"],
        :"/now"=>["184.123.665.067"],
        :"/home"=>["184.123.665.067", "444.701.448.104"],
        :"/about/2"=>["444.701.448.104", "444.701.448.104", "444.701.448.104"],
        :"/sitemap"=>["929.398.951.889"],
        :"/index"=>["444.701.448.104"]}
    }

    it "raises a path file error on logfile absence" do
      expect{subject.parse(wrong_path)}.to raise_error(
        "No logfile found at: ./wrong/path"
      )
    end

    it "parses log lines correctly" do
      expect(subject.parse(webserver_path)).to eq parse_result
    end
  end
end
~~~
{: .hljs}
<br/>

{::options parse_block_html="true" /}

###### Comments

<span class="subhead"> log_parser.rb </span>
{::options parse_block_html="true" /}

I could have condensed ``LogParser``'s behaviour. Inside ``#parse``, I could have built
up ``@webpages`` in a single loop. Check it:

~~~ruby
...
def initialize
  @webpages = Hash.new { |hash, key| hash[key] = [] }
end

def parse(log_path)
  read_log(log_path)
  entries.each do |entry|
    page = entry.split(/\s+/).first
    ip = entry.split(/\s+/).last
    webpages[page.to_sym] << ip
  end
  webpages
end
...
~~~
{: .hljs}
This code is shorter but less declarative. Separating the population of ``@webpages`` into named functions lets us grok what ``LogParser`` does quickly.

I avoid nested loops, so time complexity stays low. But my code can be memory inefficient when most IP addresses are non-unique. If memory's an issue I might match on IPs and track visits:

~~~ruby
{{:"/search/1"=>{"126.318.035.038"=>3}}
~~~

<span class="subhead"> log_formatter.rb </span>
{::options parse_block_html="true" /}

I separate code that formats ``@webpages`` from code that presents it. My presenter class pretty prints the return values of ``LogFormatter``'s public methods.

<span class="subhead"> log_parser_spec.rb </span>
{::options parse_block_html="true" /}

I try to write cost-effective tests. Mostly, that means testing only a class's public interface. Tests that break with an underlying refactoring raise costs and establishes nothing
about the program's overall correctness.

``log_parser_spec.rb`` tests that ``#parse`` returns the correct state when given a valid path, an error when given an invalid one. I don't test internals.
