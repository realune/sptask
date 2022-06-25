# frozen_string_literal: true

require_relative './customized_error'

# class for reading log file, parsing, ordering and printing data.
class Parser
  def initialize
    @page_views = {}
    @unique_page_views = {}
  end

  def desc_most_page_views(filepath)
    contents = read_file(filepath)
    # count most page views
    contents.each { |key, val| @page_views[key] = val.length }
    # desc sort
    @page_views = @page_views.sort_by { |_key, val| -val }.to_h
  end

  def desc_most_unique_page_views(filepath)
    contents = read_file(filepath)
    # remove duplicate ip
    contents.map { |key, val| @unique_page_views.store(key, val.uniq) }
    # count most page  views
    @unique_page_views.each { |key, val| @unique_page_views[key] = val.length }
    # desc sort
    @unique_page_views = @unique_page_views.sort_by { |_key, val| -val }.to_h
  end

  def read_file(filepath)
    raise CustomizedError::FileDoesNotExistError unless File.file?(filepath)

    contents = {}
    File.open(filepath, 'r') do |f|
      f.each_line do |line|
        url, ip = line.chomp.split(' ', 2)
        contents.key?(url) ? contents[url].push(ip) : contents[url] = [ip]
      end
    end
    raise CustomizedError::FileIsEmptyError if contents.empty?

    contents
  end

  def print_most_page_views
    return if @page_views.empty?

    puts 'List of webpages with most page views ordered from most pages views to less page views'
    @page_views.each do |content|
      if content[1] > 1
        puts "#{content[0]} #{content[1]} visits"
      else
        puts "#{content[0]} #{content[1]} visit"
      end
    end
  end

  def print_most_unique_page_views
    return if @unique_page_views.empty?

    puts 'List of webpages with most unique page views ordered from most unique pages views to less unique page views'
    @unique_page_views.each do |content|
      if content[1] > 1
        puts "#{content[0]} #{content[1]} unique views"
      else
        puts "#{content[0]} #{content[1]} unique view"
      end
    end
  end
end
