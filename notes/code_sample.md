title: Code sample
date: 3-03-2019

# Code Sample

This code samples from a Ruby script that was written and tested in two hours.

What's the script do? It receives a log as an argument -- ```webserver.log``` -- and output two lists. Both lists show webpage views that are sorted from most to least views. One list is of unique views, the other non-unique views.

Example output:

```
Page stats
******************************

Non-unique views:
/about/2 was visited 810 times
/contact was visited 801 times
/index was visited 738 times
/about was visited 729 times
/help_page/1 was visited 720 times
/home was visited 702 times

Unique views:
/index was visited 23 unique times
/home was visited 23 unique times
/contact was visited 23 unique times
/help_page/1 was visited 23 unique times
/about/2 was visited 22 unique times
/about was visited 21 unique times

******************************
```
The demands of writing this script fall below my technical limit. I’ve picked an easy task here for the same reason people build Todo apps when learning new languages. It has simple requirements and so you’re freed up to think about the code’s concepts and design.

# Samples

Structure:

```
.
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
```

Parser:

```
class LogParser
  attr_reader :web_pages

  def initialize
    @web_pages = {}
  end

  def parse(log_path)
    read_log(log_path)
    parse_pages
    parse_visits
    web_pages
  end

  private

  attr_reader :entries

  def read_log(log_path)
    raise "No logfile found at: #{log_path}" unless File.exist?(log_path)
    @entries = File.new(log_path).readlines
  end

  def parse_pages
    pages = entries.map { |record| record.split(' ').first }.uniq
    pages.each { |page| web_pages[page.to_sym] = [] }
  end

  def parse_visits
    entries.each do |record|
      page = record.split(' ').first
      visit = record.split(' ').last
      web_pages[page.to_sym] << visit
    end
  end
end
```
Formatter:

```
class LogFormatter
  def most_views_to_least(web_pages)
    [format_view_sort(web_pages), format_unique_view_sort(web_pages)]
  end

  private

  def sort_by_views(web_pages)
    web_pages.sort_by { |_page, visits| visits.length }.reverse.to_h
  end

  def sort_by_unique_views(web_pages)
    web_pages.sort_by { |_page, visits| visits.uniq.length }.reverse.to_h
  end

  def format_view_sort(web_pages)
    sort_by_views(web_pages).map do |page, visits|
      "#{page} was visited #{visits.count} times"
    end
  end

  def format_unique_view_sort(web_pages)
    sort_by_unique_views(web_pages).map do |page, visits|
      "#{page} was visited #{visits.uniq.count} unique times"
    end
  end
end
```

Parser spec:

```
require_relative "../spec_helper"

describe LogParser do
  describe "#parse" do
    let(:webserver_path) { "spec/support/webserver.log" }
    let(:wrong_path) { "./fake/path" }

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
        "No logfile found at: ./fake/path"
      )
    end

    it "parses log lines correctly" do
      expect(subject.parse(webserver_path)).to eq parse_result
    end
  end
end
```
